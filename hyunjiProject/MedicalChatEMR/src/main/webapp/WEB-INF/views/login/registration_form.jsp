<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>온라인 등록</title>
	<link rel="stylesheet" type="text/css" href="/resources/css/styles2.css">
	<script>
	       function handleSignup(event) {
	           event.preventDefault(); // 폼의 기본 제출 동작을 방지합니다.
	           
	           const form = document.getElementById('signupForm');
	           const formData = new FormData(form);

	           fetch('/signup', { // 적절한 URL로 변경하세요
	               method: 'POST',
	               body: formData,
	               headers: {
	                   'Accept': 'application/json',
	               }
	           })
	           .then(response => {
	               if (!response.ok) {
	                   return response.json().then(errorData => {
	                       // 서버에서 오류 응답을 반환한 경우 alert 표시
	                       alert('Error: ' + errorData.message);
	                   });
	               }
	               return response.json();
	           })
	           .then(data => {
	               // 성공적으로 데이터를 처리한 경우
	               alert('Signup successful');
	           })
	           .catch(error => {
	               // 네트워크 오류 또는 다른 오류가 발생한 경우
	               alert('Network error: ' + error.message);
	           });
	       }
	   </script>
</head>
<body>
    <div class="container">
        <div class="icon-container">
            <div class="icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z" />
                </svg>
            </div>
        </div>
        <h1>Sign in</h1>
        <form action="/signup" method="post">
            <!-- License Key 입력란 -->
            <div class="form-group">
                <label for="license-key">라이센스 키</label>
                <div class="license-input-group">
                    <input type="text" id="license-part1" name="license-part1" maxlength="2" required>
                    <span>-</span>
                    <input type="text" id="license-part2" name="license-part2" maxlength="4" required>
                    <span>-</span>
                    <input type="text" id="license-part3" name="license-part3" maxlength="2" required>
                    <button type="button" class="verify-btn">검증</button>
                </div>
            </div>
            
            
            <!-- Password 입력란 -->
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호 입력" required>
            </div>

            <!-- Confirm Password 입력란 -->
            <div class="form-group">
                <label for="confirm-password">비밀번호 확인</label>
                <input type="password" id="confirm-password" name="confirm-password" placeholder="비밀번호 확인" required>
            </div>
            
            <!-- Submit 버튼 -->
            <button type="submit" class="submit-btn">지금 등록하기</button>
        </form>
    </div>

    <script>
        // 라이센스 키 입력칸 자동 포커스 이동 스크립트
        const licensePart1 = document.getElementById('license-part1');
        const licensePart2 = document.getElementById('license-part2');
        const licensePart3 = document.getElementById('license-part3');

        licensePart1.addEventListener('input', () => {
            if (licensePart1.value.length === licensePart1.maxLength) {
                licensePart2.focus();
            }
        });

        licensePart2.addEventListener('input', () => {
            if (licensePart2.value.length === licensePart2.maxLength) {
                licensePart3.focus();
            }
        });
    </script>
</body>
</html>
