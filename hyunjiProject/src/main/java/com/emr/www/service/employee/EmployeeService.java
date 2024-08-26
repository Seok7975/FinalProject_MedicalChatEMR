package com.emr.www.service.employee;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;

import com.emr.www.entity.admin.AdminEntity;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.repository.admin.AdminRepository;
import com.emr.www.repository.doctor.DoctorRepository;
import com.emr.www.repository.nurse.NurseRepository;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.nurse.NurseService;
import com.emr.www.util.jwt.JwtTokenUtil;

@Service
public class EmployeeService {

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private NurseService nurseService;
    
	@Autowired
	private DoctorRepository doctorRepository;

	@Autowired
	private NurseRepository nurseRepository;

	@Autowired
	private AdminRepository adminRepository;

	@Autowired
	private JwtTokenUtil jwtTokenUtil;

	// 회원가입 처리
	public String registerUser(String licenseId, String password) {
		// 의사 라이센스 ID로 회원가입 처리
		Optional<DoctorEntity> doctorOpt = doctorRepository.findByLicenseId(licenseId);
		if (doctorOpt.isPresent()) {
			DoctorEntity doctor = doctorOpt.get();
			if (doctor.getPassword() != null) {
				return "이미 초기 비밀번호 설정이 완료되었습니다. 로그인을 진행해주세요.";
			}
			doctor.setPassword(password);
			doctorRepository.save(doctor);
			return "성공적으로 설정 되셨습니다. 로그인을 진행해주세요.";
		}

		Optional<NurseEntity> nurseOpt = nurseRepository.findByLicenseId(licenseId);
		if (nurseOpt.isPresent()) {
			NurseEntity nurse = nurseOpt.get();
			if (nurse.getPassword() != null) {
				return "이미 초기 비밀번호 설정이 완료되었습니다. 로그인을 진행해주세요.";
			}
			nurse.setPassword(password);
			nurseRepository.save(nurse);
			return "성공적으로 설정 되셨습니다. 로그인을 진행해주세요.";
		}

		return "승인되지 않은 ID입니다.";
	}

	// 로그인 처리 및 토큰 발행
	public String authenticateAndGenerateToken(String licenseId, String password, boolean isAdmin) {
		int userNo = 0;
		String role = null;

		if (isAdmin) {
			// 관리자 테이블 확인
			userNo = validateAdmin(licenseId, password);
			role = "ADMIN";
		}

		// 의사 테이블 확인
		if (userNo == 0) {
			userNo = validateDoctor(licenseId, password);
			if (userNo != 0) {
				role = "DOCTOR";
			}
		}

		// 간호사 테이블 확인 (직급 확인 포함)
		if (userNo == 0) {
			Map.Entry<Integer, String> nurseInfo = validateNurseAndGetRole(licenseId, password);
			if (nurseInfo != null) {
				userNo = nurseInfo.getKey();
				role = nurseInfo.getValue();
			}
		}

		//결국 로그인 한 계정이 존재하면 토큰 생성 아니면 예외 던짐 처리
		if (userNo != 0 && role != null) {
			return generateTokenForRole(userNo, role);
		} else {
			throw new IllegalArgumentException("해당 계정은 존재하지 않습니다.");
		}
	}

	// 관리자 검증 메서드 - 주키인 no값 꺼내오기
	private Integer validateAdmin(String email, String password) {
		Optional<AdminEntity> adminOpt = adminRepository.findByAdminEmailAndPassword(email, password);
		if (adminOpt.isPresent()) {
			return adminOpt.get().getNo();
		} else {
			return 0; // 관리자 계정이 유효하지 않음
		}
	}

	// 의사 검증 메서드 - 존재한다면 주키 꺼내서 값이 있으면 역할 지정
	private Integer validateDoctor(String licenseId, String password) {
		Optional<DoctorEntity> doctorOpt = doctorRepository.findByLicenseId(licenseId);
		if (doctorOpt.isPresent()) {
			DoctorEntity doctor = doctorOpt.get();
			if (doctor.getPassword() == null) {
				throw new IllegalArgumentException("회원가입을 통해 초기 비밀번호를 설정해주세요.");
			}
			if (!doctor.getPassword().equals(password)) {
				throw new IllegalArgumentException("해당 계정의 ID와 PW를 다시 확인해주세요.");
			}
			return doctor.getNo();
		} else {
			return 0; // 의사 계정이 유효하지 않음
		}
	}

