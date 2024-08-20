package com.emr.www.repository.nurse;

import com.emr.www.entity.nurse.NurseEntity;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface NurseRepository extends JpaRepository<NurseEntity, Integer> {

    @Query("SELECT n FROM NurseEntity n WHERE (:name IS NULL OR n.name LIKE %:name%) AND (:position IS NULL OR n.position = :position)")
    List<NurseEntity> searchNurses(@Param("name") String name, @Param("position") String position);

    @Query("SELECT n FROM NurseEntity n WHERE :name IS NULL OR n.name LIKE %:name%")
    List<NurseEntity> findByNameContaining(@Param("name") String name);

    @Query("SELECT n FROM NurseEntity n WHERE :position IS NULL OR n.position = :position")
    List<NurseEntity> findByPosition(@Param("position") String position);
    
	boolean existsBySecurityNum(String securityNum);
}
