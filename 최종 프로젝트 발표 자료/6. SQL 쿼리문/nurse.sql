SELECT * FROM emr.nurse;

-- 간호사 테이블
CREATE TABLE Nurse (
    no INT AUTO_INCREMENT PRIMARY KEY, -- 간호사의 고유 식별자 (Primary Key)
    name VARCHAR(100), -- 간호사의 이름
    securityNum CHAR(14) UNIQUE, -- 주민등록번호 (Unique Key)
    email VARCHAR(320) UNIQUE, -- 이메일 주소 (Unique Key)      잠시 해제중!!!!!
    phone VARCHAR(20), -- 전화번호
    licenseId CHAR(16) UNIQUE, -- 면허 ID (Unique Key)
    password VARCHAR(100), -- 비밀번호 (암호화 저장 추천)
    position VARCHAR(10), -- 직급 - N/H
    departmentId VARCHAR(10), -- 소속 진료과
    profileImage VARCHAR(255), -- 프로필 이미지 경로
    activeStatus VARCHAR(50) -- 활동 상태
);

INSERT INTO Nurse (no, name, securityNum, email, phone, licenseId, password, position, departmentId, profileImage, activeStatus)
VALUES 
(1, 'Nurse Jane Doe', '890123-4567890', 'jane.doe@example.com', '010-9876-5432', 'NRS1234567890', 'password456', 'Head Nurse', 'NS001', '/images/janedoe.jpg', 'Active'),
(3, '현지수', '183047-8037408', 'hw010315@naver.com', '010-9979-1234', '7daf4c75', '1234', 'H', '소아과', '/images/ProfileImage/현지수_jisoo.png', '자리 비움'),
(4, '박홍기', '984702-3473289', 'seok7975@naver.com', '010-2874-0274', 'de09db4e', '1234', 'N', '소아과', '/images/ProfileImage/박홍기_박홍기.PNG', '자리 비움'),
(8, '윤두준', '273027-4023478', 'seok7975@naver.com', '010-2874-0274', '3666949e', '1234', 'N', '소아과', '/images/ProfileImage/윤두준_윤두준.PNG', '자리 비움'),
(9, '양요섭', '478564-2823984', 'seok7975@naver.com', '010-4987-5398', 'd9c4e3d9', '1234', 'H', '소아과', '/images/ProfileImage/양요섭_IMG_9754.jpeg', '자리 비움');
