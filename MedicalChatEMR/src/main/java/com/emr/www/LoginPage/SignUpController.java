package com.emr.www.LoginPage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SignUpController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/signup")
    public String handleSignup(
            @RequestParam("license-part1") String licensePart1,
            @RequestParam("license-part2") String licensePart2,
            @RequestParam("license-part3") String licensePart3,
            @RequestParam("password") String password,
            Model model) {

        String licenseKey = licensePart1 + "-" + licensePart2 + "-" + licensePart3;
        
        String JoinTables = "SELECT " +
        	    "d.license_id, " + 
        	    "d.email, " +       
        	    "d.password, " +   
        	    "n.license_id AS nurse_license_id, " + 
        	    "n.email AS nurse_email, " +          
        	    "n.password AS nurse_password " +   
        	"FROM " +
        	    "Doctor d " +
        	"LEFT JOIN Nurse n ON d.license_id = n.license_id AND d.email = n.email AND d.password = n.password " +
        	"WHERE " +
        	    "d.license_id IS NOT NULL " +
        	    "AND d.email IS NOT NULL " +
        	    "AND d.password IS NOT NULL " +
        	"UNION " +
        	"SELECT " +
        	    "n.license_id, " + 
        	    "n.email, " +    
        	    "n.password, " +   
        	    "d.license_id AS doctor_license_id, " +
        	    "d.email AS doctor_email, " +         
        	    "d.password AS doctor_password " +    
        	"FROM " +
        	    "Nurse n " +
        	"LEFT JOIN Doctor d ON n.license_id = d.license_id AND n.email = d.email AND n.password = d.password " +
        	"WHERE " +
        	    "n.license_id IS NOT NULL " +
        	    "AND n.email IS NOT NULL " +
        	    "AND n.password IS NOT NULL;";

        
        String viewEmail = "SELECT email FROM Doctor WHERE license_id = ? " +
                "UNION " +
                "SELECT email FROM Nurse WHERE license_id = ?";


        // SQL 쿼리 (이메일 및 비밀번호 조회)
        String selectSql = "SELECT d.license_id, d.email, d.password " +
                           "FROM Doctor d " +
                           "WHERE d.license_id = ? " +
                           "UNION " +
                           "SELECT n.license_id, n.email, n.password " +
                           "FROM Nurse n " +
                           "WHERE n.license_id = ?";

        try {
         String email = jdbcTemplate.queryForObject(viewEmail, new Object[]{licenseKey, licenseKey}, String.class);
            // 이메일과 비밀번호 조회
            var result = jdbcTemplate.queryForList(selectSql, new Object[]{licenseKey, licenseKey});
            if (result.isEmpty()) {
                throw new LicenseKeyNotFoundException("License Key doesn't exist: " + licenseKey);
            }

            // 비밀번호 업데이트
            String updateDoctorSql = "UPDATE Doctor SET password = ? WHERE license_id = ?";
            String updateNurseSql = "UPDATE Nurse SET password = ? WHERE license_id = ?";

            // 의사 테이블 비밀번호 업데이트
            jdbcTemplate.update(updateDoctorSql, password, licenseKey);

            // 간호사 테이블 비밀번호 업데이트
            jdbcTemplate.update(updateNurseSql, password, licenseKey);

            // 파라미터를 Model에 추가
            model.addAttribute("licenseKey", licenseKey);
            model.addAttribute("email",email);
            model.addAttribute("password", password);

            // 성공 후 뷰 이름 반환
            return "/login/registration-success";
        } catch (EmptyResultDataAccessException ex) {
            throw new LicenseKeyNotFoundException("License Key doesn't exist: " + licenseKey);
        }
    }
}
