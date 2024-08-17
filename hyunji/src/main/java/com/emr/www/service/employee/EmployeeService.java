package com.emr.www.service.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.emr.www.controller.employee.exception.LicenseKeyNotFoundException;
import com.emr.www.repository.dao.EmployeeDAO;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeDAO employeeDAO;

    //회원가입에서 라이센스 키 확인 및 비밀번호 업데이트
    public void registerUser(String licenseId, String password) {
        // 의사 테이블에서 먼저 라이센스 키 확인
        var doctorResult = employeeDAO.findDoctorByLicenseKey(licenseId);
        
        if (doctorResult.isPresent()) {
            // 의사 비밀번호 업데이트
            employeeDAO.updateDoctorPassword(licenseId, password);
        } else {
            // 간호사 테이블에서 라이센스 키 확인
            var nurseResult = employeeDAO.findNurseByLicenseKey(licenseId);
            if (nurseResult.isPresent()) {
                // 간호사 비밀번호 업데이트
                employeeDAO.updateNursePassword(licenseId, password);
            } else {
                throw new LicenseKeyNotFoundException("License Key doesn't exist: " + licenseId);
            }
        }
    }
    
    //로그인에서 라이센스 및 비밀번호 확인
    public String validateUser(String licenseId, String password) {
    	
    	System.out.println("로그인 서비스 도착");
    	
    	//의사 테이블에서 일치하는 계정 확인
    	var doctor = employeeDAO.findDoctorByLicenseIdAndPassword(licenseId, password);
    	if(doctor.isPresent()) {
    		System.out.println("의사");
    		return "doctor";
    	}
    	
    	//간호사 테이블에서 일치하는 계정 확인
    	var nurse = employeeDAO.findNurseByLicenseIdAndPassword(licenseId, password);
    	if(nurse.isPresent()) {
    		System.out.println("간호사");
    		return "nurse";
    	}
    	
    	//관리자 테이블에서 일치하는 계정 확인
    	var admin = employeeDAO.findAdminByLicenseIdAndPassword(licenseId, password);
    	System.out.println("관리자 확인 : " + admin.isPresent());
    	if(admin.isPresent()) {
    		return "admin";
    	}
    	
    	//일치하는 계정이 없을 경우 null 반환
    	return null;
    }
}
