package com.emr.www.service.doctor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.emr.www.entity.Status;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.entity.doctor.dto.DoctorDto;
import com.emr.www.repository.doctor.DoctorRepository;

@Service
public class DoctorService {
    
    @Autowired
    private DoctorRepository doctorRepository;

    public void createDoctor(DoctorDto doctorDto) {
        // DTO를 엔티티로 변환
        DoctorEntity doctor = new DoctorEntity();
        doctor.setName(doctorDto.getName()); //의사 이름 입니다.
        doctor.setPhone(doctorDto.getPhone()); // 의사 전화번호 입니다.
        doctor.setSecurityNum(doctorDto.getSecurityNum()); //의사 주민등록번호입니다.
        doctor.setEmail(doctorDto.getEmail()); // 의사 이메일 입니다. 
        doctor.setPosition(doctorDto.getPosition()); //의사 직급입니다.
        doctor.setLicenseId(doctorDto.getLicenseId());   // 의사 면허번 입니다.
        doctor.setPassword(doctorDto.getPassword());  // 의사 비밀번호 입니다.  
        doctor.setDepartmentId(doctorDto.getDepartmentId());  //의사 진료과 입니다.
        doctor.setProfileImage(doctorDto.getProfileImage());  // 이미지 경로 저장
        
        String statusValue = doctorDto.getActiveStatus();
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
            doctor.setActiveStatus(status);  // 상태 값을 설정
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("잘못된 상태 값: " + statusValue);
        }

        doctorRepository.save(doctor);  // 상태가 설정된 doctor 객체를 저장
    }
    public List<DoctorEntity> findDoctors(String name, String position) {
        // 이름과 직급 기준으로 의사 데이터 검색
        return doctorRepository.findByNameContainingAndPosition(name, position);
    }
}
