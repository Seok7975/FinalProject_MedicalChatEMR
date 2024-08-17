package com.emr.www.service;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emr.www.dto.PatientDTO;
import com.emr.www.entity.Patient;
import com.emr.www.repository.PatientRepository;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    private static final Logger log = LoggerFactory.getLogger(PatientService.class);

    
    // 주민등록번호 중복 여부 확인 메서드
    public boolean isSecurityNumExists(String securityNum) {
        return patientRepository.findBySecurityNum(securityNum) != null;
    }
    
    @Transactional
    public Patient registerPatient(PatientDTO patientDTO) {
        log.info("Starting patient registration process with DTO: {}", patientDTO);

        // DTO를 엔티티로 변환
        Patient patient = new Patient();
        BeanUtils.copyProperties(patientDTO, patient);
        
        // ID를 null로 설정하여 자동 생성되도록 함
//        patient.setId(null);

        log.info("Converted PatientDTO to Patient entity: {}", patient);

        // 환자 정보 저장
        Patient savedPatient = patientRepository.save(patient);
        log.info("Patient saved successfully. Generated ID: {}", savedPatient.getId_no());
        return savedPatient;
    }


    public PatientDTO getPatientBySecurityNum(String securityNum) {
        Patient patient = patientRepository.findBySecurityNum(securityNum);
        if (patient != null) {
            PatientDTO patientDTO = new PatientDTO();
            BeanUtils.copyProperties(patient, patientDTO);
            return patientDTO;
        }
        return null;
    }
    

}