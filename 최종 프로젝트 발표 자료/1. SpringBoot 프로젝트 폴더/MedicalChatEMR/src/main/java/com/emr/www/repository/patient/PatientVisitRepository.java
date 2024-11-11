package com.emr.www.repository.patient;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.patient.PatientVisitEntity;

@Repository
public interface PatientVisitRepository extends JpaRepository<PatientVisitEntity, Integer> {
    // 기본적인 CRUD 메서드 사용 가능
}