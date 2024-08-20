package com.emr.www.dto.doctor;

public class DrugDTO {

	private String cpntCd; //성분 코드
	private String drugCpntKorNm; //성분 명
	private String fomlNm; //제형명
	private String dosageRouteCode; //투여 경로
	private String dayMaxDosgQyUnit; //투여 단위
	private String dayMaxDosgQy; //1일 최대 투여량

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
