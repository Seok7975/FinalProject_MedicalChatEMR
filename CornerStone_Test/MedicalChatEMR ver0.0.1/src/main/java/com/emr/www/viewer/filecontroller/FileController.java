package com.emr.www.viewer.filecontroller;

import org.dcm4che3.data.Attributes;
import org.dcm4che3.data.Tag;
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

import javax.sql.DataSource;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
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


	@GetMapping("/doctorUI")
	public String handleFileUpload(Model model) {
	    // 환자 정보 리스트를 저장할 리스트
	    List<Map<String, Object>> patientList = new ArrayList<>();

	    // SQL 쿼리: 환자 정보를 조회합니다.
	    String sql = "SELECT no, name, securityNum, gender, address, phone, email, bloodType, height, weight, allergies, bloodPressure, temperature, smokingStatus FROM PatientRegistrations";

	    // 데이터베이스 연결 및 쿼리 실행
	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        // 결과셋에서 환자 정보를 가져와 리스트에 저장
	        while (rs.next()) {
	            Map<String, Object> patient = new HashMap<>();
	            patient.put("no",rs.getInt("no"));
	            patient.put("name", rs.getString("name"));
	            patientList.add(patient);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    System.out.println("Patient List: " + patientList);

	    // JSP에서 사용할 모델에 환자 리스트를 추가
	    model.addAttribute("patientList", patientList);

	    // JSP 파일로 반환
	    return "doctor/DoctorMain";
	}

	
	@GetMapping("/getPatientInfo")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getPatientInfo(@RequestParam("no") int no) {
	    Map<String, Object> patientInfo = new HashMap<>();
	    
	    // 환자 정보를 가져오는 SQL 쿼리
	    String patientSql = "SELECT * FROM PatientRegistrations WHERE no = ?";
	    
	    // DICOM 파일 목록만 가져오는 SQL 쿼리 (file_data 제외)
	    String dicomSql = "SELECT pid, pbirthdatetime, studydate, studytime, file_name, pname, modality, sop_instance_uid, annotations FROM dicom_files WHERE pid = ?";

	    try (Connection conn = dataSource.getConnection()) {
	        // 환자 정보 가져오기
	        try (PreparedStatement pstmt = conn.prepareStatement(patientSql)) {
	            pstmt.setInt(1, no);
	            ResultSet rs = pstmt.executeQuery();

	            if (rs.next()) {
	                patientInfo.put("no", rs.getInt("no"));
	                patientInfo.put("name", rs.getString("name"));
	                patientInfo.put("securityNum", rs.getString("securityNum"));
	                patientInfo.put("gender", rs.getString("gender"));
	                patientInfo.put("address", rs.getString("address"));
	                patientInfo.put("phone", rs.getString("phone"));
	                patientInfo.put("email", rs.getString("email"));
	                patientInfo.put("bloodType", rs.getString("bloodType"));
	                patientInfo.put("height", rs.getFloat("height"));
	                patientInfo.put("weight", rs.getFloat("weight"));
	                patientInfo.put("allergies", rs.getString("allergies"));
	                patientInfo.put("bloodPressure", rs.getString("bloodPressure"));
	                patientInfo.put("temperature", rs.getBigDecimal("temperature"));
	                patientInfo.put("smokingStatus", rs.getString("smokingStatus"));
	            }
	        }

	        // DICOM 파일 목록 가져오기 (file_data 제외)
	        List<Map<String, Object>> dicomFiles = new ArrayList<>();
	        try (PreparedStatement pstmt = conn.prepareStatement(dicomSql)) {
	            pstmt.setInt(1, no);  // 환자의 no 값을 pid로 사용
	            ResultSet rs = pstmt.executeQuery();

	            while (rs.next()) {
	                Map<String, Object> dicomFile = new HashMap<>();
	                dicomFile.put("pid", rs.getInt("pid"));
	                dicomFile.put("pbirthdatetime", rs.getString("pbirthdatetime"));
	                dicomFile.put("studydate", rs.getString("studydate"));
	                dicomFile.put("studytime", rs.getString("studytime"));
	                dicomFile.put("file_name", rs.getString("file_name"));
	                dicomFile.put("pname", rs.getString("pname"));
	                dicomFile.put("modality", rs.getString("modality"));
	                dicomFile.put("sop_instance_uid", rs.getString("sop_instance_uid"));
	                dicomFile.put("annotations", rs.getString("annotations")); // 주석 데이터 추가
	                dicomFiles.add(dicomFile);
	            }
	        }

	        // 환자 정보와 DICOM 파일 목록 데이터를 함께 반환
	        patientInfo.put("dicomFiles", dicomFiles);
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body(Map.of("message", "An error occurred while fetching patient info and DICOM files"));
	    }

	    return ResponseEntity.ok(patientInfo);
	}

	@GetMapping("/getDicomFile")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getDicomFile(@RequestParam("file_name") String fileName) {
	    Map<String, Object> dicomFile = new HashMap<>();

	    // DICOM 파일 데이터 가져오기 쿼리
	    String dicomSql = "SELECT file_data FROM dicom_files WHERE file_name = ? LIMIT 1";  // file_name 기반 조회

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(dicomSql)) {

	        // file_name을 사용해 DICOM 파일을 조회
	        pstmt.setString(1, fileName);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            byte[] fileData = rs.getBytes("file_data");
	            if (fileData != null && fileData.length > 0) {
	                dicomFile.put("file_data", Base64.getEncoder().encodeToString(fileData)); // Base64 인코딩된 file_data 반환
	            } else {
	                // 데이터가 없는 경우 404 Not Found 반환
	                return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                                     .body(Map.of("message", "DICOM file data not found"));
	            }
	        } else {
	            // 결과가 없는 경우 404 Not Found 반환
	            return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                                 .body(Map.of("message", "DICOM file not found"));
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body(Map.of("message", "An error occurred while fetching DICOM file data"));
	    }

	    return ResponseEntity.ok(dicomFile);
	}


	
	@PostMapping("/viewer")
	public String handleViewerRequest(@RequestBody Map<String, Object> data, Model model) {
	    try {
	        int pid = (Integer) data.get("pid");
	        String studytime = (String) data.get("studytime");
	        model.addAttribute("pid", pid);  // pid 값을 모델에 추가
	        model.addAttribute("studytime", studytime);  // studytime 값을 모델에 추가
	        return "doctor/viewer";  // JSP 페이지로 바로 전달
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "errorPage";  // 오류 페이지로 리다이렉트
	    }
	}
	
	@GetMapping("/viewer")
	public String showViewerPage(@RequestParam(name = "pid", required = false, defaultValue = "0") int pid,
	                             @RequestParam(name = "studytime", required = false) String studytime,
	                             Model model) {
	    if (pid == 0) {
	        // pid 값이 없을 때의 처리 로직
	        model.addAttribute("errorMessage", "PID 값이 없습니다.");
	        return "errorPage";
	    }
	    model.addAttribute("pid", pid);
	    model.addAttribute("studytime", studytime);  // studytime 값을 모델에 추가
	    return "doctor/viewer";  // viewer 페이지로 이동
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
	        // SOPInstanceUID를 사용하여 각 파일별로 주석을 저장
	        String sopInstanceUID = payload.get("sopInstanceUID").toString();
	        String annotations = payload.get("annotations").toString();

	        // 디버깅: 받은 데이터 출력
	        System.out.println("Received sopInstanceUID: " + sopInstanceUID);
	        System.out.println("Received annotations: " + annotations);

	        // 주석 데이터를 데이터베이스에 저장합니다.
	        String sql = "UPDATE dicom_files SET annotations = ? WHERE sop_instance_uid = ?";
	        jdbcTemplate.update(sql, annotations, sopInstanceUID);

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
			String zipFileName = pname +"_"+ modality + "_dicom.zip";
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



	@GetMapping("/dicom")
	public ResponseEntity<List<Map<String, Object>>> getFile(@RequestParam("pid") int pid, @RequestParam("studytime") String studytime) {
	    try {
	        // studytime을 사용하여 필터링된 DICOM 파일 가져오기
	        String fileSql = "SELECT * FROM dicom_files WHERE pid = ? AND studytime = ?";
	        List<Map<String, Object>> fileDataList = jdbcTemplate.query(fileSql, new Object[]{pid, studytime}, (rs, rowNum) -> {
	            Map<String, Object> map = new HashMap<>();
	            map.put("pid", rs.getInt("pid"));
	            map.put("pbirthdatetime", rs.getString("pbirthdatetime"));
	            map.put("studydate", rs.getString("studydate"));
	            map.put("studytime", rs.getString("studytime"));
	            map.put("file_name", rs.getString("file_name"));
	            map.put("file_data", Base64.getEncoder().encodeToString(rs.getBytes("file_data"))); // Base64로 인코딩
	            map.put("pname", rs.getString("pname"));
	            map.put("modality", rs.getString("modality"));
	            map.put("sop_instance_uid", rs.getString("sop_instance_uid"));
	            map.put("annotations", rs.getString("annotations")); // 주석 데이터를 추가
	            return map;
	        });

	        // 1. 파일 데이터가 없을 경우 404를 반환합니다.
	        if (fileDataList.isEmpty()) {
	            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	        }

	        // 2. 파일 데이터 리스트를 JSON으로 반환합니다.
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.APPLICATION_JSON);

	        return new ResponseEntity<>(fileDataList, headers, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();  // 콘솔에 예외를 출력하여 어떤 오류가 발생했는지 확인
	        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
}
