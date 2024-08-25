package com.emr.www.dto.doctor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DiagnosisDTO {

	public DiagnosisDTO(String diseaseCode, String diseaseName) {
	    this.diseaseCode = diseaseCode;
	    this.diseaseName = diseaseName;
	}

	private int no;
	private int chartNum;
	private String diseaseCode;
	private String diseaseName;
}