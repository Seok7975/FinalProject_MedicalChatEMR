package com.emr.www.repository.nurse;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.nurse.NurseEntity;

@Repository
public interface NurseRepository extends JpaRepository<NurseEntity, Integer>, JpaSpecificationExecutor<NurseEntity> {

	//관리자 - 주민번호 중복 확인
	boolean existsBySecurityNum(String securityNum);

	//로그인 및 회원가입
	Optional<NurseEntity> findByLicenseId(String licenseId);

	Optional<NurseEntity> findByLicenseIdAndPassword(String licenseId, String password);

	//수간호사
	@Query("SELECT n FROM NurseEntity n WHERE (:name IS NULL OR n.name LIKE %:name%) AND (:position IS NULL OR n.position = :position)")
	List<NurseEntity> searchNurses(@Param("name") String name, @Param("position") String position);

	@Query("SELECT n FROM NurseEntity n WHERE :name IS NULL OR n.name LIKE %:name%")
	List<NurseEntity> findByNameContaining(@Param("name") String name);

	@Query("SELECT n FROM NurseEntity n WHERE :position IS NULL OR n.position = :position")
	List<NurseEntity> findByPosition(@Param("position") String position);

	// no로 간호사 역할 찾기
	Optional<NurseEntity> findByNo(Integer no); // 주키를 기준으로 NurseEntity 찾기

	List<NurseEntity> findByName(String name);

	Optional<NurseEntity> findBySecurityNum(String securityNum);
}
