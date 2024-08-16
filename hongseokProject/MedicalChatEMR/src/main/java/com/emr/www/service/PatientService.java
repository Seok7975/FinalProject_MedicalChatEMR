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

    
//    public PatientDTO registerPatient(PatientDTO patientDTO) {
//        log.info("Registering new patient: {}", patientDTO);
//        
//        Patient patient = new Patient();
//        BeanUtils.copyProperties(patientDTO, patient);
//        
//        log.info("Converted to Patient entity: {}", patient);
//        
//        Patient savedPatient = patientRepository.save(patient);
//        
//        log.info("Saved Patient: {}", savedPatient);
//        
//        PatientDTO savedDTO = new PatientDTO();
//        BeanUtils.copyProperties(savedPatient, savedDTO);
//        
//        return savedDTO;
//    }
    @Transactional
    public Patient registerPatient(PatientDTO patientDTO) {
        log.info("Registering new patient: {}", patientDTO);
        Patient patient = new Patient();
        BeanUtils.copyProperties(patientDTO, patient);
        log.info("Converted to Patient entity: {}", patient);
        Patient savedPatient = patientRepository.save(patient);
        log.info("Saved Patient: {}", savedPatient);
        return savedPatient;
    }

//    public PatientDTO registerPatient(PatientDTO patientDTO) {
//        Patient patient = new Patient();
//        BeanUtils.copyProperties(patientDTO, patient);
//        Patient savedPatient = patientRepository.save(patient);
//        PatientDTO savedPatientDTO = new PatientDTO();
//        BeanUtils.copyProperties(savedPatient, savedPatientDTO);
//        return savedPatientDTO;
//    }

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