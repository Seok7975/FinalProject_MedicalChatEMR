<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>비밀번호 설정</title>
<link rel="stylesheet" type="text/css" href="/css/login/styles2.css">
<script>
function validateSignup(event) {
    // 비밀번호와 확인 비밀번호가 일치하는지 체크
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm-password').value;
    
    // 비밀번호 일치 여부 확인
    if (password !== confirmPassword) {
        alert('비밀번호가 일치하지 않습니다. 다시 확인해주세요.');
        event.preventDefault(); // 폼 제출을 막음
        return false;
    }
    
    // 비밀번호 길이 확인
    if (password.length < 4 || password.length > 15) {
        alert('비밀번호는 4자리 이상, 15자리 이하로 설정해주세요.');
        event.preventDefault(); // 폼 제출을 막음
        return false;
    }

    // 모든 검증 통과 시 폼 제출
    return true;
}
	   </script>
</head>
<body>
	<div class="container">
		<div class="icon-container">
			<div class="icon">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round"
						stroke-width="2"
						d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z" />
                </svg>
			</div>
		</div>
		<h1>Sign in</h1>
		<form id="signupForm" action="/signup" method="post"
			onsubmit="return validateSignup(event)">
			<!-- License Key 입력란 -->
			<div class="form-group">
				<label for="license-key">라이센스 키</label> <input type="text"
					id="licenseId" name="licenseId" placeholder="Enter Your License ID"
					required>
			</div>
			<!-- Password 입력란 -->
			<div class="form-group">
				<label for="password">초기 비밀번호 설정</label> <input type="password"
					id="password" name="password" placeholder="Password"
					autocomplete="new-password" required>
			</div>

			<!-- Confirm Password 입력란 -->
			<div class="form-group">
				<label for="confirm-password">비밀번호 확인</label> <input type="password"
					id="confirm-password" name="confirm-password"
					placeholder="Check Password" autocomplete="new-password" required>
			</div>

			<!-- Submit 버튼 -->
			<button type="submit" class="submit-btn">Sign up</button>
		</form>
	</div>
	<script>
    window.onload = function () {
        const message = '<%=request.getAttribute("message")%>';
        if (message && message !== "null") {
            // 성공 메시지를 alert로 표시
            if (message.includes("성공적으로 설정")) {
                alert(message);
                window.close(); // 확인을 누른 후 창을 닫음
            } else {
                // 다른 메시지에 대한 처리
                alert(message);  // 다른 메시지에 대해서도 알림 창 띄움
            }
        }
    };
</script>
</body>
</html>
