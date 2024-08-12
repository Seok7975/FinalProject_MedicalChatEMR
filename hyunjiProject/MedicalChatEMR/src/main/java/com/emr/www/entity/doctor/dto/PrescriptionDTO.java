package com.emr.www.entity.doctor.dto;


public class PrescriptionDTO {

	private String entpName; //약품 회사
	private String itemSeq; //코드
	private String itemName; //약품명
	private String useMethodQesitm; //복용방법
	
	public String getEntpName() {
		return entpName;
	}
	
	public void setEntpName(String entpName) {
		this.entpName = entpName;
	}
	
	public String getItemSeq() {
		return itemSeq;
	}
	
	public void setItemSeq(String itemSeq) {
		this.itemSeq = itemSeq;
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
