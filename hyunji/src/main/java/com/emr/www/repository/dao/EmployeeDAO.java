package com.emr.www.repository.dao;

import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class EmployeeDAO {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// 의사 테이블에서 라이센스 키로 사용자 검색 - 회원가입 > 의사
	public Optional<Map<String, Object>> findDoctorByLicenseKey(String licenseKey) {
		String sql = "SELECT * FROM Doctor WHERE license_id = ?";
		try {
			Optional<Map<String, Object>> doctor = Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseKey));
			return doctor;
		} catch (EmptyResultDataAccessException ex) {
			System.out.println("의사 테이블에서 결과를 찾지 못함");
			return Optional.empty();
		}
	}

	// 간호사 테이블에서 라이센스 키로 사용자 검색 - 회원가입 > 간호사
	public Optional<Map<String, Object>> findNurseByLicenseKey(String licenseKey) {
		System.out.println("간호사 테이블 dao 도착");
		String sql = "SELECT * FROM Nurse WHERE license_id = ?";
		try {
			Optional<Map<String, Object>> nurse = Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseKey));
			return nurse;
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}

	// 의사 비밀번호 설정 - 회원가입
	public void updateDoctorPassword(String licenseKey, String password) {
		String sql = "UPDATE Doctor SET password = ? WHERE license_id = ?";
		jdbcTemplate.update(sql, password, licenseKey);
	}

	// 간호사 비밀번호 설정 - 회원가입
	public void updateNursePassword(String licenseKey, String password) {
		String sql = "UPDATE Nurse SET password = ? WHERE license_id = ?";
		jdbcTemplate.update(sql, password, licenseKey);
	}

	//의사 테이블에서 id와 비밀번호 검색 - 로그인
	public Optional<Map<String, Object>> findDoctorByLicenseIdAndPassword(String licenseId, String password) {
		String sql = "SELECT * FROM Doctor WHERE license_id = ? AND password = ?";

		try {
			return Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseId, password));
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}

	//간호사 테이블에서 id와 비밀번호 검색 - 로그인
	public Optional<Map<String, Object>> findNurseByLicenseIdAndPassword(String licenseId, String password) {
		String sql = "SELECT * FROM Nurse where license_id = ? AND password = ?";

		try {
			return Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseId, password));
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}

	//관리자 테이블에서 id와 비밀번호 검색 - 로그인
	public Optional<Map<String, Object>> findAdminByLicenseIdAndPassword(String licenseId, String password) {
		String sql = "SELECT * FROM Admin where admin_email = ? and password = ?";

		try {
			return Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseId, password));
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}
}
