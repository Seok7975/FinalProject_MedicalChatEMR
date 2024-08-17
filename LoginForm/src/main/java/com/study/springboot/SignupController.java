package com.study.springboot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SignupController {

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

        // SQL 쿼리
         String sql = "INSERT INTO Doctor (email, password) VALUES (?, ?)";
         
         


        // 데이터 삽입
        jdbcTemplate.update(sql, licenseKey, password);

        // 파라미터를 Model에 추가
        model.addAttribute("licenseKey", licenseKey);
        model.addAttribute("password", password);


        // 성공 후 뷰 이름 반환
        return "registration-success";
    }
}
