package com.emr.www.dto.patient;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PatientVisitDTO {

	private int no;  // 내원 기록의 고유 식별자
	
    private String patientName;  // 환자 이름
    private String securityNum;  // 주민등록번호
    private String visitReason;  // 내원 사유
    private int patientNo;  // 환자 등록 번호 - 홍석오빠 프로젝트에는 없음
    private int doctorNo;  // 담당 의사 번호
    private int nurseNo;  // 담당 간호사 번호
}
