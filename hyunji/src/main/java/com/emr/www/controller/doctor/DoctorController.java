package com.emr.www.controller.doctor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.emr.www.entity.doctor.dto.DoctorDto;
import com.emr.www.service.doctor.DoctorService;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class DoctorController {

    // 로깅을 위한 Logger 생성
    private static final Logger logger = LoggerFactory.getLogger(DoctorController.class);

    // DoctorService를 사용하기 위해 Autowired로 의존성 주입
    @Autowired
    private DoctorService doctorService;

    // 파일이 저장될 경로를 설정
    private final String uploadPath = new File("src/main/resources/static/images/ProfileImage").getAbsolutePath();

    // 의사 정보를 생성하기 위한 POST 요청 처리 메서드
    @PostMapping("/doctorCreate")
    @ResponseBody
    public String createDoctor(@ModelAttribute DoctorDto doctorDto,  // 폼 데이터의 바인딩
                               @RequestParam("photo") MultipartFile photo) {
        
        try {

            // 정보가 성공적으로 저장된 후에만 이미지 파일을 저장
            if (!photo.isEmpty()) {
                // 파일 이름에 의사 이름을 포함시키기
                String fileName = doctorDto.getName() + "_" + photo.getOriginalFilename();
                // 파일을 저장할 경로 설정
                Path path = Paths.get(uploadPath + File.separator + fileName);

                // 디렉토리가 존재하지 않으면 생성
                if (Files.notExists(path.getParent())) {
                    Files.createDirectories(path.getParent());
                }

                // 실제 파일을 지정된 경로에 저장
                photo.transferTo(path.toFile());

                // DTO 객체에 이미지 파일 경로를 설정
                doctorDto.setProfileImage("/images/ProfileImage/" + fileName);
                // DTO 객체를 서비스 계층에 전달하여 의사 정보 저장 시도
                doctorService.createDoctor(doctorDto);
            }

            // 성공 메시지 반환
            return "의사 정보가 성공적으로 생성되었습니다!";
        } catch (IOException e) {  // 파일 처리 중 예외 발생 시
            logger.error("사진 저장 중 오류 발생: ", e);
            return "사진 저장 중 오류가 발생했습니다.";
        } catch (Exception e) {  // 기타 예외 발생 시
            logger.error("의사 생성 중 오류 발생: ", e);
            return "의사 생성 중 오류가 발생했습니다.";
        }
    }
}