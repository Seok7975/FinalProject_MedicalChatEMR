use emr;
create database emr;

-- 간호사 테이블
CREATE TABLE Nurse (
    id_no INT AUTO_INCREMENT PRIMARY KEY, -- 간호사의 고유 식별자입니다.
    name VARCHAR(100), -- 간호사의 이름입니다.
    security_num CHAR(14) UNIQUE, -- 주민등록번호입니다.
    email VARCHAR(320) UNIQUE, -- 이메일 주소입니다.
    phone VARCHAR(20), -- 전화번호입니다.
    license_id CHAR(8) UNIQUE, -- 고유 식별자로 사용할 8자리 ID
    password VARCHAR(15), -- (초기에는 NULL)
    role CHAR(1) NOT NULL, -- 역할 ('N' - 일반 간호사, 'S' - 수간호사)
    profile_image VARCHAR(255), -- 증명사진 경로입니다.
    active_status ENUM('자리 비움', '진료 중', '점심시간') NOT NULL DEFAULT '자리 비움' -- 현재 활동 상태
);




use emr;

ALTER TABLE patient CHANGE COLUMN securpatientvisitspatientvisitsity_num securityNum VARCHAR(255);

drop table patient;