package com.emr.www.entity.doctor;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "Doctor")
public class DoctorEntity {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int no;

    private String name;

    @Column(unique = true, nullable = false,  columnDefinition = "CHAR(14)")
    private String securityNum;

    @Column(unique = true, nullable = false)
    private String email;

    private String phone;

    @Column(unique = true, nullable = false, columnDefinition = "CHAR(8)")
    private String licenseId;

    private String password;
    
    private String position;
    
    private String departmentId;
    
    private String profileImage;

    @Column(nullable = false)
    private String activeStatus;

}