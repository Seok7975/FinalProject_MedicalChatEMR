package com.emr.www.repository.doctor;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.doctor.DrugEntity;

@Repository
public interface DrugRepository extends JpaRepository<DrugEntity, Integer> {
 //dao역할 
}
