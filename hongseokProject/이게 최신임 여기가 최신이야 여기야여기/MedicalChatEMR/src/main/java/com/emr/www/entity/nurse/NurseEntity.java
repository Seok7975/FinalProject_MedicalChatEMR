package com.emr.www.entity.nurse;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Nurse")
public class NurseEntity {

    @Id
    //@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "no")
    private int no;  // int형 자동 증가 PK

    @Column(name = "name", nullable = false)
    private String name;  // 간호사 이름

    @Column(name = "security_num", nullable = false, unique = true)
    private String securityNum;  // 주민등록번호

    @Column(name = "email", nullable = false, unique = true)
    private String email;  // 이메일

    @Column(name = "phone", nullable = false)
    private String phone;  // 전화번호

    @Column(name = "license_id", nullable = false, unique = true)
    private String licenseId;  // 면허 ID

    @Column(name = "password", nullable = false)
    private String password;  // 비밀번호

    @Column(name = "position", nullable = false)
    private String position;  // 직급

    @Column(name = "profile_image")
    private String profileImage;  // 프로필 이미지 경로

    @Column(name = "active_status", nullable = false)
    private String activeStatus;
    
    @Column(name = "department_id", nullable = false)
    private String departmentId;

    // 기본 생성자
    public NurseEntity() {}

    // Getters and Setters

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

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

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
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
    public void setDepartmentId(String departmentId) {
    	this.departmentId = departmentId;
    }
    public String getDepartmentId() {
    	return departmentId;
    }
}
