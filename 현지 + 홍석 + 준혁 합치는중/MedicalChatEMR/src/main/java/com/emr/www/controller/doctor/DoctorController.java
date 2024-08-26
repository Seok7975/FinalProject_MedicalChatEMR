package com.emr.www.controller.doctor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.emr.www.dto.patient.MedicalRecordDTO;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.util.jwt.JwtTokenUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

	@Autowired
	private DoctorService dorctorService;

	@Autowired
	private JwtTokenUtil jwtTokenUtil;
	
	@Autowired
	private DataSource dataSource;

	@GetMapping("/main")
	public String showDoctorMainPage(Model model) {	    // 환자 정보 리스트를 저장할 리스트
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
	    return "doctor/DoctorMain";// "WEB-INF/views/doctor/DoctorMain.jsp"를 의미
	}

	@PostMapping("/saveRecord")
	@Transactional
	public ResponseEntity<String> saveMedicalRecord(@RequestBody MedicalRecordDTO recordDTO, HttpServletRequest request) { //HttpServletRequest로 토큰 추출
		try {
			//JWT 토큰 추출 및 검증
			String token = jwtTokenUtil.resolveToken(request);
			if (token == null || !jwtTokenUtil.validateToken(token)) {
				return ResponseEntity.status(401).body("유효하지 않은 토큰입니다.");
			}

			//JWT 토큰에서 인증된 의사의 주키(no) 추출
			int doctorNo = jwtTokenUtil.extractNo(token);

			//서비스 레이어로 요청 전달
			dorctorService.saveMedicalRecord(recordDTO, doctorNo);
			return ResponseEntity.ok("진료 기록이 저장되었습니다.");
		} catch (Exception e) {
			return ResponseEntity.status(500).body("저장 실패 : " + e.getMessage());
		}
	}

}