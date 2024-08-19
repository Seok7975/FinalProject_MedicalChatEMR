//package com.emr.www.controller.employee;
//
//import java.util.HashMap;
//import java.util.Map;
//import java.util.Optional;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import com.emr.www.repository.doctor.DoctorRepository;
//import com.emr.www.repository.nurse.NurseRepository;
//
//@RestController
//@RequestMapping("/employee")
//public class EmployeeLoginController {
//
//	@Autowired
//	private DoctorRepository doctorRepository;
//
//	@Autowired
//	private NurseRepository nurseRepository;
//	
//	 @PostMapping("/login")
//	    public ResponseEntity<Map<String, String>> login(@RequestBody Map<String, String> loginRequest) {
//	        String licenseId = loginRequest.get("licenseId");
//	        String password = loginRequest.get("password");
//
//	        // 의사 테이블에서 검사
//	        Optional<DoctorEntity> doctorOpt = doctorRepository.findByLicenseIdAndPassword(licenseId, password);
//	        if (doctorOpt.isPresent()) {
//	            DoctorEntity doctor = doctorOpt.get();
//	            // 진료중 상태로 변경 (데이터베이스 업데이트)
//	            doctor.setActiveStatus("진료 중");
//	            doctorRepository.save(doctor);
//
//	            // 의사 메인 페이지로 리다이렉션
//	            Map<String, String> response = new HashMap<>();
//	            response.put("redirectUrl", "/doctor/main"); // 리다이렉트 할 URL
//	            return ResponseEntity.ok(response);
//	        }
//
//	        // 간호사 테이블에서 검사
//	        Optional<NurseEntity> nurseOpt = nurseRepository.findByLicenseIdAndPassword(licenseId, password);
//	        if (nurseOpt.isPresent()) {
//	            NurseEntity nurse = nurseOpt.get();
//	            // 진료중 상태로 변경 (데이터베이스 업데이트)
//	            nurse.setActiveStatus("진료 중");
//	            nurseRepository.save(nurse);
//
//	            // 간호사 메인 페이지 또는 수간호사 메인 페이지로 리다이렉션
//	            Map<String, String> response = new HashMap<>();
//	            if (nurse.getRole().equals("S")) {
//	                response.put("redirectUrl", "/headNurse/main"); // 수간호사 메인 페이지
//	            } else {
//	                response.put("redirectUrl", "/nurse/main"); // 일반 간호사 메인 페이지
//	            }
//	            return ResponseEntity.ok(response);
//	        }
//
//	        // 로그인 실패 시
//	        Map<String, String> errorResponse = new HashMap<>();
//	        errorResponse.put("message", "Invalid credentials");
//	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
//	    }
//	}
//}
