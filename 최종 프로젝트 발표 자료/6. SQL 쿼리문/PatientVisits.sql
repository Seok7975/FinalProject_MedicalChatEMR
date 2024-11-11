use emr;

drop table patientvisits;

-- 환자내원 테이블
CREATE TABLE PatientVisits (
    no BIGINT AUTO_INCREMENT PRIMARY KEY, -- 내원 기록의 고유 식별자입니다.
    visitDate DATE, -- 내원 날짜입니다.
    visitTime TIME, -- 진료 시각입니다.
    patientName VARCHAR(50), -- 환자의 이름입니다.
    securityNum VARCHAR(14), -- 환자의 주민등록번호입니다. (RegisterPatients 테이블의 securityNum과 연결 가능)
    phone VARCHAR(20),    
    visitReason TEXT, -- 내원 사유입니다.
    doctorName VARCHAR(50), -- 담당 의사의 이름입니다.
    nurseName VARCHAR(50), -- 담당 간호사의 이름입니다.
    visitHistory TEXT, -- 내원 이력입니다. ex) 2024-08-19 19:48 피부염(담당의(없으면 없음), 담당간호사(없으면 없음))
    FOREIGN KEY (securityNum) REFERENCES RegisterPatients(securityNum) -- RegisterPatients 테이블과의 외래키 관계
);

-- 환자 내원 테이블ver2
CREATE TABLE PatientVisits (
    no INT AUTO_INCREMENT PRIMARY KEY, -- 내원 기록의 고유 식별자입니다.
    patientNo INT, -- 환자 등록 테이블 주키
    visitDate DATE, -- 내원(방문) 날짜
    visitTime TIME, -- 내원(방문) 시간
    patientName VARCHAR(50), -- 환자의 이름입니다.
    securityNum VARCHAR(14), -- 환자의 주민등록번호입니다.
    visitReason TEXT, -- 내원 사유입니다.
    doctorName varchar(45), -- 담당 의사
    nurseName varchar(45), -- 담당 간호사
    doctorNo INT, -- 담당 의사 번호(타입을 INT로 변경)
    nurseNo INT, -- 담당 간호사 번호(타입을 INT로 변경)
    FOREIGN KEY (patientNo) REFERENCES PatientRegistrations(no), -- 외래키 관계
    FOREIGN KEY (doctorNo) REFERENCES Doctor(no), -- 외래키 관계
    FOREIGN KEY (nurseNo) REFERENCES Nurse(no) -- 외래키 관계
);

-- PatientVisits 테이블에 외래키 추가
ALTER TABLE PatientVisits
ADD CONSTRAINT FK_PatientVisits_PatientRegistrations
FOREIGN KEY (patientNo) REFERENCES PatientRegistrations(no);

-- PatientVisits 테이블에 외래키 추가 (Doctor 테이블과의 관계)
ALTER TABLE PatientVisits
ADD CONSTRAINT FK_PatientVisits_Doctor
FOREIGN KEY (doctorNo) REFERENCES Doctor(no);

-- PatientVisits 테이블에 외래키 추가 (Nurse 테이블과의 관계)
ALTER TABLE PatientVisits
ADD CONSTRAINT FK_PatientVisits_Nurse
FOREIGN KEY (nurseNo) REFERENCES Nurse(no);

ALTER TABLE PatientVisits
DROP FOREIGN KEY securityNum;

drop table PatientVisits;