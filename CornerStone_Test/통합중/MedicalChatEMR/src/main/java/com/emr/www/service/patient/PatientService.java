package com.emr.www.service.patient;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emr.www.dto.doctor.DiagnosisDTO;
import com.emr.www.dto.doctor.DrugDTO;
import com.emr.www.dto.doctor.PrescriptionDTO;
import com.emr.www.dto.patient.MedicalRecordDTO;
import com.emr.www.dto.patient.PatientDTO;
import com.emr.www.dto.patient.PatientRegistrationsDTO;
import com.emr.www.dto.patient.PatientSummaryDTO;
import com.emr.www.dto.patient.PatientVisitDTO;
import com.emr.www.entity.doctor.DiagnosisEntity;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.doctor.DrugEntity;
import com.emr.www.entity.doctor.PrescriptionEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.entity.patient.MedicalRecordEntity;
import com.emr.www.entity.patient.PatientRegistrationEntity;
import com.emr.www.entity.patient.PatientVisitEntity;
import com.emr.www.repository.doctor.DiagnosisRepository;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.doctor.PrescriptionRepository;
import com.emr.www.repository.nurse.NurseRepository;
import com.emr.www.repository.patient.MedicalRecordRepository;
import com.emr.www.repository.patient.PatientRegistrationRepository;
import com.emr.www.repository.patient.PatientVisitRepository;

import jakarta.persistence.EntityNotFoundException;

@Service
public class PatientService {

	@Autowired
	private PatientRegistrationRepository patientRepository;

	@Autowired
	private PatientVisitRepository patientVisitRepository;

	@Autowired
	private MedicalRecordRepository medicalRecordRepository;

	@Autowired
	private DiagnosisRepository diagnosisRepository;

	@Autowired
	private DoctorRepository doctorRepository;

	@Autowired
	private PrescriptionRepository prescriptionRepository;

	@Autowired
	private NurseRepository nurseRepository;

	private static final Logger log = LoggerFactory.getLogger(PatientService.class);

	// 주민등록번호 중복 여부 확인 메서드
	public boolean isSecurityNumExists(String securityNum) {
		return patientRepository.findBySecurityNum(securityNum) != null;
	}

	@Transactional
	public PatientRegistrationEntity registerPatient(PatientDTO patientDTO) {
		log.info("DTO로 환자 등록 프로세스 시작 : {}\n", patientDTO);

		// 이름 중복 체크 및 수정
		String originalName = patientDTO.getName();
		String uniqueName = getUniqueName(originalName);
		patientDTO.setName(uniqueName);

		// DTO를 엔티티로 변환
		PatientRegistrationEntity patient = new PatientRegistrationEntity();
		//			BeanUtils.copyProperties(patientDTO, patient);
		// 'no' 필드를 제외하고 복사
		BeanUtils.copyProperties(patientDTO, patient, "no"); // 'no' 필드를 제외한 나머지 필드 복사

		// no를 null로 설정하여 BeanUtils.copyProperties 호출 시 문제가 발생하지 않도록 함
		//	        patientDTO.setNo(null);

		log.info("PatientDTO를 Patient 엔티티로 변환 : {}\n", patient);

		// 환자 정보 저장
		PatientRegistrationEntity savedPatient = patientRepository.save(patient);
		log.info("환자가 성공적으로 저장되었습니다. 생성된 ID : {}\n", savedPatient.getNo());
		return savedPatient;
	}

	public PatientDTO getPatientBySecurityNum(String securityNum) {
		PatientRegistrationEntity patient = patientRepository.findBySecurityNum(securityNum);
		if (patient != null) {
			PatientDTO patientDTO = new PatientDTO();
			BeanUtils.copyProperties(patient, patientDTO);
			return patientDTO;
		}
		return null;
	}

	private String getUniqueName(String name) {
		// 원본 이름으로 시작하는 모든 환자 이름을 조회합니다.
		List<PatientRegistrationEntity> existingPatients = patientRepository.findByNameStartingWith(name);

		int maxSuffix = 0;

		// 동일한 이름을 가진 기존 환자들에 대해 (1), (2), (3) 등의 방법으로 이름 생성
		// 기존 환자들의 이름을 순회하며 사용된 최대 접미사를 계산합니다.
		for (PatientRegistrationEntity existingPatient : existingPatients) {
			String existingName = existingPatient.getName();

			// 이름이 정확히 일치하는 경우, "(1)"로 처리합니다.
			if (existingName.equals(name)) {
				maxSuffix = 1; // 기존 이름이 동일한 경우 접미사 1로 설정
				break; // 더 이상 검사를 진행할 필요 없으므로 루프를 종료합니다.
			} else {
				// 숫자 접미사를 추출하여 최대 접미사를 계산합니다.
				if (existingName.startsWith(name + "(") && existingName.endsWith(")")) {
					try {
						int suffix = Integer.parseInt(existingName.substring(name.length() + 1, existingName.length() - 1));
						maxSuffix = Math.max(maxSuffix, suffix);
					} catch (NumberFormatException e) {
						// 숫자 변환에 실패하면 패턴에 맞지 않는다고 간주하고 무시합니다.
					}
				}
			}
		}

		// 새로 등록할 환자의 이름은 최대 접미사에 1을 더하여 생성합니다.
		int newSuffix = maxSuffix + 1;
		return (newSuffix == 1) ? name : name + "(" + newSuffix + ")";
	}

