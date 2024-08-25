package com.emr.www.dto.doctor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DrugDTO {

	public DrugDTO(String cpntCd, String ingdNameKor, String fomlNm, String dosageRouteCode, String dayMaxDosgQyUnit, String dayMaxDosgQy) {
	    this.cpntCd = cpntCd;
	    this.ingdNameKor = ingdNameKor;
	    this.fomlNm = fomlNm;
	    this.dosageRouteCode = dosageRouteCode;
	    this.dayMaxDosgQyUnit = dayMaxDosgQyUnit;
	    this.dayMaxDosgQy = dayMaxDosgQy;
	}

	private int no;
	private int chartNum;
	private String cpntCd; //성분 코드
	private String ingdNameKor; //성분 명
	private String fomlNm; //제형명
	private String dosageRouteCode; //투여 경로
	private String dayMaxDosgQyUnit; //투여 단위
	private String dayMaxDosgQy; //1일 최대 투여량
}
