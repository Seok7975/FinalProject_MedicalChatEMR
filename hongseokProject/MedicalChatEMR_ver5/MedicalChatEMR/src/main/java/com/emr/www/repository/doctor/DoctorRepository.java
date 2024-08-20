package com.emr.www.repository.doctor;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.emr.www.entity.doctor.DoctorEntity;

import java.util.List;

@Repository
public interface DoctorRepository extends JpaRepository<DoctorEntity, Integer> {

    @Query("SELECT d FROM DoctorEntity d WHERE (:name IS NULL OR d.name LIKE %:name%) AND (:position IS NULL OR d.position = :position)")
    List<DoctorEntity> searchDoctors(@Param("name") String name, @Param("position") String position);

    @Query("SELECT d FROM DoctorEntity d WHERE :name IS NULL OR d.name LIKE %:name%")
    List<DoctorEntity> findByNameContaining(@Param("name") String name);

    @Query("SELECT d FROM DoctorEntity d WHERE :position IS NULL OR d.position = :position")
    List<DoctorEntity> findByPosition(@Param("position") String position);

	boolean existsBySecurityNum(String securityNum);
}
