package com.emr.www.dto.doctor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DoctorDTO {

	private int no;
	private String name;
	private String securityNum;
	private String email;
	private String phone;
	private String licenseId;
	private String password;
	private String position;
	private String departmentId;
	private String profileImage;
	private String activeStatus;
}