	@Transactional
	public void registerPatientVisit(PatientVisitDTO patientVisitDTO) {
		PatientVisitEntity patientVisit = new PatientVisitEntity();

		// 환자 정보를 조회 및 설정
		PatientRegistrationEntity patient = patientRepository.findByNameAndSecurityNum(patientVisitDTO.getPatientName(),
				patientVisitDTO.getSecurityNum());
		patientVisit.setPatient(patient);

		// 의사 정보를 조회 및 설정
		DoctorEntity doctor = doctorRepository.findByNo(patientVisitDTO.getDoctorNo()).orElse(null);
		patientVisit.setDoctor(doctor);

		// 간호사 정보를 조회 및 설정
		NurseEntity nurse = nurseRepository.findByNo(patientVisitDTO.getNurseNo()).orElse(null);
		patientVisit.setNurse(nurse);

		patientVisit.setVisitReason(patientVisitDTO.getVisitReason());

		// 환자 방문 정보 저장
		patientVisitRepository.save(patientVisit);
	}
	
	//의사 로직
	
	//새로운 진료 기록 저장
	

	/*
	 * -------------------------------공통----------------------
	 */

	// 페이징된 환자 목록 가져오기 (이름과 생년월일만 표시) -  간호사, 수간호사
	// 환자 목록을 offset과 limit을 기준으로 페칭하는 메서드
	public List<PatientSummaryDTO> getPatients(int offset, int limit) {
		Pageable pageable = PageRequest.of(offset / limit, limit);
		List<PatientRegistrationEntity> patients = patientRepository.findAll(pageable).getContent();

		// 빈 데이터인지 확인
		if (patients.isEmpty()) {
			// 로깅 추가
			log.info("빈 환자 목록을 반환했습니다.");
			return Collections.emptyList(); // 빈 리스트 반환
		}

		return patients.stream().map(patient -> new PatientSummaryDTO(patient.getNo(), patient.getName(), patient.getSecurityNum().substring(0, 6)))
				.collect(Collectors.toList());
	}

	// 특정 환자의 기본 정보만 가져오는 메서드
	public PatientRegistrationsDTO getPatientDetails(int patientNo) {
		//환자의 기본 정보 조회
		PatientRegistrationEntity patient = patientRepository.findByNo(patientNo).orElseThrow(() -> new EntityNotFoundException("환자를 찾을 수 없습니다"));

		return convertToRegistrationDTO(patient);
	}

	private PatientRegistrationsDTO convertToRegistrationDTO(PatientRegistrationEntity patient) {
		return PatientRegistrationsDTO.builder().no(patient.getNo()).name(patient.getName()).securityNum(patient.getSecurityNum())
				.gender(patient.getGender()).address(patient.getAddress()).phone(patient.getPhone()).email(patient.getEmail())
				.bloodType(patient.getBloodType()).height(patient.getHeight()).weight(patient.getWeight()).allergies(patient.getAllergies())
				.bloodPressure(patient.getBloodPressure()).temperature(patient.getTemperature()).smokingStatus(patient.getSmokingStatus()).build();
	}

	//특정 환자의 진료 기록 및 관련 데이터를 가져오는 메서드 (환자 no로 모든 진료 기록 가져오기) - 의사, 간호사, 수간호사
	public List<MedicalRecordDTO> getPatientMedicalRecords(int patientNo) {
		// 환자의 진료 기록 리스트 가져오기
		List<MedicalRecordEntity> medicalRecords = medicalRecordRepository.findByPatientNo(patientNo);

		if (medicalRecords.isEmpty()) {
			return Collections.emptyList(); // 진료 기록이 없으면 빈 리스트 반환
		}

		return medicalRecords.stream().map(this::convertToMedicalRecordDTO).collect(Collectors.toList());
	}

