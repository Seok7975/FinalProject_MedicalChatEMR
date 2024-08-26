package com.emr.www.repository.patient;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.patient.MedicalRecordEntity;


public interface MedicalRecordRepository extends JpaRepository<MedicalRecordEntity, Integer> {
	// 환자 차트 불러오기 - visitDate를 내림차순으로 정렬
    List<MedicalRecordEntity> findByPatientNoOrderByVisitDateDesc(int patientId);
}

