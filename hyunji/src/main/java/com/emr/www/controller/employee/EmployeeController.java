package com.emr.www.controller.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.emr.www.service.employee.EmployeeService;

@Controller
public class EmployeeController {

	@Autowired
	private EmployeeService employeeService;

	//로그인 메인 화면 매핑
	@GetMapping("/loginMain")
	public String showLoginPage() {
		return "/login/LoginMain";
	}

	//로그인 회원 가입 페이지
	@GetMapping("/registration_form")
	public String showRegistrationForm() {
		return "/login/registration_form"; // src/main/webapp/WEB-INF/views/login/registration_form.jsp 로 렌더링
	}

	//비밀번호 찾기 페이지
	@GetMapping("/findPassword")
	public String showFindPasswordForm() {
		return "/login/findPassword"; // src/main/webapp/WEB-INF/views/login/findPassword.jsp 로 렌더링
	}

	//회원가입 post 요청 처리
	@PostMapping("/signup")
	public ResponseEntity<String> handleSignup(@RequestParam String licenseId, 
            @RequestParam String password, Model model) {

		
		// 사용자 등록 처리
		try {
			employeeService.registerUser(licenseId, password);
			// 성공적으로 완료되면 200 OK 응답 반환
			return ResponseEntity.ok("회원가입이 성공적으로 완료 되었습니다.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("User registration failed");
		}
	}

	//로그인 post 요청 처리 
	@PostMapping("/Login")
	public String Login(@RequestParam String licenseId, @RequestParam String password, Model model) {
		String userType = employeeService.validateUser(licenseId, password);

		System.out.println("반환된 타입 : " + userType);
		if ("doctor".equals(userType)) {
			return "redirect:/doctor/main"; // 의사 메인 페이지로 이동
		} else if ("nurse".equals(userType)) {
			return "redirect:/nurse/main"; // 간호사 메인 페이지로 이동
		} else if ("admin".equals(userType)) {
			return "redirect:/admin/main"; //관리자 메인 페이지로 이동
		}
		// 로그인 실패 시 에러 메시지를 클라이언트에 전달
        model.addAttribute("loginError", true);
        return "login/LoginMain"; // 로그인 실패 시 다시 로그인 페이지로 이동
	}
}
