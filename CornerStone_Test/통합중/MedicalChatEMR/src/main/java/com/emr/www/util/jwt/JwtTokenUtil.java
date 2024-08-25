package com.emr.www.util.jwt;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

@Component
public class JwtTokenUtil {

	@Value("${jwt.secret}")
	private String SECRET_KEY;

	// 비밀 키를 Key 객체로 변환
	private Key getSigningKey() {
		byte[] keyBytes = SECRET_KEY.getBytes(StandardCharsets.UTF_8);
		return new SecretKeySpec(keyBytes, SignatureAlgorithm.HS256.getJcaName());
	}

	// JWT 토큰 생성 메서드
	public String generateToken(int userNo, String role) {
		Map<String, Object> claims = new HashMap<>();
		claims.put("role", role); // 역할 정보 포함

		return Jwts.builder().setClaims(claims).setSubject(String.valueOf(userNo)) // 사용자의 주키(no)를 `sub`에 저장
				.setIssuedAt(new Date(System.currentTimeMillis())).setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 12)) // 12시간 유효
				.signWith(getSigningKey(), SignatureAlgorithm.HS256).compact();
	}

	// JWT에서 사용자 주키(no) 추출
	public Integer extractNo(String token) {
		return Integer.parseInt(Jwts.parserBuilder().setSigningKey(getSigningKey()).build().parseClaimsJws(token).getBody().getSubject()); //주키는 sub 필드에서 추출
	}

	// JWT에서 역할 정보 추출
	public String extractRole(String token) {
		return Jwts.parserBuilder().setSigningKey(getSigningKey()).build().parseClaimsJws(token).getBody().get("role", String.class);
	}

	// JWT 토큰 만료 확인 체크
	public boolean validateToken(String token) {
	    try {
	        Claims claims = Jwts.parserBuilder()
	            .setSigningKey(getSigningKey())
	            .build()
	            .parseClaimsJws(token)
	            .getBody();
	        
	        // 토큰 만료 여부 체크
	        if (claims.getExpiration().before(new Date())) {
	            System.out.println("JWT 토큰이 만료되었습니다.");
	            return false;
	        }
	        return true; // 토큰이 유효
	    } catch (Exception e) {
	    	 System.out.println("JWT 토큰이 유효하지 않음: " + e.getMessage());
	         return false;
	    }
	}

	// JWT 토큰을 요청에서 추출
	public String resolveToken(HttpServletRequest request) {
		String bearerToken = request.getHeader("Authorization");
		   // 먼저 Authorization 헤더에 JWT 토큰이 있는지 확인
		if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
		        return bearerToken.substring(7);
		}
		
		// Authorization 헤더가 없다면, 쿠키에서 JWT 토큰을 추출
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if ("jwtToken".equals(cookie.getName())) {
					 System.out.println("쿠키에서 JWT 토큰을 추출");
					return cookie.getValue();
				}
			}
		}
		return null; // 토큰이 없을 경우 null 반환
	}
}
