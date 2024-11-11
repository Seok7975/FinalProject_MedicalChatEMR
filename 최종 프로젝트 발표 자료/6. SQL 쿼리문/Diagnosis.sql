-- 진단 테이블
CREATE TABLE Diagnosis (
    no INT AUTO_INCREMENT PRIMARY KEY,
    chartNum INT NOT NULL, -- MedicalRecord의 차트 번호 참조
    diseaseCode VARCHAR(10), -- 질병 코드
    diseaseName VARCHAR(255), -- 질병 명칭
    FOREIGN KEY (chartNum) REFERENCES MedicalRecord(chartNum) ON DELETE CASCADE
);