package com.emr.www.entity.doctor;

import com.emr.www.entity.MedicalRecordEntity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class DiagnosisEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;

	@ManyToOne
	@JoinColumn(name = "chart_num", nullable = false)
	private MedicalRecordEntity medicalRecordEntity;
	
	private String disease_code; //질병 코드
	private String disease_name; //질병명

	// 기본 생성자
	public DiagnosisEntity() {
	}

	// 모든 필드를 매개변수로 받는 생성자
	public DiagnosisEntity(String disease_code, String disease_name) {
		this.disease_code = disease_code;
		this.disease_name = disease_name;
	}

	// Getters and Setters
	public String getDisease_code() {
		return disease_code;
	}

	public void setDisease_code(String disease_code) {
		this.disease_code = disease_code;
	}

	public String getDisease_name() {
		return disease_name;
	}

	public void setDisease_name(String disease_name) {
		this.disease_name = disease_name;
	}
}
