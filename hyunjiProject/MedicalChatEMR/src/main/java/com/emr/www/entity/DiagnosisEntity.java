package com.emr.www.entity;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="Diagnosis")
public class DiagnosisEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) //no가 주키
	private Integer no;
	
	private String disease_code; //질병 코드
	private String disease_name; //질병 명칭
	
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
