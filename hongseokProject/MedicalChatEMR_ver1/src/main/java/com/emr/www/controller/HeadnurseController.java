package com.emr.www.controller;

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
	

    // 환자 등록 처리
//    @PostMapping("/registerPatient")
//    @ResponseBody
//    public ResponseEntity<PatientDTO> registerPatient(@RequestBody PatientDTO patientDTO) {
//        PatientDTO savedPatient = patientService.registerPatient(patientDTO);
//        return ResponseEntity.ok(savedPatient);
//    }
    
//    @PostMapping("/registerPatient")
//    @ResponseBody
//    public ResponseEntity<?> registerPatient(@RequestBody PatientDTO patientDTO) {
//        log.info("Received PatientDTO: {}", patientDTO);
//        Patient patient = new Patient();
//        BeanUtils.copyProperties(patientDTO, patient);
//        log.info("Converted Patient entity: {}", patient);
//        Patient savedPatient = patientRepository.save(patient);
//        log.info("Saved Patient: {}", savedPatient);
//        return ResponseEntity.ok().body("Patient registered successfully");
//    }

	@PostMapping("/registerPatient")
	@ResponseBody
	public ResponseEntity<PatientDTO> registerPatient(@RequestBody PatientDTO patientDTO) {
	    log.info("Received PatientDTO: {}", patientDTO);
	    Patient savedPatient = patientService.registerPatient(patientDTO);
	    log.info("Saved Patient: {}", savedPatient);
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




