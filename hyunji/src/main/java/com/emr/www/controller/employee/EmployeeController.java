package com.emr.www.controller.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.emr.www.controller.employee.exception.LicenseKeyNotFoundException;
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

	// 회원가입 POST 요청 처리
	@PostMapping("/signup")
	public ResponseEntity<String> handleSignup(@RequestParam String licenseId, @RequestParam String password) {
		try {
			// 사용자 등록 처리
			employeeService.registerUser(licenseId, password);
			return ResponseEntity.ok("초기 비밀번호 설정이 완료되었습니다.");
		} catch (LicenseKeyNotFoundException e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("승인되지 않은 ID입니다.");
		} catch (IllegalStateException e) {
			return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("비밀번호 설정에 실패했습니다.");
		}
	}

	//로그인 post 요청 처리 
	@PostMapping("/Login")
	public String Login(@RequestParam String licenseId, @RequestParam String password, @RequestParam(required = false) boolean isAdmin, Model model) {
		String userType;

		if (isAdmin) {
			userType = employeeService.validateAdmin(licenseId, password); // 관리자 검증 로직
		} else {
			userType = employeeService.validateUser(licenseId, password); // 의사와 간호사 검증 로직
		}

		// 비밀번호가 설정되지 않은 경우
		if ("password_not_set".equals(userType)) {
			return "redirect:/loginMain?passwordNotSet=true"; // URL 파라미터 추가
		}

		System.out.println("반환된 타입 : " + userType);
		if ("doctor".equals(userType)) {
			return "redirect:/doctor/main"; // 의사 메인 페이지로 이동
		} else if ("nurse".equals(userType)) {
			return "redirect:/nurse/main"; // 간호사 메인 페이지로 이동
		} else if ("head_nurse".equals(userType)) {
	        return "redirect:/headNurse/headNurseMain";  // 수간호사 메인 페이지로 이동
		}else if ("admin".equals(userType)) {
			return "redirect:/admin/main"; //관리자 메인 페이지로 이동
		}
		// 로그인 실패 시 파라미터로 전달
		return "redirect:/loginMain?loginError=true";
	}
}
