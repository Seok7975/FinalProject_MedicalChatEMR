package com.emr.www.entity.nurse;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
@Table(name = "Nurse")
public class NurseEntity {
	  @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private int no;

	    @Column
	    private String name;

	    @Column(unique = true,  columnDefinition = "CHAR(14)") // 주민등록번호 (Unique Key)
	    private String securityNum;

	    @Column(unique = true)
	    private String email;

	    @Column
	    private String phone;

	    @Column(unique = true, columnDefinition = "CHAR(16)")
	    private String licenseId;

	    @Column
	    private String password;
	    
	    private String position; 

	    @Column(length = 10)
	    private String departmentId;

	    private String profileImage;

	    @Column
	    private String activeStatus;
}