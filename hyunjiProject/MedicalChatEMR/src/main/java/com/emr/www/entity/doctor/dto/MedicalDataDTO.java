package com.emr.www.entity.doctor.dto;

import java.util.List;

public class MedicalDataDTO {

    private List<DiagnosisDTO> diagnosis;
    private List<DrugDTO> drugs;
    private List<PrescriptionDTO> prescriptions;

    // 기본 생성자
    public MedicalDataDTO() {
    }

    // 모든 필드를 받는 생성자
    public MedicalDataDTO(List<DiagnosisDTO> diagnoses, List<DrugDTO> drugs, List<PrescriptionDTO> prescriptions) {
        this.diagnosis = diagnoses;
        this.drugs = drugs;
        this.prescriptions = prescriptions;
    }

    // Getter 및 Setter
    public List<DiagnosisDTO> getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(List<DiagnosisDTO> diagnosis) {
        this.diagnosis = diagnosis;
    }

    public List<DrugDTO> getDrugs() {
        return drugs;
    }

    public void setDrugs(List<DrugDTO> drugs) {
        this.drugs = drugs;
    }

    public List<PrescriptionDTO> getPrescriptions() {
        return prescriptions;
    }

    public void setPrescriptions(List<PrescriptionDTO> prescriptions) {
        this.prescriptions = prescriptions;
    }
}
