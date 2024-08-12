package com.emr.www.entity.doctor;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "prescriptions")
public class DrugEntity {

    @Id
    private String cpntCd;

    private String ingdNameKor;
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

	public String getIngdNameKor() {
		return ingdNameKor;
	}

	public void setIngdNameKor(String ingdNameKor) {
		this.ingdNameKor = ingdNameKor;
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
