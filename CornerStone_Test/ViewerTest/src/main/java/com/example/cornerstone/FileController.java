package com.example.cornerstone;

import org.dcm4che3.data.Attributes;
import org.dcm4che3.data.Tag;
import org.dcm4che3.io.DicomInputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
				"EXAMSTATUS, REPORTSTATUS, SERIESCNT, IMAGECNT, VERIFYFLAG, VERIFYDATETIME, DEPT) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
				PreparedStatement check = conn.prepareStatement(checkSql);
				) { 
			
			check.setString(1,(String) params.get("file_name"));
			ResultSet rs = check.executeQuery();
			
			if(rs.next())
			{
	            // 동일한 파일 이름이 이미 존재할 경우, 해당 파일의 ID를 반환
				return rs.getInt("id");
			}
			else {
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

	@GetMapping("/dicom")
	public ResponseEntity<List<Map<String, Object>>> getFile(@RequestParam("id") int id) {
	    try {
	        // 1. ID를 통해 해당 레코드의 MODALITY 값을 가져옵니다.
	        String modalitySql = "SELECT modality FROM dicom_files WHERE id = ?";
	        String modality = jdbcTemplate.queryForObject(modalitySql, new Object[]{id}, String.class);
	        System.out.println("Modality retrieved: " + modality);

	        // 2. 해당 MODALITY 값을 가진 모든 파일 데이터를 가져옵니다.
	        String fileSql = "SELECT file_name, file_data FROM dicom_files WHERE modality = ?";
	        List<Map<String, Object>> fileDataList = jdbcTemplate.query(fileSql, new Object[]{modality}, (rs, rowNum) -> {
	            Map<String, Object> map = new HashMap<>();
	            map.put("file_name", rs.getString("file_name"));
	            map.put("file_data", Base64.getEncoder().encodeToString(rs.getBytes("file_data"))); // Base64로 인코딩
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
