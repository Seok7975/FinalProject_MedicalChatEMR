package com.emr.www.repository.doctor;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.DiagnosisEntity;

@Repository
public interface DiagnosisRepository extends  JpaRepository<DiagnosisEntity, Integer> {

}
