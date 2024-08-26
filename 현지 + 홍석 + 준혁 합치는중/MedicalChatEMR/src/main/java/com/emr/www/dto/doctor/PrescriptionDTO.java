package com.emr.www.dto.doctor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PrescriptionDTO {

	public PrescriptionDTO(String entpName, String itemSeq, String itemName, String useMethodQesitm) {
	    this.entpName = entpName;
	    this.itemSeq = itemSeq;
	    this.itemName = itemName;
	    this.useMethodQesitm = useMethodQesitm;
	}

	private int no;
	private int chartNum;
	private String entpName;
	private String itemSeq;
	private String itemName;
	private String useMethodQesitm;
}