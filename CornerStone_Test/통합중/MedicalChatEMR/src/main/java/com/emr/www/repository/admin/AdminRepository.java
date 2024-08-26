package com.emr.www.repository.admin;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.admin.AdminEntity;

public interface AdminRepository extends JpaRepository<AdminEntity, Integer> {

	//관리자 로그인
	 Optional<AdminEntity> findByAdminEmailAndPassword(String adminEmail, String password);
	 
	//jwt 관리자 주키 찾기
	 Optional<AdminEntity> findByNo(int no);
	 
}
