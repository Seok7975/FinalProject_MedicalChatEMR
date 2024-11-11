-- 약품 테이블
CREATE TABLE Prescriptions (
    no INT AUTO_INCREMENT PRIMARY KEY, -- 고유 번호
    chartNum INT NOT NULL, -- MedicalRecord의 차트 번호 참조
    entpName VARCHAR(255), -- 약품 회사
    itemSeq VARCHAR(100), -- 코드
    itemName VARCHAR(100), -- 약품명
    useMethodQesitm TEXT, -- 복용방법
    FOREIGN KEY (chartNum) REFERENCES MedicalRecord(chartNum) ON DELETE CASCADE
);