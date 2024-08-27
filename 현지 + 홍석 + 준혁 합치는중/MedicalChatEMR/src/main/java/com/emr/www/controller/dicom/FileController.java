package com.emr.www.controller.dicom;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/dicom")
public class FileController {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private DataSource dataSource;
	
	@GetMapping("/getPatientInfo")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getPatientInfo(@RequestParam("no") int no, @RequestParam("studydate") String studydate) {
	    Map<String, Object> patientInfo = new HashMap<>();
	    System.out.println("변수 no의 타입: " + ((Object) no).getClass().getSimpleName());
	    // DICOM 파일 목록만 가져오는 SQL 쿼리 (file_data 제외) + studydate 필터링
	    String dicomSql = "SELECT pid, pbirthdatetime, studydate, studytime, file_name, pname, modality, sop_instance_uid, annotations " +
	                      "FROM dicom_files WHERE pid = ? AND studydate = ?";

	    try (Connection conn = dataSource.getConnection()) {

	        // DICOM 파일 목록 가져오기 (file_data 제외)
	        List<Map<String, Object>> dicomFiles = new ArrayList<>();
	        try (PreparedStatement pstmt = conn.prepareStatement(dicomSql)) {
	            pstmt.setInt(1, no);  // 환자의 no 값을 pid로 사용
	            pstmt.setString(2, studydate);  // studydate 추가로 필터링
	            ResultSet rs = pstmt.executeQuery();
	            System.out.println("studydate : "+studydate);
	            while (rs.next()) {
	            	System.out.println("test2");
	                Map<String, Object> dicomFile = new HashMap<>();
	                dicomFile.put("pid", rs.getInt("pid"));
	                dicomFile.put("studydate", rs.getString("studydate"));
	                dicomFile.put("file_name", rs.getString("file_name"));
	                dicomFile.put("pname", rs.getString("pname"));
	                dicomFile.put("modality", rs.getString("modality"));
	                dicomFile.put("sop_instance_uid", rs.getString("sop_instance_uid"));
	                dicomFiles.add(dicomFile);
	            }
	        }

	        // DICOM 파일 목록 데이터를 함께 반환
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
	public String handleViewerRequest(@RequestParam("pid") int pid,
	                                  @RequestParam("studydate") String studydate,
	                                  Model model) {
	    System.out.println("viewer 요청 테스트");
	    try {
	        model.addAttribute("pid", pid);  // pid 값을 모델에 추가
	        model.addAttribute("studydate", studydate);  // studytime 값을 모델에 추가
	        return "doctor/viewer";  // JSP 페이지로 바로 전달
	    } catch (Exception e) {
	    	System.out.println("에러 테스트");
	        e.printStackTrace();
	        return "errorPage";  // 오류 페이지로 리다이렉트
	    }
	}



	@PostMapping("/saveAnnotations")
	public ResponseEntity<String> saveAnnotations(@RequestBody Map<String, Object> payload) {
	    try {

	        String sopInstanceUID = (String) payload.get("sopInstanceUID");
	        String annotations = (String) payload.get("annotations");

	        // 주석 데이터를 데이터베이스에 저장합니다.
	        String sql = "UPDATE dicom_files SET annotations = ? WHERE sop_instance_uid = ?";
	        jdbcTemplate.update(sql, annotations, sopInstanceUID);

	        return new ResponseEntity<>("주석이 성공적으로 저장되었습니다.", HttpStatus.OK);
	    } catch (Exception e) {
	        // 에러 로그 추가
	        e.printStackTrace();
	        return new ResponseEntity<>("주석 저장에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}




	// DICOM 다운로드
	@PostMapping("/downloadDICOM")
	public ResponseEntity<InputStreamResource> downloadDICOM(@RequestBody Map<String, Object> requestData) throws IOException {
	    List<String> fileNameList = (List<String>) requestData.get("fileNames");
	    String pname = (String) requestData.get("pname");
	    String modality = (String) requestData.get("modality");

	    String[] fileNameArray = fileNameList.toArray(new String[0]);

	    if (fileNameArray.length == 1) {
	        // 단일 파일 다운로드 로직
	        String fileSql = "SELECT file_data FROM dicom_files WHERE file_name = ?";
	        byte[] fileData = jdbcTemplate.queryForObject(fileSql, new Object[]{fileNameArray[0]}, byte[].class);

	        InputStreamResource resource = new InputStreamResource(new ByteArrayInputStream(fileData));
	        return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileNameArray[0] + "\"")
	                .contentType(MediaType.APPLICATION_OCTET_STREAM)
	                .body(resource);
	    } else {
	        // 여러 파일 ZIP으로 압축하여 다운로드
	        String zipFileName = pname + "_" + modality + "_dicom.zip";
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
	       
	        // UTF-8로 ZIP 파일 이름 인코딩
	        String encodedZipFileName = URLEncoder.encode(zipFileName, StandardCharsets.UTF_8.toString()).replaceAll("\\+", "%20");

	        return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedZipFileName)
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



	// 서버에서 DICOM 데이터를 전송하는 코드
	@GetMapping("/getDicom")
	public ResponseEntity<List<Map<String, Object>>> getFile(@RequestParam("pid") int pid, @RequestParam("studydate") String studydate) {
	    try {
	        // SQL 쿼리를 통해 데이터를 조회
	        String fileSql = "SELECT pid, pbirthdatetime, studydate, studytime, file_name, file_data, pname, modality, sop_instance_uid, annotations " +
	                         "FROM dicom_files WHERE pid = ? AND studydate = ?";
	        
	        List<Map<String, Object>> fileDataList = jdbcTemplate.query(fileSql, 
	            ps -> {
	                ps.setObject(1, pid);
	                ps.setObject(2, studydate);
	            }, 
	            (rs, rowNum) -> {
	                Map<String, Object> map = new HashMap<>();
	                map.put("pid", rs.getInt("pid"));
	                map.put("pbirthdatetime", rs.getString("pbirthdatetime"));
	                map.put("studydate", rs.getString("studydate"));
	                map.put("studytime", rs.getString("studytime"));
	                map.put("file_name", rs.getString("file_name"));
	                map.put("file_data", rs.getBytes("file_data")); // 이진 데이터를 그대로 가져옴
	                map.put("pname", rs.getString("pname"));
	                map.put("modality", rs.getString("modality"));
	                map.put("sop_instance_uid", rs.getString("sop_instance_uid"));
	                map.put("annotations", rs.getString("annotations")); // 주석 데이터를 추가
	                return map;
	            });

	        // 데이터가 없는 경우 404 반환
	        if (fileDataList.isEmpty()) {
	            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
	        }

	        // 데이터 리스트를 JSON으로 반환
	        return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON).body(fileDataList);

	    } catch (Exception e) {
	        e.printStackTrace();  // 예외 발생 시 콘솔에 출력
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
	    }
	}
}