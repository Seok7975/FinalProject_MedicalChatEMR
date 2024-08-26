package com.emr.www.dto.patient;

import java.time.LocalDate;
import java.time.LocalTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PatientVisitDTO {

//	private int no; //auto increment기 때문에 없어도 됨
	private LocalDate visitDate;
	private LocalTime visitTime;
	private String patientName;
	private String securityNum;
	private String visitReason;
	private String doctorName;
	private String nurseName;
//	private String visitHistory;
	private int patientNo;
	private int doctorNo;  // 추가
	private int nurseNo;   // 추가
}