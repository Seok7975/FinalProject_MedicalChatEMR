package com.study.springboot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.study.springboot.entity.User;

public interface UserRepository extends JpaRepository<User,Long>{
    boolean existsByLicenseKey(String licenseKey);
}
