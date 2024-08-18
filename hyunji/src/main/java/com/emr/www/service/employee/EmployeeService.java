package com.emr.www.service.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.emr.www.controller.employee.exception.LicenseKeyNotFoundException;
import com.emr.www.repository.dao.EmployeeDAO;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeDAO employeeDAO;

    // 회원가입에서 라이센스 키 확인 및 비밀번호 업데이트
    public void registerUser(String licenseId, String password) throws IllegalStateException, LicenseKeyNotFoundException {
        String doctorTable = "Doctor";
        String nurseTable = "Nurse";

        // 의사 테이블에서 라이센스 키 확인
        var doctorResult = employeeDAO.findUserByLicenseKey(doctorTable, licenseId);

        if (doctorResult.isPresent()) {
            // 의사 테이블에서 비밀번호가 설정되었는지 확인
            if (employeeDAO.isPasswordSet(doctorTable, licenseId)) {
                throw new IllegalStateException("이미 초기 비밀번호 설정이 완료되었습니다. 비밀번호 찾기를 이용하세요.");
            } else {
                // 비밀번호 업데이트
                employeeDAO.updatePassword(doctorTable, licenseId, password);
                return;
            }
        }

        // 간호사 테이블에서 라이센스 키 확인
        var nurseResult = employeeDAO.findUserByLicenseKey(nurseTable, licenseId);
        if (nurseResult.isPresent()) {
            // 간호사 테이블에서 비밀번호가 설정되었는지 확인
            if (employeeDAO.isPasswordSet(nurseTable, licenseId)) {
                throw new IllegalStateException("이미 초기 비밀번호 설정이 완료되었습니다. \n필요하시면 비밀번호 찾기를 이용하세요.");
            } else {
                // 비밀번호 업데이트
                employeeDAO.updatePassword(nurseTable, licenseId, password);
                return;
            }
        }

        // 의사와 간호사 테이블에 모두 라이센스 키가 없을 경우 예외 처리
        throw new LicenseKeyNotFoundException("승인되지 않은 ID입니다.");
    }

    // 로그인에서 라이센스 및 비밀번호 확인
    public String validateUser(String licenseId, String password) {
        
    	 // 의사 테이블에서 라이센스 키 확인
        var doctor = employeeDAO.findDoctorByLicenseIdAndPassword(licenseId, password);
        if (doctor.isPresent()) {
            return "doctor";  // 의사 계정인 경우
        }

     // 간호사 테이블에서 라이센스 키 확인
        var nurse = employeeDAO.findNurseByLicenseIdAndPassword(licenseId, password);
        if (nurse.isPresent()) {
            String role = (String) nurse.get().get("role");  // 역할을 가져옴
            if ("N".equals(role)) {
                return "nurse";  // 일반 간호사
            } else if ("S".equals(role)) {
                return "head_nurse";  // 수간호사
            }
        }
        
        // 일치하는 계정이 없을 경우 null 반환
        return null;
    }
    
    //관리자 로그인
    public String validateAdmin(String email, String password) {
        var admin = employeeDAO.findAdminByLicenseIdAndPassword(email, password);
        if (admin.isPresent()) {
            return "admin";
        }
        return null;
    }

}
