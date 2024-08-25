package com.emr.www.repository.patient;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.patient.PatientRegistrationEntity;

public interface PatientRegistrationRepository extends JpaRepository<PatientRegistrationEntity, Integer> {
	
	
	/* 공통 - 환자 데이터 목록으로 보이게 하기 */
	// No 필드로 환자 조회
    Optional<PatientRegistrationEntity> findByNo(int patientNo);
    
    
	/* 수간호사 */
	 PatientRegistrationEntity findBySecurityNum(String securityNum);
    List<PatientRegistrationEntity> findByNameStartingWith(String name); // 환자등록시 이름이 000으로 시작하는 모든 레코드 검색 인터페이스
    List<PatientRegistrationEntity> findByNameContaining(String name); // 환자내원시 이름으로 검색(이름에 해당 문자열이 포함된 모든 레코드를 검색)하는 인터페이스
    PatientRegistrationEntity findByNameAndSecurityNum(String name, String securityNum); // 이름과 주민등록번호로 환자 검색
}