package com.emr.www.repository.doctor;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.doctor.DrugEntity;

@Repository
public interface DrugRepository extends JpaRepository<DrugEntity, Integer> {

	//환자 진료 데이터 가져오기
	List<DrugEntity> findByMedicalRecord_ChartNum(int chartNum);
}
