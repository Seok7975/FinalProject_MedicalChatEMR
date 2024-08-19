package com.emr.www.controller.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.nurse.NurseRepository;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.employee.EmployeeService;
import com.emr.www.service.nurse.NurseService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {

	@Autowired
	public EmployeeService employeeService;

	@Autowired
	public DoctorRepository doctorRepository;
	@Autowired
	public NurseRepository nurseRepository;
	
	@Autowired
	private DoctorService doctorService; // 주입된 클래스 이름이 소문자로 시작해야 함

	@Autowired
	private NurseService nurseService;  // 주입된 클래스 이름이 소문자로 시작해야 함

	@GetMapping("/searchEmployees")
    public List<Object> searchEmployees(@RequestParam(required = false) String name,
                                   @RequestParam(required = false) String job,
                                   @RequestParam(required = false) String position) {
        List<Object> employees = new ArrayList<>();

        if ("doctor".equalsIgnoreCase(job)) {
            employees.addAll(doctorService.searchDoctors(name, position));
        } else if ("nurse".equalsIgnoreCase(job)) {
            employees.addAll(nurseService.searchNurses(name, position));
        } else {
            // "전체" 또는 공백인 경우 의사와 간호사 모두 검색
            employees.addAll(doctorService.searchDoctors(name, position));
            employees.addAll(nurseService.searchNurses(name, position));
        }

        return employees;
    }


    @GetMapping("/getEmployees")
    @ResponseBody
    public List<Object> getEmployees() {
        // 모든 의사와 간호사를 가져옵니다.
        return employeeService.searchEmployees(null, null, null);
    }

    @PostMapping("/updateEmployee")
    @ResponseBody
    public ResponseEntity<String> updateEmployee(@RequestParam Long employeeNo,
                                                 @RequestParam String name,
                                                 @RequestParam String position,
                                                 @RequestParam String phone,
                                                 @RequestParam String email,
                                                 @RequestParam String password,
                                                 @RequestParam(required = false) String department,
                                                 @RequestParam(required = false) String role) {
        try {
            employeeService.updateEmployee(employeeNo, name, position, phone, email, department, password);
            return ResponseEntity.ok("수정이 완료되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("수정 중 오류가 발생했습니다.");
        }
    }

	@PostMapping("/checkDuplicateSSN")
	public ResponseEntity<Map<String, Boolean>> checkDuplicateSSN(@RequestBody Map<String, String> request) {
		String ssn = request.get("ssn");

		// EmployeeService를 통해 중복 체크 수행
		try {
			employeeService.checkSecurityNumDuplicate(ssn);
			// 중복이 없으면 false 반환
			Map<String, Boolean> response = new HashMap<>();
			response.put("duplicate", false);
			return ResponseEntity.ok(response);
		} catch (IllegalArgumentException e) {
			// 중복이 있을 경우 true 반환
			Map<String, Boolean> response = new HashMap<>();
			response.put("duplicate", true);
			return ResponseEntity.ok(response);
		}
	}
}
