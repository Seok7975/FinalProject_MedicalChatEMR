package com.emr.www.entity.employeestatus;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "EmployeeStatus") // 테이블명 수정
public class EmployeeStatusEntity {
    
    @Id
    private Long chart_num;
    
    // other fields and mappings
}

