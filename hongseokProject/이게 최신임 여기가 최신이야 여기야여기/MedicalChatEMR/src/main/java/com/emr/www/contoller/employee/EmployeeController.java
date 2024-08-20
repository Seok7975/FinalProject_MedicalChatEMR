package com.emr.www.contoller.employee;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.service.employee.EmployeeService;

@Controller
public class EmployeeController {

	@Autowired
	public EmployeeService employeeService;

	// 직원 검색 메서드
	@GetMapping("/searchEmployees")
    @ResponseBody
    public List<Map<String, Object>> searchEmployees(@RequestParam(required = false) String name,
                                        @RequestParam(required = false) String job,
                                        @RequestParam(required = false) String position) {
        // 검색 조건에 따라 직원 리스트를 반환합니다.
List<Object> employees = employeeService.searchEmployees(name, job, position);
        
        return employees.stream().map(employee -> {
            Map<String, Object> map = new HashMap<>();
            if (employee instanceof DoctorEntity) {
                DoctorEntity doctor = (DoctorEntity) employee;
                map.put("no", doctor.getNo());
                map.put("name", doctor.getName());
                map.put("position", doctor.getPosition());
                map.put("job", "doctor");
                map.put("securityNum", doctor.getSecurityNum());
                map.put("email", doctor.getEmail());
                map.put("phone", doctor.getPhone());
                map.put("licenseId", doctor.getLicenseId());
                map.put("password", doctor.getPassword());
                map.put("departmentId", doctor.getDepartmentId());
                map.put("activeStatus", doctor.getActiveStatus());
            } else if (employee instanceof NurseEntity) {
                NurseEntity nurse = (NurseEntity) employee;
                map.put("no", nurse.getNo());
                map.put("name", nurse.getName());
                map.put("position", nurse.getPosition());
                map.put("job", "nurse");
                map.put("securityNum", nurse.getSecurityNum());
                map.put("email", nurse.getEmail());
                map.put("phone", nurse.getPhone());
                map.put("licenseId", nurse.getLicenseId());
                map.put("password", nurse.getPassword());
                map.put("departmentId", nurse.getDepartmentId());
                map.put("activeStatus", nurse.getActiveStatus());
            }
            return map;
        }).collect(Collectors.toList());
    }

	// 모든 직원 목록 가져오기
	@GetMapping("/getEmployees")
	@ResponseBody
	public List<Object> getEmployees() {
		// 전체 직원 목록을 반환합니다.
		return employeeService.searchEmployees(null, null, null);
	}

	// 직원 정보 수정 메서드
	@PostMapping("/updateEmployee")
	@ResponseBody
	public ResponseEntity<String> updateEmployee(@RequestParam int no, @RequestParam String name,
			@RequestParam String position, @RequestParam String phone, @RequestParam String email,
			@RequestParam String password, @RequestParam(required = false) String department,
			@RequestParam(required = false) String job) {
		try {
			// 직원 정보를 업데이트합니다. job 파라미터로 직업군을 전달합니다.
			employeeService.updateEmployee(no, name, position, phone, email, department, password, job);
			return ResponseEntity.ok("수정이 완료되었습니다.");
		} catch (Exception e) {
			// 업데이트 중 오류 발생 시 오류 메시지 반환
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("수정 중 오류가 발생했습니다.");
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
