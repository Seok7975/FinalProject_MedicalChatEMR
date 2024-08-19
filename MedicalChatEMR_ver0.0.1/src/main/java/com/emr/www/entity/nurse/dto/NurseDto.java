package com.emr.www.entity.nurse.dto;

public class NurseDto {

    private Long no;  // Long형 PK
    private String name;  // 간호사 이름
    private String securityNum;  // 주민등록번호
    private String email;  // 이메일
    private String phone;  // 전화번호
    private String licenseId;  // 면허 ID
    private String password;  // 비밀번호
    private String position;  // 직급 
    private String profileImage;  // 프로필 이미지 경로
    private String activeStatus;  // 활동 상태 (enum: '자리 비움', '진료 중', '점심시간')

    // 기본 생성자
    public NurseDto() {}

    // Getter와 Setter 메서드
 

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSecurityNum() {
        return securityNum;
    }

    public void setSecurityNum(String securityNum) {
        this.securityNum = securityNum;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLicenseId() {
        return licenseId;
    }

    public void setLicenseId(String licenseId) {
        this.licenseId = licenseId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getActiveStatus() {
        return activeStatus;
    }

    public void setActiveStatus(String activeStatus) {
        this.activeStatus = activeStatus;
    }

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Long getNo() {
		return no;
	}

	public void setNo(Long no) {
		this.no = no;
	}
}
