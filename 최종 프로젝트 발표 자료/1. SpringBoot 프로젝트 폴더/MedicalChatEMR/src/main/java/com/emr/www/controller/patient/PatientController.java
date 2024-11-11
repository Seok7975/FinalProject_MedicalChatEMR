package com.emr.www.controller.patient;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.emr.www.dto.doctor.DoctorDTO;
import com.emr.www.dto.nurse.NurseDTO;
import com.emr.www.dto.patient.MedicalRecordDTO;
import com.emr.www.dto.patient.PatientDTO;
import com.emr.www.dto.patient.PatientRegistrationsDTO;
import com.emr.www.dto.patient.PatientSummaryDTO;
import com.emr.www.dto.patient.PatientVisitDTO;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.entity.patient.PatientRegistrationEntity;
import com.emr.www.repository.patient.PatientRegistrationRepository;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.nurse.NurseService;
import com.emr.www.service.patient.PatientService;
import com.emr.www.util.headnurse.SecurityNumValidator;

@RestController // 모든 메서드가 @ResponseBody를 포함
@RequestMapping("/api/patients") // 경로를 /api/patients로 설정
public class PatientController {

	@Autowired
	private DoctorService doctorService;

	@Autowired
	private NurseService nurseService;

	@Autowired
	private PatientService patientService;

	@Autowired
	private PatientRegistrationRepository patientRepository;

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
			log.warn("주민등록번호 {}는 유효하지않습니다.", securityNum);
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
		PatientRegistrationEntity savedPatient = patientService.registerPatient(patientDTO);
		log.info("저장된 환자 : {}\n", savedPatient);

		// 저장된 환자를 DTO로 변환하여 반환
		PatientDTO savedPatientDTO = new PatientDTO();
		BeanUtils.copyProperties(savedPatient, savedPatientDTO);
		return ResponseEntity.ok(savedPatientDTO);
	}

	// 환자등록(중복된 환자 조회)
	@GetMapping("securityNum/{securityNum}")
	@ResponseBody
	public ResponseEntity<PatientDTO> getPatient(@PathVariable String securityNum) {
		PatientDTO patient = patientService.getPatientBySecurityNum(securityNum);
		if (patient != null) {
			return ResponseEntity.ok(patient);
		} else {
			return ResponseEntity.notFound().build();
		}
	}

	// 이름으로 환자 검색 API
	@GetMapping("/search")
	public ResponseEntity<List<PatientDTO>> searchPatients(@RequestParam String name) {
		List<PatientRegistrationEntity> patients = patientRepository.findByNameStartingWith(name);
		List<PatientDTO> patientDTOs = patients.stream().map(patient -> {
			PatientDTO dto = new PatientDTO();
			BeanUtils.copyProperties(patient, dto);
			return dto;
		}).collect(Collectors.toList());
		return ResponseEntity.ok(patientDTOs);
	}

	// 환자의 내원 정보를 등록
	@PostMapping("/visitPatient")
	public ResponseEntity<String> registerPatientVisit(@RequestBody PatientVisitDTO patientVisitDTO) {

	    log.info("환자 내원 등록 요청 수신(받은 JSON 데이터): {}\n", patientVisitDTO);
	    try {
	        // 환자 내원 등록 서비스 호출
	        patientService.registerPatientVisit(patientVisitDTO);
	        log.info("환자 내원 등록 성공: {}\n", patientVisitDTO);
	        return ResponseEntity.ok("내원이 성공적으로 등록되었습니다.");
	    } catch (IllegalArgumentException e) {
	        log.error("환자 내원 등록 중 오류 발생 (잘못된 입력): {}\n", e.getMessage());
	        return ResponseEntity.badRequest().body(e.getMessage());
	    } catch (Exception e) {
	        log.error("환자 내원 등록 중 시스템 오류 발생: {}\n", e.getMessage(), e);
	        return ResponseEntity.status(500).body("내원 등록 중 오류가 발생했습니다.");
	    }
	}


	@GetMapping("/doctors")
	public ResponseEntity<List<DoctorDTO>> getAllDoctors() {
		List<DoctorEntity> doctors = doctorService.getAllDoctors();
		List<DoctorDTO> doctorDTOs = doctors.stream().map(doctorService::convertEntityToDto)
				.collect(Collectors.toList());
		return ResponseEntity.ok(doctorDTOs);
	}

	@GetMapping("/nurses")
	public ResponseEntity<List<NurseDTO>> getAllNurses() {
		List<NurseEntity> nurses = nurseService.getAllNurses();
		List<NurseDTO> nurseDTOs = nurses.stream().map(nurseService::convertEntityToDto).collect(Collectors.toList());
		return ResponseEntity.ok(nurseDTOs);
	}

	/*
	 * --------------------------------------------------------------공통
	 * 로직---------------------------------------------------------
	 */

	// 환자 목록 페이징 처리 (PatientSummaryDTO 사용)
	// 환자 목록을 offset과 limit을 사용해서 부분적으로 불러옴
	@GetMapping("/patientList") //-- 간호사, 의사
	@ResponseBody
	public ResponseEntity<List<PatientSummaryDTO>> getPatients(@RequestParam int offset, @RequestParam int limit) {
		List<PatientSummaryDTO> patients = patientService.getPatients(offset, limit);
		if (patients.isEmpty()) {
			return ResponseEntity.noContent().build(); // 빈 응답
		}
		return ResponseEntity.ok(patients);
	}

	// 특정 환자의 기본 정보 조회 (PatientDetailsDTO 사용) -- 간호사, 의사
	@GetMapping("/info/{patientNo}")
	public ResponseEntity<PatientRegistrationsDTO> getPatientBasicInfo(@PathVariable int patientNo) {
		PatientRegistrationsDTO patientDetails = patientService.getPatientDetails(patientNo);
		if (patientDetails == null) {
			return ResponseEntity.noContent().build(); // 빈 응답
		}
		return ResponseEntity.ok(patientDetails);
	}

	// 특정 환자의 진료 기록 및 관련 데이터 가져오기 -- 간호사 , 의사
	@GetMapping("/recordsPatientNo/{patientNo}")
	public ResponseEntity<List<MedicalRecordDTO>> getPatientMedicalRecords(@PathVariable int patientNo) {
		List<MedicalRecordDTO> medicalRecords = patientService.getPatientMedicalRecords(patientNo);
		return ResponseEntity.ok(medicalRecords);
	}
}