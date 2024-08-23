package com.emr.www.service.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.nurse.NurseRepository;
import java.util.ArrayList;
import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private NurseRepository nurseRepository;

    public List<Object> searchEmployees(String name, String job, String position) {
        List<Object> employees = new ArrayList<>();

        if ("doctor".equals(job)) {
            employees.addAll(doctorRepository.findByNameContainingAndPosition(name, position));
        } else if ("nurse".equals(job)) {
            employees.addAll(nurseRepository.findByNameContainingAndPosition(name, position));
        } else {
            employees.addAll(doctorRepository.findByNameContainingAndPosition(name, position));
            employees.addAll(nurseRepository.findByNameContainingAndPosition(name, position));
        }

        return employees;
    }
}
