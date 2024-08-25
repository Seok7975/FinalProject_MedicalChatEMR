package com.emr.www.util.headnurse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.emr.www.service.patient.PatientService;

public class SecurityNumValidator {
	
	private static final Logger log = LoggerFactory.getLogger(PatientService.class);
	
    public static boolean isValid(String securityNum) {
    	
    	
        // 주민등록번호 형식: 6자리 숫자 + '-' + 7자리 숫자
        if (securityNum == null || !securityNum.matches("\\d{6}-\\d{7}")) {
            log.debug("형식이 잘못되었거나 null인 주민등록번호 : {}\n", securityNum);
            return false;
        }

        // 주민등록번호에서 '-'를 제거한 숫자만 추출
        String number = securityNum.replace("-", "");
        
        if (number.length() != 13) {
        	log.debug("주민등록번호 길이가 잘못되었습니다 : {}\n", number);
            return false;
        }

        // 유효성 검사 알고리즘 (Luhn 알고리즘에 기반한 주민등록번호 검사법 사용)
        int[] weights = {2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5};
        int sum = 0;

        // 첫 12자리의 숫자에 가중치를 곱한 후 합산
        for (int i = 0; i < 12; i++) {
            sum += Character.getNumericValue(number.charAt(i)) * weights[i];
        }

        // 11로 나눈 나머지를 구하여 11에서 빼고, 이를 10으로 나눈 나머지가 마지막 자리와 같으면 유효
        int checkDigit = (11 - (sum % 11)) % 10;
        
        System.out.printf("checkDigit : %d, 마지막수 : %d\n", checkDigit, Character.getNumericValue(number.charAt(12)));
        	
        return checkDigit == Character.getNumericValue(number.charAt(12));
    }
}