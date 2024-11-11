-- patient-- 환자 등록 테이블
CREATE TABLE RegisterPatients (
    idNo INT AUTO_INCREMENT PRIMARY KEY, -- 환자의 고유 식별자입니다.
    name VARCHAR(50), -- 환자의 이름입니다.
    securityNum VARCHAR(14) UNIQUE, -- 주민등록번호입니다.
    gender CHAR(1), -- 성별 ('M' 또는 'F').
    address VARCHAR(255), -- 주소입니다
    phone VARCHAR(20), -- 전화번호입니다.
    email VARCHAR(50), -- 이메일 주registerpatients소입니다.
    bloodType VARCHAR(6), -- 혈액형입니다. // 예외처리 추가
    height DECIMAL(5.1), -- 키(센티미터)입니다.
    weight DECIMAL(5.1), -- 체중(킬로그램)입니다.
    allergies TEXT, -- 알레르기 정보입니다.
    bloodPressure VARCHAR(10), -- 혈압 120/80 (mmHg)
    temperature DECIMAL(4, 1), -- 체온 -9.9 ~ 99.9 (도씨)
    smokingStatus CHAR(1) -- 흡연 여부 ('Y' 또는 'N'). // 예외처리 추가
);

use emr;

INSERT INTO registerpatients (idNo, name, securityNum, gender, address, phone, email, bloodType, height, weight, allergies, bloodPressure, temperature, smokingStatus)
VALUES
(1, '박홍석', '941104-1079512', 'M', '61763 광주 남구 판촌길 23-3 123동 102호', '010-1234-5678', 'seok@naver.com', '(-)B', 180, 75, NULL, '120/80', 36.5, 'N'),
(2, '임준혁', '970710-1018215', 'M', '61763 광주 남구 판촌길 23-3 123동 102호', '010-4431-5571', 'seok@naver.com', '(-)B', 180, 80, NULL, '120/79', 36.5, 'N'),
(3, '정민석', '971212-1078121', 'M', '06035 서울 강남구 가로수길 5 102-205', '010-2523-2213', 'zee@hanmail.net', '(-)B', 172, 66, 'x', '123/80', 37.0, 'N'),
(4, '고욱재', '910708-1120431', 'M', '05846 서울 송파구 위례북로 10 502-206', '010-2345-6789', 'jae@daum.net', '(+)A', 180, 70, 'INFP', '130/90', 36.0, 'Y'),
(5, '고욱진', '900708-1053761', 'M', '05846 서울 송파구 위례북로 10 105-321', '010-4567-8975', 'wook@gmail.com', '(-)A', 180.2, 70.54, 'INFP', '125/80', 36.0, 'Y'),
(6, '정현지(1)', '011030-4249539', 'F', '13442 경기 성남시 수정구 분당내곡로 744 203동 105호', '010-4567-7894', 'jibug@gmail.com', '(-)O', 165, 45, 'ISTP', NULL, NULL, 'Y'),
(7, '정현지(2)', '021020-4214525', 'F', '56443 전북특별자치도 고창군 고창읍 도산리 586-3 108호', '010-4567-8912', 'ssogary@naver.com', '(+)B', 172, 60, NULL, NULL, NULL, 'Y'),
(8, '현지수', '041212-4102347', 'F', '02825 서울 성북구 돈암동 603-1 501-152', '010-2555-2323', 'jisoo@naver.com', '(+)AB', 170, 59, NULL, NULL, NULL, 'Y');