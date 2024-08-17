package com.emr.www.entity;

import java.math.BigDecimal;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "patient")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, columnDefinition = "BIGINT AUTO_INCREMENT PRIMARY KEY")
    private Long id;

    @Column(name = "name", nullable = false, length = 255, columnDefinition = "VARCHAR(255) COMMENT '환자 이름' AFTER id")
    private String name;

    @Column(name = "security_num", unique = true, length = 14, columnDefinition = "VARCHAR(14) COMMENT '주민등록번호' AFTER name")
    private String securityNum;

    @Column(name = "gender", length = 1, columnDefinition = "CHAR(1) COMMENT '성별' AFTER security_num")
    private Character gender;

    @Column(name = "address", columnDefinition = "TEXT COMMENT '주소' AFTER gender")
    private String address;
    
    @Column(name = "phone", columnDefinition = "VARCHAR(20) COMMENT '전화번호' AFTER address")
    private String phone;
    
    @Column(name = "email", columnDefinition = "VARCHAR(255) COMMENT '이메일' AFTER phone")
    private String email;

    @Column(name = "blood_type", length = 6, columnDefinition = "VARCHAR(6) COMMENT '혈액형' AFTER email")
    private String bloodType;

    @Column(name = "height", columnDefinition = "INT COMMENT '키' AFTER blood_type")
    private Integer height;
    
    @Column(name = "weight", columnDefinition = "INT COMMENT '몸무게' AFTER height")
    private Integer weight;

    @Column(name = "allergies", columnDefinition = "TEXT COMMENT '알레르기' AFTER weight")
    private String allergies;

    @Column(name = "blood_pressure", length = 10, columnDefinition = "VARCHAR(10) COMMENT '혈압' AFTER allergies")
    private String bloodPressure;

    @Column(name = "temperature", precision = 4, scale = 1, columnDefinition = "DECIMAL(4,1) COMMENT '체온' AFTER blood_pressure")
    private BigDecimal temperature;

    @Column(name = "smoking_status", length = 1, columnDefinition = "CHAR(1) COMMENT '흡연 여부' AFTER temperature")
    private Character smokingStatus;
}

