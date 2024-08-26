package com.emr.www.controller.nurse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/nurse")
public class NurseController {

	@GetMapping("/main")
	public String showNurseMainPage() {
		return "nurse/nurseMain"; // "WEB-INF/views/nurse/NurseMain.jsp"를 의미
	}
}