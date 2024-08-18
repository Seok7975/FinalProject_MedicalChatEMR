package com.emr.www.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emr.www.dto.PatientDTO;
import com.emr.www.entity.Patient;
import com.emr.www.repository.PatientRepository;
import com.emr.www.service.PatientService;
import com.emr.www.util.SecurityNumValidator;


@Controller
@RequestMapping("/headnurse") // 이 컨트롤러의 모든 메서드는 /headnurse로 시작하는 URL에 매핑(우리가 url을 입력하는것과 관련)
public class HeadnurseController {
	
    @Autowired
    private PatientService patientService;

    @Autowired
    private PatientRepository patientRepository;
    
    private static final Logger log = LoggerFactory.getLogger(PatientService.class);
	
	//test용
	@GetMapping("/hello")
	@ResponseBody
	public String test() {
		return "hello";
	}
	
	// 메인 화면
	@GetMapping("/headNurseMain") // 이 메서드는 GET /headnurse/headNurseMain 요청을 처리합니다.(우리가 url을 입력하는것과 관련)
	public String headNurseMain(Model model) {
		System.out.println("headNurseMain method called");
		return "headnurse/headNurseMain"; // 뷰의 이름을 반환, 뷰 리졸버는 이 이름을 사용하여 실제 뷰 파일(예: JSP)을 찾습니다.
	}
	

    // 주민등록번호 유효성 검사 API
    @PostMapping("/validateSecurityNum")
    @ResponseBody
    public ResponseEntity<String> validateSecurityNum(@RequestBody Map<String, String> requestData) {
    	String securityNum = requestData.get("securityNum").trim(); // JSON에서 securityNum 값을 추출
    	log.info("유효성 검사를 위해 받은 주민등록번호 : {}", securityNum);

        if (securityNum == null || securityNum.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("주민등록번호가 누락되었거나 비어 있습니다.");
        }
        
        // 주민등록번호 유효성 검사
        if (SecurityNumValidator.isValid(securityNum)) {
            log.info("주민등록번호 {}는 유효합니다.", securityNum);
            return ResponseEntity.ok("주민등록번호 {}는 유효하지 않습니다.");
        } else {
            log.warn("Security number {} is invalid.", securityNum);
            return ResponseEntity.badRequest().body("유효하지 않은 주민등록번호입니다.");
        }
    }
    
	// 환자 등록 처리
    @PostMapping("/registerPatient")
    @ResponseBody
    public ResponseEntity<PatientDTO> registerPatient(@RequestBody PatientDTO patientDTO) {
        log.info("받은 환자 DTO : {}", patientDTO);
        
        // 주민등록번호 중복 체크(rest api)
        if (patientService.isSecurityNumExists(patientDTO.getSecurityNum())) {
            log.warn("주민등록번호 {} 를 가진 환자가 이미 존재합니다.", patientDTO.getSecurityNum());
            return ResponseEntity.status(409).body(null); // Conflict 상태 코드 반환
        }
        
        // 환자 등록 
        Patient savedPatient = patientService.registerPatient(patientDTO);
        log.info("저장된 환자 : {}", savedPatient);
        
        // 저장된 환자를 DTO로 변환하여 반환
        PatientDTO savedPatientDTO = new PatientDTO();
        BeanUtils.copyProperties(savedPatient, savedPatientDTO);
        return ResponseEntity.ok(savedPatientDTO);
    }

    // 환자 조회
    @GetMapping("/patient/{securityNum}")
    @ResponseBody
    public ResponseEntity<PatientDTO> getPatient(@PathVariable String securityNum) {
        PatientDTO patient = patientService.getPatientBySecurityNum(securityNum);
        if (patient != null) {
            return ResponseEntity.ok(patient);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
	
}




