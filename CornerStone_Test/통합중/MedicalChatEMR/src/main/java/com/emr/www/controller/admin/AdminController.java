package com.emr.www.controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.emr.www.dto.doctor.DoctorDTO;
import com.emr.www.dto.nurse.NurseDTO;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.service.admin.AdminService;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.mail.MailService;
import com.emr.www.service.nurse.NurseService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	public DoctorService doctorService;

	@Autowired
	public MailService mailService;

	@Autowired
	public AdminService adminService;

	@Autowired
	public NurseService nurseService;

	// 로깅을 위한 Logger 생성
	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

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
		return "admin/employeeView"; // "WEB-INF/views/admin/employeeView.jsp"를 의미
	}
	
	// 진료 조회 페이지
		@GetMapping("/medicalView")
		public String showmedicalViewPage() {
			return "admin/medicalView"; // "WEB-INF/views/admin/medicalView.jsp"를 의미
		}

		// 파일이 저장될 경로를 설정
		private final String uploadPath = new File("src/main/resources/static/images/ProfileImage").getAbsolutePath();

		@PostMapping("/doctorCreate")
		@ResponseBody
		public ResponseEntity<String> createDoctor(@ModelAttribute DoctorDTO doctorDto, @RequestParam MultipartFile photo) {
			try {
				if (!photo.isEmpty()) {
					String licenseId = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
					doctorDto.setLicenseId(licenseId);
					String fileName = doctorDto.getName() + "_" + photo.getOriginalFilename();
					Path path = Paths.get(uploadPath + File.separator + fileName);

					if (Files.notExists(path.getParent())) {
						Files.createDirectories(path.getParent());
					}

					photo.transferTo(path.toFile());
					doctorDto.setProfileImage("/images/ProfileImage/" + fileName);

					// DTO 객체를 서비스 계층에 전달하여 의사 정보 저장 시도
					doctorService.createDoctor(doctorDto);

					// 이메일 발송
					try {
						String to = doctorDto.getEmail();
						String subject = "직원 등록 완료 안내";
						String text = "안녕하세요, " + doctorDto.getName() + doctorDto.getPosition() +"님.\n\n귀하의 정보가 성공적으로 등록되었습니다.\n"
								+ "귀하의 면허번호는 다음과 같습니다: " + licenseId;

						mailService.sendEmail(to, subject, text);
					} catch (Exception e) {
						logger.error("이메일 발송 중 오류 발생: ", e);
						return new ResponseEntity<>("의사 정보는 생성되었으나, 이메일 발송 중 오류가 발생했습니다.",
								HttpStatus.INTERNAL_SERVER_ERROR);
					}

					return new ResponseEntity<>("의사 정보가 성공적으로 생성되었고, 이메일이 발송되었습니다!", HttpStatus.OK);
				} else {
					return new ResponseEntity<>("사진이 업로드되지 않았습니다.", HttpStatus.BAD_REQUEST);
				}
			} catch (IllegalArgumentException e) {
				// IllegalArgumentException을 명확하게 처리
				logger.error("의사 생성 중 오류 발생: ", e);
				return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
			} catch (IOException e) {
				logger.error("사진 저장 중 오류 발생: ", e);
				return new ResponseEntity<>("사진 저장 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
			} catch (Exception e) {
				logger.error("의사 생성 중 오류 발생: ", e);
				return new ResponseEntity<>("의사 생성 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		// 간호사 정보를 생성하기 위한 POST 요청 처리 메서드
		@PostMapping("/nurseCreate")
		@ResponseBody
		public ResponseEntity<String> createNurse(@ModelAttribute NurseDTO nurseDto, @RequestParam MultipartFile photo) {
			try {
				// UUID를 사용해 8자리 랜덤 면허 번호 생성
				String licenseId = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
				nurseDto.setLicenseId(licenseId);

				if (!photo.isEmpty()) {
					String fileName = nurseDto.getName() + "_" + photo.getOriginalFilename();
					Path path = Paths.get(uploadPath + File.separator + fileName);

					if (Files.notExists(path.getParent())) {
						Files.createDirectories(path.getParent());
					}

					photo.transferTo(path.toFile());
					nurseDto.setProfileImage("/images/ProfileImage/" + fileName);

					// DTO 객체를 서비스 계층에 전달하여 간호사 정보 저장 시도
					nurseService.createNurse(nurseDto);

					// 이메일 발송
					try {
						String to = nurseDto.getEmail();
						String subject = "직원 등록 완료 안내";
						String text = "안녕하세요, " + nurseDto.getName() + nurseDto.getPosition() +"님.\n\n귀하의 정보가 성공적으로 등록되었습니다.\n"
								+ "귀하의 면허 번호는 다음과 같습니다: " + licenseId;

						mailService.sendEmail(to, subject, text);
					} catch (Exception e) {
						logger.error("이메일 발송 중 오류 발생: ", e);
						return new ResponseEntity<>("간호사 정보는 생성되었으나, 이메일 발송 중 오류가 발생했습니다.",
								HttpStatus.INTERNAL_SERVER_ERROR);
					}

					return new ResponseEntity<>("간호사 정보가 성공적으로 생성되었고, 이메일이 발송되었습니다!", HttpStatus.OK);
				} else {
					return new ResponseEntity<>("사진이 업로드되지 않았습니다.", HttpStatus.BAD_REQUEST);
				}
			} catch (IllegalArgumentException e) {
				// IllegalArgumentException을 명확하게 처리
				logger.error("간호사 생성 중 오류 발생: ", e);
				return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
			} catch (IOException e) {
				logger.error("사진 저장 중 오류 발생: ", e);
				return new ResponseEntity<>("사진 저장 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
			} catch (Exception e) {
				logger.error("간호사 생성 중 오류 발생: ", e);
				return new ResponseEntity<>("간호사 생성 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		// 직원 검색 메서드
		@GetMapping("/searchEmployees")
		@ResponseBody
		public List<Map<String, Object>> searchEmployees(@RequestParam(required = false) String name, @RequestParam(required = false) String job,
				@RequestParam(required = false) String position) {
			// 검색 조건에 따라 직원 리스트를 반환합니다.
			List<Object> employees = adminService.searchEmployees(name, job, position);

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
			return adminService.searchEmployees(null, null, null);
		}

		// 직원 정보 수정 메서드
		@PostMapping("/updateEmployee")
		@ResponseBody
		public ResponseEntity<String> updateEmployee(@RequestParam int no, @RequestParam String name, @RequestParam String position,
				@RequestParam String phone, @RequestParam String email, @RequestParam String password, @RequestParam(required = false) String department,
				@RequestParam(required = false) String job) {
			try {
				// 직원 정보를 업데이트합니다. job 파라미터로 직업군을 전달합니다.
				adminService.updateEmployee(no, name, position, phone, email, department, password, job);
				return ResponseEntity.ok("수정이 완료되었습니다.");
			} catch (Exception e) {
				// 업데이트 중 오류 발생 시 오류 메시지 반환
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("수정 중 오류가 발생했습니다.");
			}
		}

		//주민번호 중복체크
		@PostMapping("/checkDuplicateSSN")
		public ResponseEntity<Map<String, Boolean>> checkDuplicateSSN(@RequestBody Map<String, String> request) {
			String ssn = request.get("ssn");

			// EmployeeService를 통해 중복 체크 수행
			try {
				adminService.checkSecurityNumDuplicate(ssn);
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