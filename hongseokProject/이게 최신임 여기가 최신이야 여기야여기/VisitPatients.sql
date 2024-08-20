-- 환자내원 테이블
CREATE TABLE VisitPatients (
    visitId INT AUTO_INCREMENT PRIMARY KEY, -- 내원 기록의 고유 식별자입니다.
    visitDate DATE, -- 내원 날짜입니다.
    visitTime TIME, -- 진료 시각입니다.
    patientName VARCHAR(50), -- 환자의 이름입니다.
    securityNum VARCHAR(14), -- 환자의 주민등록번호입니다. (RegisterPatients 테이블의 securityNum과 연결 가능)
    visitReason TEXT, -- 내원 사유입니다.
    doctorName VARCHAR(50), -- 담당 의사의 이름입니다.
    nurseName VARCHAR(50), -- 담당 간호사의 이름입니다.
    visitHistory TEXT, -- 내원 이력입니다. ex) 2024-08-19 19:48 피부염(담당의(없으면 없음), 담당간호사(없으면 없음))
    FOREIGN KEY (securityNum) REFERENCES RegisterPatients(securityNum) -- RegisterPatients 테이블과의 외래키 관계
);