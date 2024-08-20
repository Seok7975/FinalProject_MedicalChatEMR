package com.emr.www.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

//	@GetMapping("/doctor/main")
//	public String showDoctorMainPage() {
//		return "doctor/DoctorMain"; // "WEB-INF/views/doctor/DoctorMain.jsp"를 의미
//	}
	
//	@GetMapping("/nurse/main")
//	public String showNurseMainPage() {
//		return "nurse/NurseMain"; // "WEB-INF/views/nurse/NurseMain.jsp"를 의미
//	}
	
	@GetMapping("/main")
	public String showAdminMainPage() {
		return "admin/adminMain"; // "WEB-INF/views/admin/AdminMain.jsp"를 의미
	}
	
	//병원장 페이지에서 동적으로 메인 보드에 기능 페이지 로드
		//직원 생성 페이지
	 @GetMapping("/employeeCreate")
	    public String showEmployeeCreatePage() {
	        return "admin/employeeCreate"; // "WEB-INF/views/admin/employeeCreate.jsp"를 의미
	    }
	 //직원 조회/수정/퇴사 페이지
	 @GetMapping("/employeeView")
	 public String showEmployeeEditePage() {
		 return "admin/employeeView";  // "WEB-INF/views/admin/employeeView.jsp"를 의미
	 }
	 
}