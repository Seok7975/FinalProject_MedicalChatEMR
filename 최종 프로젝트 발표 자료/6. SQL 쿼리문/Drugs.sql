-- 약물 테이블
CREATE TABLE Drugs (
    no INT AUTO_INCREMENT PRIMARY KEY,
    chartNum INT NOT NULL, -- MedicalRecord의 차트 번호 참조
    cpntCd VARCHAR(100), -- 성분 코드
    ingdNameKor VARCHAR(200), -- 성분명(한글)
    fomlNm VARCHAR(30), -- 제형명
    dosageRouteCode VARCHAR(50), -- 투여경로
    dayMaxDosgQyUnit VARCHAR(50), -- 투여 단위
    dayMaxDosgQy VARCHAR(20), -- 1일 최대 투여량
    FOREIGN KEY (chartNum) REFERENCES MedicalRecord(chartNum) ON DELETE CASCADE
);