package com.emr.www.repository.doctor.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.doctor.DiagnosisEntity;

@Repository
public interface DiagnosisRepository extends  JpaRepository<DiagnosisEntity, Integer> {

}
