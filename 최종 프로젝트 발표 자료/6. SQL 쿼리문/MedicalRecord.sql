-- 진료 기록 테이블
CREATE TABLE MedicalRecord (
    chartNum INT AUTO_INCREMENT PRIMARY KEY, -- 차트 번호
    patientNo INT NOT NULL, -- 환자 ID
    docNo INT NOT NULL, -- 진료 의사 ID
    symptoms TEXT, -- 증상
    surgeryStatus CHAR(1), -- 수술 여부 ('Y' 또는 'N')
    progress TEXT, -- 경과
    visitDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 진료 일자
    FOREIGN KEY (patientNo) REFERENCES PatientRegistrations(no) ON DELETE CASCADE,
    FOREIGN KEY (docNo) REFERENCES Doctor(no) ON DELETE CASCADE
);