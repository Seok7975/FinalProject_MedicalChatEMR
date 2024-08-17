package com.emr.www.entity.doctor;

import com.emr.www.entity.MedicalRecordEntity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class DrugEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;

	@ManyToOne
	@JoinColumn(name = "chart_num", nullable = false)
	
	private MedicalRecordEntity medicalRecordEntity;
	
	private String cpntCd; //성분 코드
	private String drugCpntKorNm; //성분명
	private String fomlNm; //제형명
	private String dosageRouteCode; //투여 경로
	private String dayMaxDosgQyUnit; //투여 단위
	private String dayMaxDosgQy; //1일 최대 투여량

	// 기본 생성자
	public DrugEntity() {
	}

	// 모든 필드를 매개변수로 받는 생성자 추가
	public DrugEntity(String cpntCd, String drugCpntKorNm, String fomlNm, String dosageRouteCode, String dayMaxDosgQyUnit, String dayMaxDosgQy) {
		this.cpntCd = cpntCd;
		this.drugCpntKorNm = drugCpntKorNm;
		this.fomlNm = fomlNm;
		this.dosageRouteCode = dosageRouteCode;
		this.dayMaxDosgQyUnit = dayMaxDosgQyUnit;
		this.dayMaxDosgQy = dayMaxDosgQy;
	}

	// Getters and Setters for all fields
	public String getCpntCd() {
		return cpntCd;
	}

	public void setCpntCd(String cpntCd) {
		this.cpntCd = cpntCd;
	}

	public String getDrugCpntKorNm() {
		return drugCpntKorNm;
	}

	public void setDrugCpntKorNm(String drugCpntKorNm) {
		this.drugCpntKorNm = drugCpntKorNm;
	}

	public String getFomlNm() {
		return fomlNm;
	}

	public void setFomlNm(String fomlNm) {
		this.fomlNm = fomlNm;
	}

	public String getDosageRouteCode() {
		return dosageRouteCode;
	}

	public void setDosageRouteCode(String dosageRouteCode) {
		this.dosageRouteCode = dosageRouteCode;
	}

	public String getDayMaxDosgQyUnit() {
		return dayMaxDosgQyUnit;
	}

	public void setDayMaxDosgQyUnit(String dayMaxDosgQyUnit) {
		this.dayMaxDosgQyUnit = dayMaxDosgQyUnit;
	}

	public String getDayMaxDosgQy() {
		return dayMaxDosgQy;
	}

	public void setDayMaxDosgQy(String dayMaxDosgQy) {
		this.dayMaxDosgQy = dayMaxDosgQy;
	}
}
