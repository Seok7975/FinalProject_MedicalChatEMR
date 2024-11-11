-- 관리자 테이블 
CREATE TABLE Admin (
    no INT AUTO_INCREMENT PRIMARY KEY, -- 관리자의 고유 식별자입니다.
    password VARCHAR(20) NOT NULL, -- 관리자의 비밀번호입니다.
    adminEmail VARCHAR(320) UNIQUE -- 관리자의 이메일 주소입니다.
); 