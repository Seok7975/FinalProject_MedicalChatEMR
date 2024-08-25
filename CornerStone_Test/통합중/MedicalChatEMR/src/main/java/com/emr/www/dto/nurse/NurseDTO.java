package com.emr.www.dto.nurse;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NurseDTO {

	private int no; // int형 PK
	private String name; // 간호사 이름
	private String securityNum; // 주민등록번호
	private String email; // 이메일
	private String phone; // 전화번호
	private String licenseId; // 면허 ID
	private String password; // 비밀번호
	private String position;// 직급 
	private String departmentId;  //진료과;
	private String profileImage; // 프로필 이미지 경로
	private String activeStatus; // 활동 상태 ('자리 비움', '진료 중', '점심시간')
}

