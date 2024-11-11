SELECT * FROM emr.doctor;

-- 의사 테이블
CREATE TABLE Doctor (
    no INT AUTO_INCREMENT PRIMARY KEY, -- 의사의 고유 식별자입니다.
    name VARCHAR(100), -- 의사의 이름입니다.
    securityNum CHAR(14) UNIQUE, -- 주민등록번호입니다.
    email VARCHAR(100) UNIQUE, -- 이메일 주소입니다.    잠시 해제중!!!!!
    phone VARCHAR(20), -- 전화번호입니다.
    licenseId CHAR(8) UNIQUE, -- 고유 식별자로 사용할 8자리 ID
    password VARCHAR(15), -- (초기에는 NULL)
    position VARCHAR(20), -- 직급입니다.
    departmentId VARCHAR(10), -- 소속 진료과입니다.
    profileImage VARCHAR(255), -- 증명사진 경로입니다.
    activeStatus VARCHAR(50) NOT NULL -- 현재 활동 상태
);

drop table Doctor;

INSERT INTO Doctor (no, name, securityNum, email, phone, licenseId, password, position, departmentId, profileImage, activeStatus)
VALUES 
(1, 'Dr. John Doe', '123456-1234567', 'john.doe@example.com', '010-1234-5678', 'DOC12345', 'password123', 'Chief Surgeon', 'CS001', '/images/johndoe.jpg', 'Active'),
(2, '박홍석', '170473-0473702', 'seok7975@naver.com', '010-9999-9999', 'c4c3edd2', '1234', '교수', '소아과', '/images/ProfileImage/박홍석_박홍석.png', '자리 비움'),
(11, '박동석', '047304-8310473', 'seok7975@naver.com', '010-9340-3842', '36902f2c', '1234', '인턴', '소아과', '/images/ProfileImage/박동석_박동석.png', '자리 비움'),
(12, '박동지', '833204-7024708', 'seok7975@naver.com', '010-1983-4729', '10766adb', '1234', '레지던트', '소아과', '/images/ProfileImage/박동지_박동지.png', '자리 비움'),
(13, '박동하', '984702-3473289', 'seok7975@naver.com', '010-3274-0327', '84a08468', '1234', '전문의', '소아과', '/images/ProfileImage/박동하_박동하.PNG', '자리 비움');


INSERT INTO Doctor (no, name, securityNum, email, phone, licenseId, password, position, departmentId, profileImage, activeStatus)
VALUES 
(15, '정구현', '170473-0473705', 'seok7975@naver.com', '010-9999-9999', 'c2c3edd4', '1234', '교수', '소아과', '/images/ProfileImage/박홍석_박홍석.png', '자리 비움'),
(16, '하지예', '040704-8310476', 'seok7975@naver.com', '010-9340-3842', '3b902f2c', '1234', '인턴', '소아과', '/images/ProfileImage/박동석_박동석.png', '자리 비움'),
(17, '홍주예', '830104-7024708', 'seok7975@naver.com', '010-1983-4729', '10768adb', '1234', '레지던트', '소아과', '/images/ProfileImage/박동지_박동지.png', '자리 비움'),
(17, '임정희', '830104-7024709', 'seok7975@naver.com', '010-1983-4729', '10768ad2', '1234', '레지던트', '소아과', '/images/ProfileImage/박동지_박동지.png', '자리 비움'),
(18, '홍예슬', '830104-7024710', 'seok7975@naver.com', '010-1983-4729', '10768add', '1234', '레지던트', '소아과', '/images/ProfileImage/박동지_박동지.png', '자리 비움'),
(19, '이석수', '830104-7024711', 'seok7975@naver.com', '010-1983-4729', '10768adc', '1234', '레지던트', '소아과', '/images/ProfileImage/박동지_박동지.png', '자리 비움'),
(20, '박주하', '984702-3473289', 'seok7975@naver.com', '010-3274-0327', '8108468', '1234', '전문의', '소아과', '/images/ProfileImage/박동하_박동하.PNG', '자리 비움');

use emr;