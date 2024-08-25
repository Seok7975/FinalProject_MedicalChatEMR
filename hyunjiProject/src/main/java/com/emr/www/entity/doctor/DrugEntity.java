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
@Table(name = "Drugs")
public class DrugEntity {

	// 필요한 생성자 추가
	public DrugEntity(String cpntCd, String ingdNameKor, String fomlNm, String dosageRouteCode, String dayMaxDosgQyUnit, String dayMaxDosgQy) {
		this.cpntCd = cpntCd; //성분 코드
		this.ingdNameKor = ingdNameKor; //성분명
		this.fomlNm = fomlNm; //제형명
		this.dosageRouteCode = dosageRouteCode; //투여 경로
		this.dayMaxDosgQyUnit = dayMaxDosgQyUnit; //투여 단위
		this.dayMaxDosgQy = dayMaxDosgQy; //1일 최대 투여량
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;

	@ManyToOne
	@JoinColumn(name = "chartNum")
	private MedicalRecordEntity medicalRecord; //진료 차트 번호

	private String cpntCd; // 성분 코드
	private String ingdNameKor; // 성분명(한글)
	private String fomlNm; // 제형명
	private String dosageRouteCode; // 투여경로
	private String dayMaxDosgQyUnit; // 투여 단위
	private String dayMaxDosgQy; // 1일 최대 투여량
}
