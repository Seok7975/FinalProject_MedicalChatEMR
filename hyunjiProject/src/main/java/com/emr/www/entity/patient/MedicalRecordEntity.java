package com.emr.www.entity.patient;

import java.time.LocalDateTime;
import java.util.List;

import com.emr.www.entity.doctor.DiagnosisEntity;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.doctor.DrugEntity;
import com.emr.www.entity.doctor.PrescriptionEntity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
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
@Table(name = "MedicalRecord")
public class MedicalRecordEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int chartNum;

    @ManyToOne
    @JoinColumn(name = "patientNo", referencedColumnName = "no")
    private PatientRegistrationEntity patient;

    @ManyToOne
    @JoinColumn(name = "docNo", referencedColumnName = "no")
    private DoctorEntity doctor;

    private String symptoms;
    private String surgeryStatus;
    private String progress;
    private LocalDateTime visitDate;
    
    @OneToMany(mappedBy = "medicalRecord")
    private List<DiagnosisEntity> diagnoses;

    @OneToMany(mappedBy = "medicalRecord")
    private List<PrescriptionEntity> prescriptions;

    @OneToMany(mappedBy = "medicalRecord")
    private List<DrugEntity> drugs;

}