	// 간호사 검증 메서드 - 간호사 존재 시 직급 반환
	private Map.Entry<Integer, String> validateNurseAndGetRole(String licenseId, String password) {
		Optional<NurseEntity> nurseOpt = nurseRepository.findByLicenseId(licenseId);
		if (nurseOpt.isPresent()) {
			NurseEntity nurse = nurseOpt.get();
			if (nurse.getPassword() == null) {
				throw new IllegalArgumentException("회원가입을 통해 초기 비밀번호를 설정해주세요.");
			}
			if (!nurse.getPassword().equals(password)) {
				throw new IllegalArgumentException("해당 계정의 ID와 PW를 다시 확인해주세요.");
			}
			String role = "H".equalsIgnoreCase(nurse.getPosition()) ? "H" : "N"; //직급을 꺼내서 비교해 역할에 지정
			return Map.entry(nurse.getNo(), role);
		}
		return null; // 간호사 계정이 유효하지 않음
	}

	// 역할에 따라 JWT 토큰을 생성하는 메서드
	private String generateTokenForRole(int userNo, String role) {
		String token = jwtTokenUtil.generateToken(userNo, role);
		System.out.println("Generated JWT Token: " + token); // 토큰 출력
		return token;
	}

	//역할에 따른 jwt 권한 설정
	public Authentication getAuthenticationFromToken(int userNo, String role) {
		// 역할(role)을 사용해 권한을 부여
		if (userNo > 0 && role != null) {
	        List<GrantedAuthority> authorities = new ArrayList<>();
	        authorities.add(new SimpleGrantedAuthority("ROLE_" + role));
	        return new UsernamePasswordAuthenticationToken(userNo, null, authorities);
	    }
	    return null; // 인증 객체가 제대로 생성되지 않으면 null을 반환함.
	}


/* -----------------------------------------------관리자----------------------------------------------------------------- */
	   
	
	 // 검색 조건에 따른 직원 목록 반환 메서드
    public List<Object> searchEmployees(String name, String job, String position) {
        List<Object> employees = new ArrayList<>();

        if ("doctor".equalsIgnoreCase(job)) {
            employees.addAll(doctorService.searchDoctors(name, position));
        } else if ("nurse".equalsIgnoreCase(job)) {
            employees.addAll(nurseService.searchNurses(name, position));
        } else {
            // 직업군이 지정되지 않은 경우, 모든 직업군 검색
            employees.addAll(doctorService.searchDoctors(name, position));
            employees.addAll(nurseService.searchNurses(name, position));
        }

        return employees;
    }

    // 직원 정보 수정 메서드, 직원 번호를 기준으로 해당 의사 또는 간호사 정보를 업데이트
    public void updateEmployee(int no, String name, String position, String phone, String email, String department, String password, String job) {
        try {
            if ("doctor".equalsIgnoreCase(job)) {
                Optional<DoctorEntity> doctorOpt = doctorRepository.findById(no);
                if (doctorOpt.isPresent()) {
                    DoctorEntity doctor = doctorOpt.get();
                    doctor.setName(name);
                    doctor.setPosition(position);
                    doctor.setPhone(phone);
                    doctor.setEmail(email);
                    doctor.setPassword(password);
                    doctor.setDepartmentId(department); 
                    doctorRepository.save(doctor);
                } else {
                    throw new RuntimeException("해당 의사가 존재하지 않습니다. (ID: " + no + ")");
                }
            } else if ("nurse".equalsIgnoreCase(job)) {
                Optional<NurseEntity> nurseOpt = nurseRepository.findById(no);
                if (nurseOpt.isPresent()) {
                    NurseEntity nurse = nurseOpt.get();
                    nurse.setName(name);
                    nurse.setPosition(position);
                    nurse.setPhone(phone);
                    nurse.setEmail(email);
                    nurse.setPassword(password);
                    nurse.setDepartmentId(department);
                    nurseRepository.save(nurse);
                } else {
                    throw new RuntimeException("해당 간호사가 존재하지 않습니다. (ID: " + no + ")");
                }
            } else {
                throw new RuntimeException("올바르지 않은 직업군입니다: " + job);
            }
        } catch (Exception e) {
            throw new RuntimeException("직원 정보 수정 중 오류 발생: " + e.getMessage(), e);
        }
    }
    
    public void checkSecurityNumDuplicate(String securityNum) {
        boolean doctorExists = doctorRepository.existsBySecurityNum(securityNum);
        boolean nurseExists = nurseRepository.existsBySecurityNum(securityNum);

        if (doctorExists || nurseExists) {
            throw new IllegalArgumentException("이미 사용 중인 주민등록번호입니다.");
        }
    }

}