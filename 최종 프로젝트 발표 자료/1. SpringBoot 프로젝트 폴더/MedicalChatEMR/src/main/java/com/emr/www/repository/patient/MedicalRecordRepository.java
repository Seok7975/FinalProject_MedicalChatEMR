package com.emr.www.repository.patient;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.patient.MedicalRecordEntity;


public interface MedicalRecordRepository extends JpaRepository<MedicalRecordEntity, Integer> {
    //공통 로직 - 환자 차트 불러오기
	List<MedicalRecordEntity> findByPatientNo(int patientId);
}

