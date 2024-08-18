<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | Page | Medical EMR</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css'
	rel='stylesheet'>
<link rel="stylesheet" type="text/css" href="/resources/css/login.css">
</head>

<body>
	<div class="row header-barra hidden-xs">
		<div class="container">
			<div class="header-text">
				<a href="about:blank" class="text-gral"
					style="font-size: 12px; margin-right: 36px;"> Tienda<i
					class="fa fa-info-circle"
					title="Como afiliados de Amazon, algunas compras nos pueden generar comisión."
					style="margin-left: 3px;"></i>
				</a> <a href="about:blank" class="text-gral" target="_blank"
					rel="noreferrer noopener"
					style="font-size: 12px; margin-right: 36px;"> <img
					src="https://www.doctorespecialistas.com/img/gral/headerFooter/header-spanish_medical-tourism.png"
					srcset="https://www.doctorespecialistas.com/img/gral/headerFooter/header-spanish_medical-tourism.webp"
					width="15" height="15" style="margin-top: -2px; height: 15px;"
					alt="Language icon"> English
				</a>
			</div>
		</div>
	</div>
	<div class="row vh-100 g-0">
		<div class="col-lg-6 position-relative d-none d-lg-block">
			<div class="bg-holder"
				style="background-image: url('/resources/img/bg.jpg');">
				<div class="bg-text">
					<div>Get access to everything WebMD offers</div>
					<ul>
						<li><i class='bx bxs-user-circle'></i>Personalized tools for
							managing your health</li>
						<li><i class='bx bxs-envelope'></i>Health and wellness
							updates delivered to your inbox</li>
						<li><i class='bx bxs-bookmark'></i>Saved articles, conditions
							and medications</li>
						<li><i class='bx bxs-heart'></i>Expert insights and patient
							stories</li>
					</ul>
				</div>
			</div>
			<div class="bg-holder-downside">

				<span>This site is protected by MCE and its Privacy Policy
					and Terms of Service apply.</span>

				<div class="foreignSupport">
					<hr>
					<span>Privacy Notice | Terms of Service | Cookie Preferences
					</span>

				</div>
			</div>
		</div>

		<div class="col-lg-6 d-flex align-items-center justify-content-center">
			<div class="login-container">
				<div class="text-center mb-5">
					<a href="#"> <img src="/resources/img/logo.png" alt="Logo">

					</a>
					<h3 class="fw-bold">Log In</h3>
					<p class="text-secondary">Get access to your account</p>
				</div>

				<button class="btn btn-outline-secondary btn-lg w-100"
					onclick="openRegistrationForm()">
					<i class='bx bx-user-plus'></i> Sign Up
				</button>

				<div class="position-relative text-center my-4">
					<hr>
					<span class="divider-content-center"></span>
				</div>

				<!-- Form action set to /login with method POST -->
				<form action="/Login" method="POST">
					<div class="mb-3">
						<input type="text" class="form-control form-control-lg"
							id="exampleInputuuid" name="licenseId"
							aria-describedby="uuidHelp" placeholder="Enter Your License ID"
							required>
					</div>
					<div class="mb-3">
						<input type="password" class="form-control form-control-lg"
							id="exampleInputPassword1" name="password" placeholder="Password"
							autocomplete="none" required>
					</div>
					<div class="d-flex justify-content-between mb-4">
						<div>
							<!-- Label element is now associated with the checkbox -->
							<input type="checkbox" id="isAdmin" name="isAdmin"> <label
								for="isAdmin" style="cursor: pointer;">관리자 모드</label>
							<!-- 클릭 시 체크박스 선택 가능 -->
						</div>
						<a href="#" class="text-decoration-none"
							onclick="openFindPassword()">Forgot Password?</a>
					</div>
					<button type="submit" class="btn btn-success btn-lg w-100">Log
						In</button>
				</form>


			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
        function openRegistrationForm() {
            window.open('/registration_form', 'RegistrationForm', 'width=500,height=550');
        }
	    function openFindPassword() {
	        window.open('/findPassword', 'FindPasswordWindow', 'width=500,height=550');
	    }
	    // URL 파라미터 읽기
        const urlParams = new URLSearchParams(window.location.search);

        // 비밀번호가 설정되지 않은 경우
        if (urlParams.has('passwordNotSet')) {
            alert('회원가입을 통해 초기 비밀번호를 설정해주세요.');
        }

        // 로그인 오류가 발생한 경우
        if (urlParams.has('loginError')) {
            alert('해당 계정은 존재하지 않습니다. 다시 확인해주세요.');
        }
	</script>


</body>

</html>