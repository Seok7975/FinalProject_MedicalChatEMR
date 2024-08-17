package com.emr.www.entity;

import java.math.BigDecimal;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "Patient")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_no")
    private Long id_no;

    @Column(length = 50)
    private String name;

    @Column(name = "securityNum", length = 14, unique = true)
    private String securityNum;  
    @Column(length = 1)
    private Character gender;

    @Column(length = 255)
    private String address;

    @Column(length = 20)
    private String phone;

    @Column(length = 50)
    private String email;

    @Column(name = "blood_type", length = 6)
    private String blood_type;

    private Integer height;

    private Integer weight;

    @Column(columnDefinition = "TEXT")
    private String allergies;

    @Column(name = "blood_pressure", length = 10)
    private String blood_pressure;

    @Column(precision = 4, scale = 1)
    private BigDecimal temperature;

    @Column(name = "smoking_status", length = 1)
    private Character smoking_status;
}