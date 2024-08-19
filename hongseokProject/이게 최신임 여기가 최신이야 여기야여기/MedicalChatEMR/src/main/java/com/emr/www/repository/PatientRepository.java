package com.emr.www.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.Patient;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    Patient findBySecurityNum(String securityNum);
    List<Patient> findByNameStartingWith(String name); // 환자등록시 이름이 000으로 시작하는 모든 레코드 검색 인터페이스
    List<Patient> findByNameContaining(String name); // 환자내원시 이름으로 검색하는 인터페이스
}