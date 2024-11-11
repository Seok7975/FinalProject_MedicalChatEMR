package com.emr.www.service.doctor;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emr.www.dto.doctor.DiagnosisDTO;
import com.emr.www.dto.doctor.DoctorDTO;
import com.emr.www.dto.doctor.DrugDTO;
import com.emr.www.dto.doctor.PrescriptionDTO;
import com.emr.www.dto.patient.MedicalRecordDTO;
import com.emr.www.entity.doctor.DiagnosisEntity;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.doctor.DrugEntity;
import com.emr.www.entity.doctor.PrescriptionEntity;
import com.emr.www.entity.patient.MedicalRecordEntity;
import com.emr.www.entity.patient.PatientRegistrationEntity;
import com.emr.www.repository.doctor.DiagnosisRepository;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.doctor.DrugRepository;
import com.emr.www.repository.doctor.PrescriptionRepository;
import com.emr.www.repository.patient.MedicalRecordRepository;
import com.emr.www.repository.patient.PatientRegistrationRepository;

@Service
public class DoctorService {
    
    @Autowired
    private DoctorRepository doctorRepository;
    
    @Autowired
    private MedicalRecordRepository medicalRecordRepository;

    @Autowired
    private DiagnosisRepository diagnosisRepository;

    @Autowired
    private PrescriptionRepository prescriptionRepository;

    @Autowired
    private DrugRepository drugRepository;
    @Autowired
    private PatientRegistrationRepository patientRegistrationRepository; 
    //관리자
    @PreAuthorize("hasRole('ADMIN')")
    public void createDoctor(DoctorDTO doctorDto) {
        // DTO를 엔티티로 변환
        DoctorEntity doctor = new DoctorEntity();
        doctor.setName(doctorDto.getName()); //의사 이름 입니다.
        doctor.setPhone(doctorDto.getPhone()); // 의사 전화번호 입니다.
        doctor.setSecurityNum(doctorDto.getSecurityNum()); //의사 주민등록번호입니다.
        doctor.setEmail(doctorDto.getEmail()); // 의사 이메일 입니다. 
        doctor.setPosition(doctorDto.getPosition()); //의사 직급입니다.
        doctor.setLicenseId(doctorDto.getLicenseId());   // 의사 면허번 입니다.
        doctor.setPassword(doctorDto.getPassword());  // 의사 비밀번호 입니다.  
        doctor.setDepartmentId(doctorDto.getDepartmentId());  //의사 진료과 입니다.
        doctor.setProfileImage(doctorDto.getProfileImage());  // 이미지 경로 저장
        doctor.setActiveStatus("자리 비움"); //기본설
        

        doctorRepository.save(doctor);  
    }

    
 // 의사 데이터를 이름과 직급에 따라 검색하는 메서드
    public List<DoctorEntity> searchDoctors(String name, String position) {
        return doctorRepository.searchDoctors(name, position);

    }
    
    //수간호사
    public List<DoctorEntity> getAllDoctors() {
        return doctorRepository.findAll();
    }
    
    // 엔티티를 DTO로 변환하는 메소드
    public DoctorDTO convertEntityToDto(DoctorEntity doctorEntity) {
        DoctorDTO doctorDto = new DoctorDTO();
        doctorDto.setName(doctorEntity.getName());
        doctorDto.setPhone(doctorEntity.getPhone());
        doctorDto.setSecurityNum(doctorEntity.getSecurityNum());
        doctorDto.setEmail(doctorEntity.getEmail());
        doctorDto.setPosition(doctorEntity.getPosition());
        doctorDto.setLicenseId(doctorEntity.getLicenseId());
        doctorDto.setPassword(doctorEntity.getPassword());
        doctorDto.setDepartmentId(doctorEntity.getDepartmentId());
        doctorDto.setProfileImage(doctorEntity.getProfileImage());
        doctorDto.setActiveStatus(doctorEntity.getActiveStatus());

        return doctorDto;
    }
    
    // 의사 ID로 조회
    public DoctorEntity getDoctorByNo(int doctorNo) {
        return doctorRepository.findByNo(doctorNo)
                .orElseThrow(() -> new IllegalArgumentException("해당 No로 의사를 찾을 수 없습니다: " + doctorNo));
    }
    
    
    //환자 진료 작성 데이터 저장 - 의사
    @Transactional //트랜잭션 적용
    public void saveMedicalRecord(MedicalRecordDTO recordDTO, int doctorNo) {
    	
    	// `doctorNo`와 `patientNo`로 `DoctorEntity`와 `PatientRegistrationEntity` 조회
        DoctorEntity doctor = doctorRepository.findByNo(doctorNo)
                .orElseThrow(() -> new RuntimeException("의사를 찾을 수 없습니다."));
        PatientRegistrationEntity patient = patientRegistrationRepository.findByNo(recordDTO.getPatientNo())
                .orElseThrow(() -> new RuntimeException("환자를 찾을 수 없습니다."));
        
        // 진료 기록 저장
        MedicalRecordEntity medicalRecord = MedicalRecordEntity.builder()
                .patient(patient)   // `PatientRegistrationEntity` 설정
                .doctor(doctor)  // `DoctorEntity` 설정
                .symptoms(recordDTO.getSymptoms())
                .surgeryStatus(recordDTO.getSurgeryStatus())
                .progress(recordDTO.getProgress())
                .visitDate(LocalDateTime.now())
                .build();
        
        medicalRecordRepository.save(medicalRecord);

        
        // 진단 저장
        if (recordDTO.getDiagnoses() != null) {
            for (DiagnosisDTO diagnosisDTO : recordDTO.getDiagnoses()) {
                DiagnosisEntity diagnosisEntity = DiagnosisEntity.builder()
                        .diseaseCode(diagnosisDTO.getDiseaseCode())
                        .diseaseName(diagnosisDTO.getDiseaseName())
                        .medicalRecord(medicalRecord)
                        .build();
                diagnosisRepository.save(diagnosisEntity);
            }
        }
        
        // 처방 저장
        if (recordDTO.getPrescriptions() != null) {
            for (PrescriptionDTO prescriptionDTO : recordDTO.getPrescriptions()) {
                PrescriptionEntity prescriptionEntity = PrescriptionEntity.builder()
                        .itemSeq(prescriptionDTO.getItemSeq())
                        .entpName(prescriptionDTO.getEntpName())
                        .itemName(prescriptionDTO.getItemName())
                        .useMethodQesitm(prescriptionDTO.getUseMethodQesitm())
                        .medicalRecord(medicalRecord)
                        .build();
                prescriptionRepository.save(prescriptionEntity);
            }
        }
        // 약물 저장
        if (recordDTO.getDrugs() != null) {
            for (DrugDTO drugDTO : recordDTO.getDrugs()) {
                DrugEntity drugEntity = DrugEntity.builder()
                        .cpntCd(drugDTO.getCpntCd())
                        .ingdNameKor(drugDTO.getIngdNameKor())
                        .fomlNm(drugDTO.getFomlNm())
                        .dosageRouteCode(drugDTO.getDosageRouteCode())
                        .dayMaxDosgQyUnit(drugDTO.getDayMaxDosgQyUnit())
                        .dayMaxDosgQy(drugDTO.getDayMaxDosgQy())
                        .medicalRecord(medicalRecord)
                        .build();
                drugRepository.save(drugEntity);
            }
        }
    }
}