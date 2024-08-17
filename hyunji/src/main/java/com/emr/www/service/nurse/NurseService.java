package com.emr.www.service.nurse;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.emr.www.entity.Status;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.entity.nurse.dto.NurseDto;
import com.emr.www.repository.nurse.NurseRepository;

@Service
public class NurseService {

    @Autowired
    private NurseRepository nurseRepository;

    public void createNurse(NurseDto nurseDto) {
        // DTO를 엔티티로 변환
        NurseEntity nurse = new NurseEntity();
        nurse.setName(nurseDto.getName());
        nurse.setPhone(nurseDto.getPhone());
        nurse.setSecurityNum(nurseDto.getSecurityNum());
        nurse.setEmail(nurseDto.getEmail());
        nurse.setLicenseId(nurseDto.getLicenseId());  // 추가된 필드
        nurse.setPassword(nurseDto.getPassword());    // 추가된 필드
        nurse.setPosition(nurseDto.getPosition());  // 역할 설정
        nurse.setProfileImage(nurseDto.getProfileImage());  // 이미지 경로 저장

        // 상태 설정
        String statusValue = nurseDto.getActiveStatus();
        if (statusValue == null || statusValue.isEmpty()) {
            statusValue = "자리 비움";  // 기본값 설정
        }

        try {
            Status status;
            switch (statusValue) {
                case "자리 비움":
                    status = Status.자리비움;
                    break;
                case "진료 중":
                    status = Status.진료중;
                    break;
                case "점심시간":
                    status = Status.점심시간;
                    break;
                default:
                    throw new IllegalArgumentException("잘못된 상태 값: " + statusValue);
            }
            nurse.setActiveStatus(status);  // 상태 값을 설정
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("잘못된 상태 값: " + statusValue);
        }

        nurseRepository.save(nurse);  // 상태가 설정된 nurse 객체를 저장
    }
    public List<NurseEntity> findNurses(String name, String position) {
        // 이름과 직급 기준으로 간호사 데이터 검색
        return nurseRepository.findByNameContainingAndPosition(name, position);
    }
}
