package com.emr.www.service.admin;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.nurse.NurseRepository;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.nurse.NurseService;

@Service
public class AdminService {
	
    @Autowired
    private DoctorService doctorService;

    @Autowired
    private NurseService nurseService;
    
	@Autowired
	private DoctorRepository doctorRepository;

	@Autowired
	private NurseRepository nurseRepository;

	 @PreAuthorize("hasRole('ADMIN')")
	public List<Object> searchEmployees(String name, String job, String position) {
		List<Object> employees = new ArrayList<>();

		if ("doctor".equalsIgnoreCase(job)) {
			employees.addAll(doctorService.searchDoctors(name, position));
		} else if ("nurse".equalsIgnoreCase(job)) {
			employees.addAll(nurseService.searchNurses(name, position));
		} else {
			// 직업군이 지정되지 않은 경우, 모든 직업군 검색
			employees.addAll(doctorService.searchDoctors(name, position));
			employees.addAll(nurseService.searchNurses(name, position));
		}

		return employees;
	}

	// 직원 정보 수정 메서드, 직원 번호를 기준으로 해당 의사 또는 간호사 정보를 업데이트
	 @PreAuthorize("hasRole('ADMIN')")
	public void updateEmployee(int no, String name, String position, String phone, String email, String department,
			String password, String job) {
		try {
			if ("doctor".equalsIgnoreCase(job)) {
				Optional<DoctorEntity> doctorOpt = doctorRepository.findById(no);
				if (doctorOpt.isPresent()) {
					DoctorEntity doctor = doctorOpt.get();
					doctor.setName(name);
					doctor.setPosition(position);
					doctor.setPhone(phone);
					doctor.setEmail(email);
					doctor.setPassword(password);
					doctor.setDepartmentId(department);
					doctorRepository.save(doctor);
				} else {
					throw new RuntimeException("해당 의사가 존재하지 않습니다. (ID: " + no + ")");
				}
			} else if ("nurse".equalsIgnoreCase(job)) {
				Optional<NurseEntity> nurseOpt = nurseRepository.findById(no);
				if (nurseOpt.isPresent()) {
					NurseEntity nurse = nurseOpt.get();
					nurse.setName(name);
					nurse.setPosition(position);
					nurse.setPhone(phone);
					nurse.setEmail(email);
					nurse.setPassword(password);
					nurse.setDepartmentId(department);
					nurseRepository.save(nurse);
				} else {
					throw new RuntimeException("해당 간호사가 존재하지 않습니다. (ID: " + no + ")");
				}
			} else {
				throw new RuntimeException("올바르지 않은 직업군입니다: " + job);
			}
		} catch (Exception e) {
			throw new RuntimeException("직원 정보 수정 중 오류 발생: " + e.getMessage(), e);
		}
	}

	// 주민등록번호 중복 체크 메서드, 의사와 간호사 모두의 중복 여부를 확인
	 @PreAuthorize("hasRole('ADMIN')")
	public void checkSecurityNumDuplicate(String securityNum) {
		boolean doctorExists = doctorRepository.existsBySecurityNum(securityNum);
		boolean nurseExists = nurseRepository.existsBySecurityNum(securityNum);

		if (doctorExists || nurseExists) {
			throw new IllegalArgumentException("이미 사용 중인 주민등록번호입니다.");
		}
	}
	 
}