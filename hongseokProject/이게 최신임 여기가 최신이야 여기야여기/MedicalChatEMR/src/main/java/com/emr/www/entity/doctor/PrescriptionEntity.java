package com.emr.www.entity.doctor;

import com.emr.www.entity.employeestatus.EmployeeStatusEntity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class PrescriptionEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int no;

	@ManyToOne
	@JoinColumn(name = "chart_num", nullable = false)
	private EmployeeStatusEntity employeeStatusEntity;
	
	private String itemSeq; //약품 코드
	private String entpName; //업체명
	private String itemName; //약품명
	private String useMethodQesitm; //복용법

	// 기본 생성자
	public PrescriptionEntity() {
	}

	// 모든 필드를 매개변수로 받는 생성자
	public PrescriptionEntity(String itemSeq, String entpName, String itemName, String useMethodQesitm) {
		this.itemSeq = itemSeq;
		this.entpName = entpName;
		this.itemName = itemName;
		this.useMethodQesitm = useMethodQesitm;
	}

	// Getters and Setters
	public String getItemSeq() {
		return itemSeq;
	}

	public void setItemSeq(String itemSeq) {
		this.itemSeq = itemSeq;
	}

	public String getEntpName() {
		return entpName;
	}

	public void setEntpName(String entpName) {
		this.entpName = entpName;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getUseMethodQesitm() {
		return useMethodQesitm;
	}

	public void setUseMethodQesitm(String useMethodQesitm) {
		this.useMethodQesitm = useMethodQesitm;
	}
}
