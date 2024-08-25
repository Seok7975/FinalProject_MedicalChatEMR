package com.emr.www.entity.doctor;

import com.emr.www.entity.patient.MedicalRecordEntity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "Diagnosis")
public class DiagnosisEntity {

	// 필요한 생성자 추가
	public DiagnosisEntity(String diseaseCode, String diseaseName) {
		this.diseaseCode = diseaseCode;
		this.diseaseName = diseaseName;
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;

	@ManyToOne
	@JoinColumn(name = "chartNum")
	private MedicalRecordEntity medicalRecord;

	private String diseaseCode;
	private String diseaseName;
}