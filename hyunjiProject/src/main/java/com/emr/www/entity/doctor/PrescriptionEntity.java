package com.emr.www.entity.doctor;

import com.emr.www.entity.patient.MedicalRecordEntity;

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

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "Prescriptions")
public class PrescriptionEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int no;

    @ManyToOne
    @JoinColumn(name = "chartNum")
    private MedicalRecordEntity medicalRecord; //진료 차트 번호

    private String entpName; //약품 회사
    private String itemSeq; //약품코드
    private String itemName; //약품명
    private String useMethodQesitm; //사용법
}