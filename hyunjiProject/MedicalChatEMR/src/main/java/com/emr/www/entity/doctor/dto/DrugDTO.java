package com.emr.www.entity.doctor.dto;
import javax.xml.bind.annotation.XmlElement;

public class DrugDTO {

	private String cpntCd;
	private String drugCpntKorNm;
	private String fomlNm;
	private String dosageRouteCode;
	private String dayMaxDosgQyUnit;
	private String dayMaxDosgQy;

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
