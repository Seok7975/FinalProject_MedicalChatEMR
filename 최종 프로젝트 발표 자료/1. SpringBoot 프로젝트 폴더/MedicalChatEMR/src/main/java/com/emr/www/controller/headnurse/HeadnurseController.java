package com.emr.www.controller.headnurse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/headNurse") // 이 컨트롤러의 모든 메서드는 /headnurse로 시작하는 URL에 매핑(우리가 url을 입력하는것과 관련)
public class HeadnurseController {
	
//    @Autowired
//    private PatientService patientService;
//
//    @Autowired
//    private PatientRepository patientRepository;
    
//    private static final Logger log = LoggerFactory.getLogger(PatientService.class);
	
	// 메인 화면
	@GetMapping("/main") // 이 메서드는 GET /headnurse/main 요청을 처리합니다.(우리가 url을 입력하는것과 관련)
	public String headNurseMain(Model model) {
		System.out.println("headNurseMain method called");
		return "headNurse/headNurseMain"; 
		// 뷰의 이름을 반환, 뷰 리졸버는 이 이름을 사용하여 실제 뷰 파일(예: view/headnurse/headNurseMain.jsp)을 찾습니다.
	}
	
	
}