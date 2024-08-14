package com.emr.www.entity.doctor;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Drugs")
public class DrugEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) //no가 주키로, 자동 증가
	private Integer no;

//	@ManyToOne
//	@JoinColumn(name = "chart_num", nullable = false) //외래키로 엔티티와 연관
//	private MedicalRecord medicalRecord;

	private String cpntCd;
	private String drugCpntKorNm;
	private String fomlNm;
	private String dosageRouteCode;
	private String dayMaxDosgQyUnit;
	private String dayMaxDosgQy;

	public Integer getNo() {
		return no;
	}

	public void setNo(Integer no) {
		this.no = no;
	}

//	public MedicalRecord getMedicalRecord() {
//		return medicalRecord;
//	}
//
//	public void setMedicalRecord(MedicalRecord medicalRecord) {
//		this.medicalRecord = medicalRecord;
//	}

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
