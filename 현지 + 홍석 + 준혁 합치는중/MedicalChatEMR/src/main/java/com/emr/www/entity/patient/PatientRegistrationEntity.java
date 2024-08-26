package com.emr.www.entity.patient;

import java.math.BigDecimal;

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

//환자 등록 엔티티
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "PatientRegistrations")
public class PatientRegistrationEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;

	@Column(length = 50)
	private String name;

	@Column(name = "securityNum", unique = true, nullable = false)
	private String securityNum;

	@Column(length = 1)
	private char gender;

	@Column(length = 255)
	private String address;

	@Column(length = 20)
	private String phone;

	@Column(length = 50)
	private String email;

	@Column(length = 6)
	private String bloodType;

	@Column
	private Float height;

	@Column
	private Float weight;

	@Column(columnDefinition = "TEXT")
	private String allergies;

	@Column(length = 10)
	private String bloodPressure;

	@Column(precision = 4, scale = 1)
	private BigDecimal temperature;

	@Column(length = 1)
	private Character smokingStatus;
}