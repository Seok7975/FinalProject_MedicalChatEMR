package com.emr.www.controller.doctor;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.emr.www.dto.doctor.DoctorDTO;
import com.emr.www.service.doctor.DoctorService;
import com.emr.www.service.mail.MailService;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

    // 로깅을 위한 Logger 생성
    private static final Logger logger = LoggerFactory.getLogger(DoctorController.class);

    // DoctorService를 사용하기 위해 Autowired로 의존성 주입
    @Autowired
    private DoctorService doctorService;
    
    @Autowired
    private MailService  mailService;

    // 파일이 저장될 경로를 설정
    private final String uploadPath = new File("src/main/resources/static/images/ProfileImage").getAbsolutePath();

    
	@GetMapping("/main")
	public String showDoctorMainPage() {
		return "doctor/doctorMain"; // "WEB-INF/views/doctor/DoctorMain.jsp"를 의미
	}
	
    // 의사 정보를 생성하기 위한 POST 요청 처리 메서드
    @PostMapping("/doctorCreate")
    @ResponseBody
    public ResponseEntity<String> createDoctor(@ModelAttribute DoctorDTO doctorDto,
                                               @RequestParam MultipartFile photo) {
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
                    String text = "안녕하세요, " + doctorDto.getName() + "님.\n\n귀하의 정보가 성공적으로 등록되었습니다.\n"
                                  + "귀하의 ID는 다음과 같습니다: " + licenseId;

                    mailService.sendEmail(to, subject, text);
                } catch (Exception e) {
                    logger.error("이메일 발송 중 오류 발생: ", e);
                    return new ResponseEntity<>("의사 정보는 생성되었으나, 이메일 발송 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
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
}