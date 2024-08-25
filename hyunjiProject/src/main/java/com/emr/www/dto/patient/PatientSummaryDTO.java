package com.emr.www.dto.patient;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PatientSummaryDTO { //환자 목록에 기본정보 표시하는 용도

	private int no;
	private String name;
	private String birthDate; //생년월일

}
