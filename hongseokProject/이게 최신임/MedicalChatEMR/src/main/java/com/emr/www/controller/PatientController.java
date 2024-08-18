package com.emr.www.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emr.www.dto.PatientDTO;
import com.emr.www.entity.Patient;
import com.emr.www.service.PatientService;
import com.emr.www.util.SecurityNumValidator;

@Controller
@RequestMapping("/api/patients") // 경로를 /api/patients로 설정
public class PatientController {

	@Autowired
	private PatientService patientService;
	
//	@Autowired
//  	private PatientRepository patientRepository;
	
    private static final Logger log = LoggerFactory.getLogger(PatientService.class);
    
    // 주민등록번호 유효성 검사 API
    @PostMapping("/validateSecurityNum")
    @ResponseBody
    public ResponseEntity<String> validateSecurityNum(@RequestBody Map<String, String> requestData) {
    	String securityNum = requestData.get("securityNum").trim(); // JSON에서 securityNum 값을 추출
    	log.info("유효성 검사를 위해 받은 주민등록번호 : {}\n", securityNum);

        if (securityNum == null || securityNum.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("주민등록번호가 누락되었거나 비어 있습니다.");
        }
        
        // 주민등록번호 유효성 검사
        if (SecurityNumValidator.isValid(securityNum)) {
            log.info("주민등록번호 {}는 유효합니다.", securityNum);
            return ResponseEntity.ok("주민등록번호 {}는 유효하지 않습니다.\n");
        } else {
            log.warn("Security number {} is invalid.", securityNum);
            return ResponseEntity.badRequest().body("유효하지 않은 주민등록번호입니다.\n");
        }
    }
    
	// 환자 등록 처리
    @PostMapping("/registerPatient")
    @ResponseBody
    public ResponseEntity<PatientDTO> registerPatient(@RequestBody PatientDTO patientDTO) {
        log.info("받은 환자 DTO : {}\n", patientDTO);
        
        // 주민등록번호 중복 체크(rest api)
        if (patientService.isSecurityNumExists(patientDTO.getSecurityNum())) {
            log.warn("주민등록번호 {} 를 가진 환자가 이미 존재합니다.\n", patientDTO.getSecurityNum());
            return ResponseEntity.status(409).body(null); // Conflict 상태 코드 반환
        }
        
        // 환자 등록 
        Patient savedPatient = patientService.registerPatient(patientDTO);
        log.info("저장된 환자 : {}\n", savedPatient);
        
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

//    // 환자 이름으로 검색
//    @GetMapping("/search")
//    public ResponseEntity<List<PatientDTO>> searchPatientsByName(@RequestParam("name") String name) {
//        List<PatientDTO> patients = patientService.findByName(name);
//        return ResponseEntity.ok(patients);
//    }
//
//    // 환자 내원 처리
//    @PostMapping("/visit")
//    public ResponseEntity<String> registerPatientVisit(@RequestBody PatientDTO patientVisitDTO) {
//        log.info("환자 내원 정보: {}", patientVisitDTO);
//        
//        PatientDTO patient = patientService.getPatientByNameAndSecurityNum(
//                patientVisitDTO.getName(), patientVisitDTO.getSecurityNum());
//
//        if (patient != null) {
//            // 필요한 내원 정보를 업데이트하거나 저장하는 로직 추가
//            patientService.registerPatientVisit(patient, patientVisitDTO);
//            return ResponseEntity.ok("환자 내원이 성공적으로 처리되었습니다.");
//        } else {
//            return ResponseEntity.badRequest().body("해당 정보와 일치하는 환자가 존재하지 않습니다.");
//        }
//    }
}