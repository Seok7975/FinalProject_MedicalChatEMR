-- patient-- 환자 등록 테이블
CREATE TABLE RegisterPatients (
    idNo INT AUTO_INCREMENT PRIMARY KEY, -- 환자의 고유 식별자입니다.
    name VARCHAR(50), -- 환자의 이름입니다.
    securityNum VARCHAR(14) UNIQUE, -- 주민등록번호입니다.
    gender CHAR(1), -- 성별 ('M' 또는 'F').
    address VARCHAR(255), -- 주소입니다
    phone VARCHAR(20), -- 전화번호입니다.
    email VARCHAR(50), -- 이메일 주소입니다.
    bloodType VARCHAR(6), -- 혈액형입니다. // 예외처리 추가
    height float, -- 키(센티미터)입니다.
    weight float, -- 체중(킬로그램)입니다.
    allergies TEXT, -- 알레르기 정보입니다.
    bloodPressure VARCHAR(10), -- 혈압 120/80 (mmHg)
    temperature DECIMAL(4, 1), -- 체온 -9.9 ~ 99.9 (도씨)
    smokingStatus CHAR(1) -- 흡연 여부 ('Y' 또는 'N'). // 예외처리 추가
);