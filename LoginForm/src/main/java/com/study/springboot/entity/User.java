package com.study.springboot.entity;


import javax.persistence.*;

@Entity
public class User {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;
	private String licenseKey;
	private String password;
	
	public long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id=id;
	}
	public String getLicenseKey() {
		return licenseKey;
	}
	public void setLicenseKey(String licenseKey) {
		this.licenseKey = licenseKey;
	}

	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password=password;
	}
	
}