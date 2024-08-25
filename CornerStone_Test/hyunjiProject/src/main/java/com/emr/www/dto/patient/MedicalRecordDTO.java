package com.emr.www.dto.patient;

import java.time.LocalDateTime;
import java.util.List;

import com.emr.www.dto.doctor.DiagnosisDTO;
import com.emr.www.dto.doctor.DrugDTO;
import com.emr.www.dto.doctor.PrescriptionDTO;
import com.emr.www.entity.doctor.DiagnosisEntity;
import com.emr.www.entity.doctor.DrugEntity;
import com.emr.www.entity.doctor.PrescriptionEntity;
import com.emr.www.entity.patient.MedicalRecordEntity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MedicalRecordDTO {

	private int chartNum;
	private int patientNo;
	private String doctorName; 
	private String symptoms; //증상 메모
	private String surgeryStatus; // 여부 Y/N
	private String progress;
	private LocalDateTime visitDate;

	private List<DiagnosisDTO> diagnoses; // 진단 정보
	private List<PrescriptionDTO> prescriptions; // 처방 정보
	private List<DrugDTO> drugs; // 약물 정보
	

}
