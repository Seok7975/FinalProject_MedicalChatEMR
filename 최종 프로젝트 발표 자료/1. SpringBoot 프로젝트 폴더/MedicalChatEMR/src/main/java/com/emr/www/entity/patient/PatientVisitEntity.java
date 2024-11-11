package com.emr.www.entity.patient;

import java.time.LocalDate;
import java.time.LocalTime;

import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//환자 내원 테이블
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "PatientVisits")
public class PatientVisitEntity {
	


    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT")
    private int no;

    @Column
    private LocalDate visitDate;
    
    @Column
    private LocalTime visitTime;
    
    @Column
    private String patientName;
    
    @Column
    private String securityNum;
    
    @Column
    private String visitReason;
    
    @Column
    private String doctorName;
    
    @Column
    private String nurseName;
//    private String visitHistory;

//    @ManyToOne
//    @JoinColumn(name = "securityNum", referencedColumnName = "securityNum")
//    private PatientRegistrationEntity patient;
    
    @ManyToOne
    @JoinColumn(name = "patientNo", referencedColumnName = "no", columnDefinition = "INT")
    private PatientRegistrationEntity patient;

    @ManyToOne
    @JoinColumn(name = "doctorNo", referencedColumnName = "no", columnDefinition = "INT")
    private DoctorEntity doctor;

    @ManyToOne
    @JoinColumn(name = "nurseNo", referencedColumnName = "no", columnDefinition = "INT")
    private NurseEntity nurse;
}