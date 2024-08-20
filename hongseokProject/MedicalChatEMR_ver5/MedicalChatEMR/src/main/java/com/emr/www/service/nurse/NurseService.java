package com.emr.www.service.nurse;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.emr.www.dto.nurse.NurseDTO;
import com.emr.www.entity.nurse.NurseEntity;
import com.emr.www.repository.nurse.NurseRepository;

@Service
public class NurseService {

    @Autowired
    private NurseRepository nurseRepository;

    public void createNurse(NurseDTO nurseDto) {
        // DTO를 엔티티로 변환
        NurseEntity nurseEntity = new NurseEntity();
        nurseEntity.setName(nurseDto.getName());
        nurseEntity.setPhone(nurseDto.getPhone());
        nurseEntity.setSecurityNum(nurseDto.getSecurityNum());
        nurseEntity.setEmail(nurseDto.getEmail());
        nurseEntity.setLicenseId(nurseDto.getLicenseId());  // 추가된 필드
        nurseEntity.setPassword(nurseDto.getPassword());    // 추가된 필드
        nurseEntity.setPosition(nurseDto.getPosition());  // 역할 설정
        nurseEntity.setProfileImage(nurseDto.getProfileImage());  // 이미지 경로 저장
        nurseEntity.setActiveStatus("자리 비움"); //기본 설정
        nurseEntity.setDepartmentId(nurseDto.getDepartmentId());

        nurseRepository.save(nurseEntity);  
    }


 // 간호사 데이터를 이름과 직급에 따라 검색하는 메서드
    public List<NurseEntity> searchNurses(String name, String position) {
        return nurseRepository.searchNurses(name, position);
    }
 // 엔티티를 DTO로 변환하는 메소드
    public NurseDTO convertEntityToDto(NurseEntity nurseEntity) {
        NurseDTO nurseDto = new NurseDTO();
        nurseDto.setNo(nurseEntity.getNo());
        nurseDto.setName(nurseEntity.getName());
        nurseDto.setPhone(nurseEntity.getPhone());
        nurseDto.setSecurityNum(nurseEntity.getSecurityNum());
        nurseDto.setEmail(nurseEntity.getEmail());
        nurseDto.setLicenseId(nurseEntity.getLicenseId());
        nurseDto.setPassword(nurseEntity.getPassword());
        nurseDto.setPosition(nurseEntity.getPosition());
        nurseDto.setProfileImage(nurseEntity.getProfileImage());
        nurseDto.setActiveStatus(nurseEntity.getActiveStatus()); 
        nurseDto.setDepartmentId(nurseEntity.getDepartmentId()); 

        return nurseDto;
    }
}
