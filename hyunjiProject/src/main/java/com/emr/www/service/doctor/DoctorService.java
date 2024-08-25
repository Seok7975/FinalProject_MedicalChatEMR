package com.emr.www.service.doctor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import com.emr.www.dto.doctor.DoctorDTO;
import com.emr.www.entity.doctor.DoctorEntity;
import com.emr.www.repository.doctor.DoctorRepository;

@Service
public class DoctorService {
    
    @Autowired
    private DoctorRepository doctorRepository;
 
    //관리자
    @PreAuthorize("hasRole('ADMIN')")
    public void createDoctor(DoctorDTO doctorDto) {
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
        doctor.setActiveStatus("자리 비움"); //기본설
        

        doctorRepository.save(doctor);  
    }

    
 // 의사 데이터를 이름과 직급에 따라 검색하는 메서드
    public List<DoctorEntity> searchDoctors(String name, String position) {
        return doctorRepository.searchDoctors(name, position);

    }
    
    //수간호사
    public List<DoctorEntity> getAllDoctors() {
        return doctorRepository.findAll();
    }
    
    // 엔티티를 DTO로 변환하는 메소드
    public DoctorDTO convertEntityToDto(DoctorEntity doctorEntity) {
        DoctorDTO doctorDto = new DoctorDTO();
        doctorDto.setName(doctorEntity.getName());
        doctorDto.setPhone(doctorEntity.getPhone());
        doctorDto.setSecurityNum(doctorEntity.getSecurityNum());
        doctorDto.setEmail(doctorEntity.getEmail());
        doctorDto.setPosition(doctorEntity.getPosition());
        doctorDto.setLicenseId(doctorEntity.getLicenseId());
        doctorDto.setPassword(doctorEntity.getPassword());
        doctorDto.setDepartmentId(doctorEntity.getDepartmentId());
        doctorDto.setProfileImage(doctorEntity.getProfileImage());
        doctorDto.setActiveStatus(doctorEntity.getActiveStatus());

        return doctorDto;
    }


}