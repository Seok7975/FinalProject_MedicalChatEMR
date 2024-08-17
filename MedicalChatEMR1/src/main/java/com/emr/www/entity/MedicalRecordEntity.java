package com.emr.www.entity;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "MedicalRecord")
public class MedicalRecordEntity {
    
    @Id
    private Long chart_num;
    
    // other fields and mappings
}

