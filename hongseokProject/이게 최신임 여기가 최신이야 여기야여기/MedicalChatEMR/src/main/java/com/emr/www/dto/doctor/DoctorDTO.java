package com.emr.www.dto.doctor;

import org.springframework.stereotype.Component;


@Component
public class DoctorDTO {
	private int no;
    private String name;
    private String phone;
    private String securityNum;
    private String email;
    private String position;
    private String licenseId; // 추가된 필드
    private String password;  // 추가된 필드
    private String departmentId; // 추가된 필드
    private String profileImage; // 추가된 필드
    private String activeStatus; // 추가된 필드

    // Getter와 Setter 메서드

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
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
    public String getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
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
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
}