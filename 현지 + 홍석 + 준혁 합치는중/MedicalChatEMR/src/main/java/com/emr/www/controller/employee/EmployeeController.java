package com.emr.www.controller.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.nurse.NurseRepository;
import com.emr.www.service.employee.EmployeeService;
import com.emr.www.util.jwt.JwtTokenUtil;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class EmployeeController {

	@Autowired
	private EmployeeService employeeService;

	@Autowired
	public DoctorRepository doctorRepository;

	@Autowired
	public NurseRepository nurseRepository;

	@Autowired
	private JwtTokenUtil jwtTokenUtil; // JWT 토큰 유틸리티 클래스 주입

	//로그인 메인 페이지
	@GetMapping("/loginMain")
	public String showLoginPage(@RequestParam(required = false) String sessionExpired, Model model, HttpServletResponse response) {
		return "login/loginMain"; // 로그인 페이지로 이동
	}

	//로그인 회원 가입 페이지
	@GetMapping("/registration_form")
	public String showRegistrationForm() {
		return "login/registration_form"; // src/main/webapp/WEB-INF/views/login/registration_form.jsp 로 렌더링
	}

	// 회원가입 처리
	@PostMapping("/signup")
	public String handleSignup(@RequestParam String licenseId, @RequestParam String password, RedirectAttributes redirectAttributes) {
		String result = employeeService.registerUser(licenseId, password);
		redirectAttributes.addFlashAttribute("message", result);
		return "redirect:/registration_form"; // 회원가입 창으로 돌아감 (등록 완료 후 닫힘 처리)
	}

	// 로그인 처리
	@PostMapping("/Login")
	public String login(@RequestParam String licenseId, @RequestParam String password, @RequestParam(required = false) boolean isAdmin,
			RedirectAttributes redirectAttributes, HttpServletResponse response) {

		try {
			// 데이터베이스 사용자 인증 및 토큰 생성
			String token = employeeService.authenticateAndGenerateToken(licenseId, password, isAdmin);

			System.out.println("Employee Controller에서 토큰 생성 받음 : " + token);
			
			// JWT 토큰을 쿠키에 저장 (12시간 유지)
			Cookie jwtCookie = new Cookie("jwtToken", token);
			jwtCookie.setHttpOnly(true); // 클라이언트 자바스크립트에서 접근 가능
			jwtCookie.setSecure(false); // 개발 환경에서는 false, 배포 시 true (HTTPS 필요)
			jwtCookie.setPath("/"); //모든 경로에 대해 쿠키 전송 가능
			jwtCookie.setMaxAge(12 * 60 * 60); // 12시간 유지
			response.addCookie(jwtCookie);

			// 토큰에서 역할을 추출하여 해당 페이지로 리디렉션
			String role = jwtTokenUtil.extractRole(token);
			return getRedirectPathByRole(role);

		} catch (IllegalArgumentException e) {
			// 예외 발생 시 로그인 페이지로 리다이렉트하고 에러 메시지를 추가
			redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
			return "redirect:/loginMain";
		} catch (Exception e) {
			// 예기치 못한 역할에 대한 처리
			redirectAttributes.addFlashAttribute("errorMessage", "로그인에 실패했습니다. 병원장에게 문의해주세요.");
			return "redirect:/loginMain";
		}
	}

	// 역할에 따라 리디렉션할 경로 반환
	private String getRedirectPathByRole(String role) {
		switch (role) {
			case "ADMIN" :
				return "redirect:/admin/main"; //관리자 메인 페이지

			case "DOCTOR" :
				return "redirect:/doctor/main"; //의사 메인 페이지

			case "H" :
				return "redirect:/headNurse/main"; //수간호사 메인 페이지

			case "N" :
				return "redirect:/nurse/main"; //간호사 메인 페이지

			default :
				return "redirect:/loginMain"; // 유효하지 않은 역할일 경우 로그인 페이지로 리디렉트
		}
	}

	//비활동 30분 로그아웃 - jwt 토큰을 쿠키에서 삭제하면서 진행
	@PostMapping("/inactivity-logout")
	public void inactivityLogout(HttpServletResponse response) {
		// JWT 쿠키 삭제
		Cookie jwtCookie = new Cookie("jwtToken", null);
		jwtCookie.setMaxAge(0);
		jwtCookie.setPath("/");
		response.addCookie(jwtCookie);

		// 서버는 쿠키만 삭제하고, 클라이언트가 로그인 페이지로 리디렉트하도록 처리
		response.setStatus(HttpServletResponse.SC_OK);
	}
}
