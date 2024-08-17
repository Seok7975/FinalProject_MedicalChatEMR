package com.example.cornerstone;

import org.dcm4che3.data.Attributes;
import org.dcm4che3.data.Tag;
import org.dcm4che3.imageio.plugins.dcm.DicomImageReadParam;
import org.dcm4che3.io.DicomInputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.groupdocs.conversion.Converter;
import com.groupdocs.conversion.options.convert.ImageConvertOptions;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.sql.DataSource;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Controller
public class FileController {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private DataSource dataSource;

	@GetMapping("/")
	public String index() {
		return "index";
	}

	@PostMapping("/upload")
	public String handleFileUpload(@RequestParam("file") MultipartFile file, Model model) {
		if (file.isEmpty()) {
			return "error"; // 업로드 실패 시 처리
		}

		int fileId;	
		try {
			fileId = saveFileToDatabase(file);
		} catch (IOException | SQLException e) {
			e.printStackTrace();
			return "error"; // 저장 실패 시 처리
		}

		model.addAttribute("fileId", fileId);
		return "viewer"; // 업로드 후 viewer.html로 리다이렉트
	}

	private int saveFileToDatabase(MultipartFile file) throws IOException, SQLException {
	    String sql = "INSERT INTO dicom_files (" +
	            "file_name, file_data, STUDYINSUID, PATKEY, ACCESSNUM, " +
	            "STUDYDATE, STUDYTIME, STUDYID, EXAMCODE, STUDYDESC, MODALITY, " +
	            "BODYPART, PATIENTKEY, PID, PNAME, PSEX, PBIRTHDATETIME, PATAGE, " +
	            "EXAMSTATUS, REPORTSTATUS, SERIESCNT, IMAGECNT, VERIFYFLAG, VERIFYDATETIME, DEPT, sop_instance_uid) " +  // 추가된 sop_instance_uid 컬럼
	            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	    
	    String checkSql = "SELECT * FROM dicom_files WHERE file_name = ?";
	    Attributes attr;
	    
	    try (DicomInputStream dis = new DicomInputStream(file.getInputStream())) {
	        attr = dis.readDataset(-1, -1);
	    }

	    Map<String, Object> params = new HashMap<>();
	    params.put("file_name", file.getOriginalFilename());
	    params.put("file_data", file.getBytes());
	    params.put("STUDYINSUID", attr.getString(Tag.StudyInstanceUID));
	    params.put("PATKEY", attr.getString(Tag.PatientID));
	    params.put("ACCESSNUM", attr.getString(Tag.AccessionNumber));
	    params.put("STUDYDATE", attr.getString(Tag.StudyDate));
	    params.put("STUDYTIME", attr.getString(Tag.StudyTime));
	    params.put("STUDYID", attr.getString(Tag.StudyID));
	    params.put("EXAMCODE", attr.getString(Tag.ProcedureCodeSequence));
	    params.put("STUDYDESC", attr.getString(Tag.StudyDescription));
	    params.put("MODALITY", attr.getString(Tag.Modality));
	    params.put("BODYPART", attr.getString(Tag.BodyPartExamined));
	    params.put("PATIENTKEY", attr.getString(Tag.PatientID));
	    params.put("PID", attr.getString(Tag.PatientID));
	    params.put("PNAME", attr.getString(Tag.PatientName));
	    params.put("PSEX", attr.getString(Tag.PatientSex));
	    params.put("PBIRTHDATETIME", attr.getString(Tag.PatientBirthDate));
	    params.put("PATAGE", attr.getString(Tag.PatientAge));
	    params.put("EXAMSTATUS", attr.getInt(Tag.ImageIndex, 0));
	    params.put("REPORTSTATUS", attr.getString(Tag.CompletionFlag));
	    params.put("SERIESCNT", attr.getInt(Tag.NumberOfSeriesRelatedInstances, 0));
	    params.put("IMAGECNT", attr.getInt(Tag.NumberOfStudyRelatedInstances, 0));
	    params.put("VERIFYFLAG", attr.getString(Tag.VerificationFlag));
	    params.put("VERIFYDATETIME", attr.getString(Tag.InstanceCreationDate));
	    params.put("DEPT", attr.getString(Tag.InstitutionName));
	    params.put("sop_instance_uid", attr.getString(Tag.SOPInstanceUID)); // 추가된 sop_instance_uid 저장

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
	         PreparedStatement check = conn.prepareStatement(checkSql)) { 
	        
	        check.setString(1, (String) params.get("file_name"));
	        ResultSet rs = check.executeQuery();
	        
	        if(rs.next()) {
	            // 동일한 파일 이름이 이미 존재할 경우, 해당 파일의 ID를 반환
	            return rs.getInt("id");
	        } else {
	            ps.setString(1, (String) params.get("file_name"));
	            ps.setBytes(2, (byte[]) params.get("file_data"));            
	            ps.setString(3, (String) params.get("STUDYINSUID"));
	            ps.setString(4, (String) params.get("PATKEY"));
	            ps.setString(5, (String) params.get("ACCESSNUM"));
	            ps.setString(6, (String) params.get("STUDYDATE"));
	            ps.setString(7, (String) params.get("STUDYTIME"));
	            ps.setString(8, (String) params.get("STUDYID"));
	            ps.setString(9, (String) params.get("EXAMCODE"));
	            ps.setString(10, (String) params.get("STUDYDESC"));
	            ps.setString(11, (String) params.get("MODALITY"));
	            ps.setString(12, (String) params.get("BODYPART"));
	            ps.setString(13, (String) params.get("PATIENTKEY"));
	            ps.setString(14, (String) params.get("PID"));
	            ps.setString(15, (String) params.get("PNAME"));
	            ps.setString(16, (String) params.get("PSEX"));
	            ps.setString(17, (String) params.get("PBIRTHDATETIME"));
	            ps.setString(18, (String) params.get("PATAGE"));
	            ps.setInt(19, (Integer) params.get("EXAMSTATUS"));
	            ps.setString(20, (String) params.get("REPORTSTATUS"));
	            ps.setInt(21, (Integer) params.get("SERIESCNT"));
	            ps.setInt(22, (Integer) params.get("IMAGECNT"));
	            ps.setString(23, (String) params.get("VERIFYFLAG"));
	            ps.setString(24, (String) params.get("VERIFYDATETIME"));
	            ps.setString(25, (String) params.get("DEPT"));
	            ps.setString(26, (String) params.get("sop_instance_uid")); // 새로운 컬럼에 sop_instance_uid 삽입

	            ps.executeUpdate();

	            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
	                if (generatedKeys.next()) {
	                    return generatedKeys.getInt(1);
	                } else {
	                    throw new SQLException("Creating file failed, no ID obtained.");
	                }
	            }
	        }
	    }
	}

	
	@PostMapping("/saveAnnotations")
	public ResponseEntity<String> saveAnnotations(@RequestBody Map<String, Object> payload) {
	    try {
	        // 전달된 파일 ID와 주석 데이터를 가져옵니다.
	        Long fileId = Long.parseLong(payload.get("fileId").toString());
	        String annotations = payload.get("annotations").toString();

	        // 디버깅: 받은 데이터 출력
	        System.out.println("Received fileId: " + fileId);
	        System.out.println("Received annotations: " + annotations);
	        
	        // 주석 데이터를 데이터베이스에 저장합니다.
	        String sql = "UPDATE dicom_files SET annotations = ? WHERE id = ?";
	        jdbcTemplate.update(sql, annotations, fileId);

	        return new ResponseEntity<>("주석이 성공적으로 저장되었습니다.", HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>("주석 저장에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	
	// DICOM 다운로드
	@GetMapping("/downloadDICOM")
	public ResponseEntity<InputStreamResource> downloadDICOM(@RequestParam String fileNames, @RequestParam String pname, @RequestParam String modality) throws IOException {
	    String[] fileNameArray = fileNames.split(",");  // ,로 구분된 파일 이름 문자열을 배열로 변환
	    if (fileNameArray.length == 1) {
	        // 파일이 하나인 경우 개별 파일 다운로드
	        String fileSql = "SELECT file_data FROM dicom_files WHERE file_name = ?";
	        byte[] fileData = jdbcTemplate.queryForObject(fileSql, new Object[]{fileNameArray[0]}, byte[].class);

	        InputStreamResource resource = new InputStreamResource(new ByteArrayInputStream(fileData));
	        return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileNameArray[0] + "\"")
	                .contentType(MediaType.APPLICATION_OCTET_STREAM)
	                .body(resource);
	    } else {
	        // 파일이 여러 개인 경우 ZIP 파일로 압축
	        String zipFileName = pname +"_"+ modality + "_dcm.zip";
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        ZipOutputStream zos = new ZipOutputStream(baos);

	        for (String fileName : fileNameArray) {
	            String fileSql = "SELECT file_data FROM dicom_files WHERE file_name = ?";
	            byte[] fileData = jdbcTemplate.queryForObject(fileSql, new Object[]{fileName}, byte[].class);

	            ZipEntry zipEntry = new ZipEntry(fileName);
	            zos.putNextEntry(zipEntry);
	            zos.write(fileData);
	            zos.closeEntry();
	        }

	        zos.close();

	        InputStreamResource resource = new InputStreamResource(new ByteArrayInputStream(baos.toByteArray()));
	        return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + zipFileName + "\"")
	                .contentType(MediaType.APPLICATION_OCTET_STREAM)
	                .body(resource);
	    }
	}

    // JPG 다운로드
	@GetMapping("/downloadJPG")
	public ResponseEntity<InputStreamResource> downloadJPG(@RequestParam List<String> fileNames, @RequestParam String pname, @RequestParam String modality) throws IOException {
	    if (fileNames.size() == 1) {
	        String fileSql = "SELECT file_data FROM dicom_files WHERE file_name = ?";
	        byte[] fileData = jdbcTemplate.queryForObject(fileSql, new Object[]{fileNames.get(0)}, byte[].class);

	        ByteArrayInputStream bais = new ByteArrayInputStream(fileData);
	        BufferedImage image = convertDicomToJPG(bais);

	        ByteArrayOutputStream imageBaos = new ByteArrayOutputStream();
	        ImageIO.write(image, "jpg", imageBaos);

	        InputStreamResource resource = new InputStreamResource(new ByteArrayInputStream(imageBaos.toByteArray()));
	        return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileNames.get(0).replace(".dcm", ".jpg") + "\"")
	                .contentType(MediaType.IMAGE_JPEG)
	                .body(resource);
	    } else {
	        String zipFileName = pname +"_" + modality + "_images.zip";
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        ZipOutputStream zos = new ZipOutputStream(baos);

	        for (String fileName : fileNames) {
	            String fileSql = "SELECT file_data FROM dicom_files WHERE file_name = ?";
	            byte[] fileData = jdbcTemplate.queryForObject(fileSql, new Object[]{fileName}, byte[].class);

	            ByteArrayInputStream bais = new ByteArrayInputStream(fileData);
	            BufferedImage image = convertDicomToJPG(bais);

	            ByteArrayOutputStream imageBaos = new ByteArrayOutputStream();
	            ImageIO.write(image, "jpg", imageBaos);

	            ZipEntry zipEntry = new ZipEntry(fileName.replace(".dcm", ".jpg"));
	            zos.putNextEntry(zipEntry);
	            zos.write(imageBaos.toByteArray());
	            zos.closeEntry();
	        }

	        zos.close();

	        InputStreamResource resource = new InputStreamResource(new ByteArrayInputStream(baos.toByteArray()));
	        return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + zipFileName + "\"")
	                .contentType(MediaType.APPLICATION_OCTET_STREAM)
	                .body(resource);
	    }
	}

	// DICOM 파일 삭제
	@PostMapping("/deleteDICOM")
	public ResponseEntity<String> deleteDICOM(@RequestParam String fileName) {
	    try {
	        String deleteSql = "DELETE FROM dicom_files WHERE file_name = ?";
	        jdbcTemplate.update(deleteSql, fileName);

	        return ResponseEntity.ok("파일이 성공적으로 삭제되었습니다.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("파일 삭제에 실패했습니다.");
	    }
	}


    private BufferedImage convertDicomToJPG(InputStream dicomInputStream) throws IOException {
        // GroupDocs Converter 인스턴스 생성
        Converter converter = new Converter(dicomInputStream);

        // JPG로 변환 옵션 설정
        ImageConvertOptions options = new ImageConvertOptions();
        options.setFormat(com.groupdocs.conversion.filetypes.ImageFileType.Jpg);

        // 변환 결과를 ByteArrayOutputStream으로 저장
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        converter.convert(() -> outputStream, options);

        // ByteArrayInputStream을 통해 BufferedImage로 변환
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(outputStream.toByteArray());
        BufferedImage image = ImageIO.read(byteArrayInputStream);

        return image;
    }
	

	@GetMapping("/dicom")
	public ResponseEntity<List<Map<String, Object>>> getFile(@RequestParam("id") int id) {
	    try {
	        // 1. ID를 통해 해당 레코드의 MODALITY 값을 가져옵니다.
	        String modalitySql = "SELECT modality FROM dicom_files WHERE id = ?";
	        String modality = jdbcTemplate.queryForObject(modalitySql, new Object[]{id}, String.class);
	        System.out.println("Modality retrieved: " + modality);

	        // 2. 해당 MODALITY 값을 가진 모든 파일 데이터를 가져옵니다.
	        String fileSql = "SELECT file_name, file_data, pname, modality, sop_instance_uid, annotations FROM dicom_files WHERE modality = ?";
	        List<Map<String, Object>> fileDataList = jdbcTemplate.query(fileSql, new Object[]{modality}, (rs, rowNum) -> {
	            Map<String, Object> map = new HashMap<>();
	            map.put("file_name", rs.getString("file_name"));
	            map.put("file_data", Base64.getEncoder().encodeToString(rs.getBytes("file_data"))); // Base64로 인코딩
	            map.put("pname", rs.getString("pname"));
	            map.put("modality", rs.getString("modality"));
	            map.put("sop_instance_uid", rs.getString("sop_instance_uid"));
	            map.put("annotations", rs.getString("annotations")); // 주석 데이터를 추가
	            return map;
	        });
	        System.out.println("File data list size: " + fileDataList.size());

	        // 3. 파일 데이터가 없을 경우 404를 반환합니다.
	        if (fileDataList.isEmpty()) {
	            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	        }

	        // 4. 파일 데이터 리스트를 JSON으로 반환합니다.
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);

	        return new ResponseEntity<>(fileDataList, headers, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();  // 콘솔에 예외를 출력하여 어떤 오류가 발생했는지 확인
	        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
}
