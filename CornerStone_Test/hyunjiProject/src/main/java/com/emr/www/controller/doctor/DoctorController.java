package com.emr.www.controller.doctor;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

	@GetMapping("/main")
	public String showDoctorMainPage() {
		return "doctor/doctorMain"; // "WEB-INF/views/doctor/DoctorMain.jsp"를 의미
	}
	
}