package com.emr.www.entity.doctor.dto;
import javax.xml.bind.annotation.XmlElement;

public class DrugDTO {

    private String cpntCd;
    private String drugCpntKorNm;
    private String fomlNm;
    private String dosageRouteCode;
    private String dayMaxDosgQyUnit;
    private String dayMaxDosgQy;

    @XmlElement(name = "CPNT_CD")
    public String getCpntCd() {
        return cpntCd;
    }

    public void setCpntCd(String cpntCd) {
        this.cpntCd = cpntCd;
    }

    @XmlElement(name = "DRUG_CPNT_KOR_NM")
    public String getDrugCpntKorNm() {
        return drugCpntKorNm;
    }

    public void setDrugCpntKorNm(String drugCpntKorNm) {
        this.drugCpntKorNm = drugCpntKorNm;
    }

    @XmlElement(name = "FOML_NM")
    public String getFomlNm() {
        return fomlNm;
    }

    public void setFomlNm(String fomlNm) {
        this.fomlNm = fomlNm;
    }

    @XmlElement(name = "DOSAGE_ROUTE_CODE")
    public String getDosageRouteCode() {
        return dosageRouteCode;
    }

    public void setDosageRouteCode(String dosageRouteCode) {
        this.dosageRouteCode = dosageRouteCode;
    }

    @XmlElement(name = "DAY_MAX_DOSG_QY_UNIT")
    public String getDayMaxDosgQyUnit() {
        return dayMaxDosgQyUnit;
    }

    public void setDayMaxDosgQyUnit(String dayMaxDosgQyUnit) {
        this.dayMaxDosgQyUnit = dayMaxDosgQyUnit;
    }

    @XmlElement(name = "DAY_MAX_DOSG_QY")
    public String getDayMaxDosgQy() {
        return dayMaxDosgQy;
    }

    public void setDayMaxDosgQy(String dayMaxDosgQy) {
        this.dayMaxDosgQy = dayMaxDosgQy;
    }
}
