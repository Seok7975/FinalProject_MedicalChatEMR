/*
 * package com.emr.www.config.jwt;
 * 
 * import org.springframework.context.annotation.Bean; import
 * org.springframework.context.annotation.Configuration; import
 * org.springframework.security.config.annotation.web.builders.HttpSecurity;
 * import org.springframework.security.config.annotation.web.configuration.
 * EnableWebSecurity; import
 * org.springframework.security.web.SecurityFilterChain;
 * 
 * @Configuration
 * 
 * @EnableWebSecurity public class TestSecurityConfig {
 * 
 * @Bean public SecurityFilterChain securityFilterChain(HttpSecurity http)
 * throws Exception { http .authorizeRequests() .anyRequest().permitAll() // 모든
 * 요청을 허용 (인증 비활성화) .and() .csrf().disable(); // CSRF 보호 비활성화 (선택 사항)
 * 
 * return http.build(); } }
 */