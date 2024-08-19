package com.emr.www.controller.nurse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.emr.www.entity.nurse.dto.NurseDto;
import com.emr.www.service.mail.MailService;
import com.emr.www.service.nurse.NurseService;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
public class NurseController {

    // 로깅을 위한 Logger 생성
    private static final Logger logger = LoggerFactory.getLogger(NurseController.class);

    // NurseService를 사용하기 위해 Autowired로 의존성 주입
    @Autowired
    private NurseService nurseService;
    
    @Autowired
    private MailService mailService;

    // 파일이 저장될 경로를 설정
    private final String uploadPath = new File("src/main/resources/static/images/ProfileImage").getAbsolutePath();

    // 간호사 정보를 생성하기 위한 POST 요청 처리 메서드
    @PostMapping("/nurseCreate")
    @ResponseBody
    public ResponseEntity<String> createNurse(@ModelAttribute NurseDto nurseDto,
                                              @RequestParam MultipartFile photo) {
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
                    String text = "안녕하세요, " + nurseDto.getName() + "님.\n\n귀하의 정보가 성공적으로 등록되었습니다.\n"
                                  + "귀하의 면허 번호는 다음과 같습니다: " + licenseId;

                    mailService.sendEmail(to, subject, text);
                } catch (Exception e) {
                    logger.error("이메일 발송 중 오류 발생: ", e);
                    return new ResponseEntity<>("간호사 정보는 생성되었으나, 이메일 발송 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
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
}