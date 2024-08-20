package com.emr.www.repository.doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.doctor.PrescriptionEntity;

@Repository
public interface PrescriptionRepository extends JpaRepository<PrescriptionEntity, Integer> {
//dao 역할
}
