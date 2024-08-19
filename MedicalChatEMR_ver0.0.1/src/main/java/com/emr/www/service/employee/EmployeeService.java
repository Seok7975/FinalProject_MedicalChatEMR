package com.emr.www.service.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.nurse.NurseRepository;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.nurse.NurseService;

import java.util.ArrayList;
import java.util.List;

@Service
public class EmployeeService {

	private final DoctorRepository doctorRepository;
    private final NurseRepository nurseRepository;

    @Autowired
    public EmployeeService(DoctorRepository doctorRepository, NurseRepository nurseRepository) {
        this.doctorRepository = doctorRepository;
        this.nurseRepository = nurseRepository;
    }
    public List<Object> searchEmployees(String name, String job, String position) {
        List<Object> employees = new ArrayList<>();

        if ("doctor".equals(job)) {
            employees.addAll(findDoctorsByNameAndPosition(name, position));
        } else if ("nurse".equals(job)) {
            employees.addAll(findNursesByNameAndPosition(name, position));
        } else {
            employees.addAll(findDoctorsByNameAndPosition(name, position));
            employees.addAll(findNursesByNameAndPosition(name, position));
        }

        return employees;
    }

    private List<DoctorEntity> findDoctorsByNameAndPosition(String name, String position) {
        if (position == null || position.isEmpty()) {
            return doctorRepository.findByPositionIsNull(); // 포지션이 null인 경우
        } else if ("ALL".equalsIgnoreCase(position)) {
            return doctorRepository.findAll(); // 모든 데이터를 출력하는 경우
        } else {
            return doctorRepository.findByNameContainingAndPosition(name, position); // 이름과 직급으로 검색
        }
    }

    private List<NurseEntity> findNursesByNameAndPosition(String name, String position) {
        if (position == null || position.isEmpty()) {
            return nurseRepository.findByPositionIsNull(); // 포지션이 null인 경우
        } else if ("ALL".equalsIgnoreCase(position)) {
            return nurseRepository.findAll(); // 모든 데이터를 출력하는 경우
        } else {
            return nurseRepository.findByNameContainingAndPosition(name, position); // 이름과 직급으로 검색
        }
    }


    public void updateEmployee(Long employeeNo, String name, String position, String phone, String email, String department, String password) {
        if ("doctor".equals(position)) {
            DoctorEntity doctor = doctorRepository.findById(employeeNo).orElseThrow(() -> new IllegalArgumentException("해당 의사가 없습니다."));
            doctor.setName(name);
            doctor.setPosition(position);
            doctor.setPhone(phone);
            doctor.setEmail(email);
            doctor.setDepartmentId(department);
            doctor.setPassword(password);
            doctorRepository.save(doctor);
        } else if ("nurse".equals(position)) {
            NurseEntity nurse = nurseRepository.findById(employeeNo).orElseThrow(() -> new IllegalArgumentException("해당 간호사가 없습니다."));
            nurse.setName(name);
            nurse.setPosition(position);
            nurse.setPhone(phone);
            nurse.setEmail(email);
            nurse.setPassword(password);
            nurseRepository.save(nurse);
        }
    }

    public void checkSecurityNumDuplicate(String securityNum) {
        boolean doctorExists = doctorRepository.existsBySecurityNum(securityNum);
        boolean nurseExists = nurseRepository.existsBySecurityNum(securityNum);

        if (doctorExists || nurseExists) {
            throw new IllegalArgumentException("이미 사용 중인 주민등록번호입니다.");
        }
    }
}
