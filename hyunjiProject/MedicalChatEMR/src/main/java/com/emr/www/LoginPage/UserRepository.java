package com.emr.www.LoginPage;

import org.springframework.data.jpa.repository.JpaRepository;
import com.emr.www.LoginPage.*;

public interface UserRepository extends JpaRepository<User,Long>{
    boolean existsByLicenseKey(String licenseKey);
}
