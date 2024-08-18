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

	// 테이블과 license_key로 사용자를 검색
	public Optional<Map<String, Object>> findUserByLicenseKey(String tableName, String licenseKey) {
		String sql = String.format("SELECT * FROM %s WHERE license_id = ?", tableName);
		try {
			Optional<Map<String, Object>> user = Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseKey));
			return user;
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}

	// 비밀번호 설정 여부 확인 
	public boolean isPasswordSet(String tableName, String licenseKey) {
		String sql = String.format("SELECT password FROM %s WHERE license_id = ?", tableName);

		try {
			Map<String, Object> user = jdbcTemplate.queryForMap(sql, licenseKey);
			String password = (String) user.get("password");
			return password != null && !password.isEmpty();
		} catch (EmptyResultDataAccessException ex) {
			return false;
		}
	}

	// 비밀번호 설정 (의사와 간호사 공통 처리) - 회원가입 
	public void updatePassword(String tableName, String licenseKey, String password) {
		String sql = String.format("UPDATE %s SET password = ? WHERE license_id = ?", tableName);
		int rowsUpdated = jdbcTemplate.update(sql, password, licenseKey);
		if (rowsUpdated == 0) {
			throw new IllegalStateException("비밀번호 업데이트가 실패했습니다.");
		}
	}

	// 간호사의 경우 role 필드를 포함해 검색 (license_id와 password가 일치하는지 확인) - 로그인 
	public Optional<Map<String, Object>> findNurseByLicenseIdAndPassword(String licenseId, String password) {
		String sql = "SELECT * FROM Nurse WHERE license_id = ? AND password = ?";
		try {
			return Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseId, password));
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}

	// 의사 테이블에서 license_id와 비밀번호가 일치하는지 확인 (role 필드 없음) - 로그인 
	public Optional<Map<String, Object>> findDoctorByLicenseIdAndPassword(String licenseId, String password) {
		String sql = "SELECT * FROM Doctor WHERE license_id = ? AND password = ?";
		try {
			return Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseId, password));
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}

	// 관리자 테이블에서 email과 비밀번호로 사용자 검색
	public Optional<Map<String, Object>> findAdminByLicenseIdAndPassword(String licenseId, String password) {
		String sql = "SELECT * FROM Admin where admin_email = ? and password = ?";
		try {
			return Optional.ofNullable(jdbcTemplate.queryForMap(sql, licenseId, password));
		} catch (EmptyResultDataAccessException ex) {
			return Optional.empty();
		}
	}
}
