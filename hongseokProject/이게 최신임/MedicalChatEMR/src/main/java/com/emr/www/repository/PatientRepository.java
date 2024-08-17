package com.emr.www.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.Patient;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    Patient findBySecurityNum(String securityNum);  // 여기를 변경했습니다
}