	// MedicalRecordDTO 변환 메서드
	private MedicalRecordDTO convertToMedicalRecordDTO(MedicalRecordEntity record) {
		DoctorEntity doctor = doctorRepository.findByNo(record.getDoctor().getNo()).orElseThrow(() -> new EntityNotFoundException("의사를 찾을 수 없습니다"));

		// DiagnosisDTO 생성
		List<DiagnosisDTO> diagnoses = diagnosisRepository.findByMedicalRecord_ChartNum(record.getChartNum()).stream()
				.map(diagnosis -> new DiagnosisDTO(diagnosis.getDiseaseCode(), diagnosis.getDiseaseName())).collect(Collectors.toList());

		// PrescriptionDTO 생성
		List<PrescriptionDTO> prescriptions = record.getPrescriptions().stream().map(prescription -> new PrescriptionDTO(prescription.getEntpName(), // 약품 회사명
				prescription.getItemSeq(), // 약품 코드
				prescription.getItemName(), // 약품명
				prescription.getUseMethodQesitm())) // 사용법
				.collect(Collectors.toList());

		// DrugDTO 생성
		List<DrugDTO> drugs = record.getDrugs().stream().map(drug -> new DrugDTO(drug.getCpntCd(), // 성분 코드
				drug.getIngdNameKor(), // 성분명(한글)
				drug.getFomlNm(), // 제형명
				drug.getDosageRouteCode(), // 투여 경로
				drug.getDayMaxDosgQyUnit(), // 투여 단위
				drug.getDayMaxDosgQy())) // 1일 최대 투여량
				.collect(Collectors.toList());

		LocalDateTime visitDate = record.getVisitDate(); // 이미 LocalDateTime이므로 파싱할 필요가 없음

		return MedicalRecordDTO.builder().chartNum(record.getChartNum()).symptoms(record.getSymptoms()).surgeryStatus(record.getSurgeryStatus())
				.progress(record.getProgress()).visitDate(visitDate).doctorName(record.getDoctor().getName()).diagnoses(diagnoses).prescriptions(prescriptions)
				.drugs(drugs).build();
	}
	
	// 새로운 진료 기록 저장
	/*
	 * @Transactional public MedicalRecordDTO saveMedicalRecord(MedicalRecordDTO
	 * recordDTO) { MedicalRecordEntity recordEntity = new
	 * MedicalRecordEntity();
	 * 
	 * // 진료 기록 정보 저장 DoctorEntity doctor = doctorRepository.findByNo(recordDTO)
	 * .orElseThrow(() -> new EntityNotFoundException("의사를 찾을 수 없습니다."));
	 * 
	 * // 기록 저장 recordEntity.setPatientNo(recordDTO.getPatientNo());
	 * recordEntity.setDoctor(doctor);
	 * recordEntity.setSymptoms(recordDTO.getSymptoms());
	 * recordEntity.setSurgeryStatus(recordDTO.getSurgeryStatus());
	 * recordEntity.setProgress(recordDTO.getProgress());
	 * recordEntity.setVisitDate(LocalDateTime.now());
	 * 
	 * MedicalRecordEntity savedRecord =
	 * medicalRecordRepository.save(recordEntity);
	 * 
	 * // 진단 저장 if (recordDTO.getDiagnoses() != null) { for (DiagnosisDTO
	 * diagnosisDTO : recordDTO.getDiagnoses()) { DiagnosisEntity diagnosis =
	 * new DiagnosisEntity(); diagnosis.setMedicalRecord(savedRecord);
	 * diagnosis.setDiseaseCode(diagnosisDTO.getDiseaseCode());
	 * diagnosis.setDiseaseName(diagnosisDTO.getDiseaseName());
	 * diagnosisRepository.save(diagnosis); } }
	 * 
	 * // 처방 저장 if (recordDTO.getPrescriptions() != null) { for (PrescriptionDTO
	 * prescriptionDTO : recordDTO.getPrescriptions()) { PrescriptionEntity
	 * prescription = new PrescriptionEntity();
	 * prescription.setMedicalRecord(savedRecord);
	 * prescription.setEntpName(prescriptionDTO.getEntpName());
	 * prescription.setItemSeq(prescriptionDTO.getItemSeq());
	 * prescription.setItemName(prescriptionDTO.getItemName());
	 * prescription.setUseMethodQesitm(prescriptionDTO.getUseMethodQesitm());
	 * prescriptionRepository.save(prescription); } }
	 * 
	 * // 약물 저장 if (recordDTO.getDrugs() != null) { for (DrugDTO drugDTO :
	 * recordDTO.getDrugs()) { DrugEntity drug = new DrugEntity();
	 * drug.setMedicalRecord(savedRecord); drug.setCpntCd(drugDTO.getCpntCd());
	 * drug.setIngdNameKor(drugDTO.getIngdNameKor());
	 * drug.setFomlNm(drugDTO.getFomlNm());
	 * drug.setDosageRouteCode(drugDTO.getDosageRouteCode());
	 * drug.setDayMaxDosgQyUnit(drugDTO.getDayMaxDosgQyUnit());
	 * drug.setDayMaxDosgQy(drugDTO.getDayMaxDosgQy());
	 * drugRepository.save(drug); } }
	 * 
	 * return convertToMedicalRecordDTO(savedRecord); }
	 */

}