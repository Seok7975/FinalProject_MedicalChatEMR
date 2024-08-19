package com.emr.www.repository.nurse;

import com.emr.www.entity.nurse.NurseEntity;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface NurseRepository extends JpaRepository<NurseEntity, Long> ,JpaSpecificationExecutor<NurseEntity> {

    // 필요한 경우 커스텀 메서드를 정의할 수 있습니다.
               // 모든 데이터를 출력
    
	boolean existsBySecurityNum(String securityNum);
}
