package com.emr.www.repository.employee;

import org.springframework.data.jpa.repository.JpaRepository;

import com.emr.www.entity.employee.EmployeeEntity;

public interface EmployeeRepository extends JpaRepository<EmployeeEntity,Long>{
    boolean existsByLicenseKey(String licenseKey);
}

