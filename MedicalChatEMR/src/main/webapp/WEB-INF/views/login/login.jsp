<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Page | Medical EMR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
	<link rel="stylesheet" type="text/css" href="/resources/css/login.css">
</head>

<body>
    <div class="row header-barra hidden-xs">
        <div class="container">
            <div class="header-text">
                <a href="about:blank" class="text-gral"
                    style="font-size:12px; margin-right:36px;">
                    Tienda<i class="fa fa-info-circle"
                        title="Como afiliados de Amazon, algunas compras nos pueden generar comisión."
                        style="margin-left:3px;"></i>
                </a>
                <a href="about:blank" class="text-gral" target="_blank" rel="noreferrer noopener"
                    style="font-size:12px; margin-right:36px;">
                    <img src="https://www.doctorespecialistas.com/img/gral/headerFooter/header-spanish_medical-tourism.png"
                        srcset="https://www.doctorespecialistas.com/img/gral/headerFooter/header-spanish_medical-tourism.webp"
                        width="15" height="15" style="margin-top:-2px; height:15px;" alt="Language icon">
                    English
                </a>
            </div>
        </div>
    </div>
    <div class="row vh-100 g-0">
        <div class="col-lg-6 position-relative d-none d-lg-block">
            <div class="bg-holder" style="background-image: url('/resources/img/bg.jpg');">
                <div class="bg-text">
                    <div>Get access to everything WebMD offers</div>
                    <ul>
                        <li><i class='bx bxs-user-circle'></i>Personalized tools for managing your health</li>
                        <li><i class='bx bxs-envelope'></i>Health and wellness updates delivered to your inbox</li>
                        <li><i class='bx bxs-bookmark'></i>Saved articles, conditions and medications</li>
                        <li><i class='bx bxs-heart'></i>Expert insights and patient stories</li>

                    </ul>
                </div>

                <a href="https://www.example.com">

                    <img src="https://www.doctorespecialistas.com/img/gral/headerFooter/img-footer-medtalk-doctores-especialistas.png"
                        srcset="https://www.doctorespecialistas.com/img/gral/headerFooter/img-footer-medtalk-doctores-especialistas.webp"
                        class="img-responsive img-center" width="190" height="40" alt="Logo MedTalk">

                    <img src="https://www.doctorespecialistas.com/img/gral/headerFooter/img-logo-footer-doctor-especialistas.png"
                        srcset="https://www.doctorespecialistas.com/img/gral/headerFooter/img-logo-footer-doctor-especialistas.webp"
                        class="img-responsive img-center" width="190" height="40" alt="Logo Doctor Especialistas">
                </a>
            </div>
            <div class="bg-holder-downside">

                <span>This site is protected by MCE and its Privacy Policy and Terms of Service apply.</span>

                <div class="foreignSupport">
                    <img src="https://www.doctorespecialistas.com/img/gral/headerFooter/img-logo-medical-tourism-footer.png"
                        class="img-responsive img-center" width="170" height="45" alt="Logo Medical Tourism">


                    <hr>
                    <span>Privacy Notice | Terms of Service | Cookie Preferences </span>

                </div>
            </div>
        </div>

        <div class="col-lg-6 d-flex align-items-center justify-content-center">
            <div class="login-container">
                <div class="text-center mb-5">
                    <a href="#">
                        <img src="/resources/img/logo.png" alt="Logo">

                    </a>
                    <h3 class="fw-bold">Log In</h3>
                    <p class="text-secondary">Get access to your account</p>
                </div>

                <button class="btn btn-outline-secondary btn-lg w-100 mb-3">
                    <i class='bx bx-git-pull-request'></i> Request a UUID
                </button>
                <button class="btn btn-outline-secondary btn-lg w-100" onclick="openRegistrationForm()">
                    <i class='bx bx-user-plus'></i> Sign Up
                </button>

                <div class="position-relative text-center my-4">
                    <hr>
                    <span class="divider-content-center">OR</span>
                </div>

                <form>
                    <div class="mb-3">
                        <input type="uuid" class="form-control form-control-lg" id="exampleInputuuid"
                            aria-describedby="uuidHelp" placeholder="Enter Your UUID">
                    </div>
                    <div class="mb-3">
                        <input type="password" class="form-control form-control-lg" id="exampleInputPassword1"
                            placeholder="Password">
                    </div>
                    <div class="d-flex justify-content-between mb-4">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Remember Me</label>
                        </div>
						<a href="#" class="text-decoration-none" onclick="openFindPassword()">Forgot Password?</a>
                    </div>
                    <button type="submit" class="btn btn-success btn-lg w-100">Log In</button>
                </form>


            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-IQfZZR42KNbppXb2lHtKdEY98HYdnu6/Qt+Xh8Hlm6ZjAA9e2gNPlxU0aLvxmZ4j"
        crossorigin="anonymous"></script>
    <script>
        function openRegistrationForm() {
            window.open('registration_form', 'RegistrationForm', 'width=400,height=450');
        }
    </script>
	<script>
	    function openFindPassword() {
	        window.open('findPassword', 'FindPasswordWindow', 'width=400,height=450');
	    }
	</script>


</body>

</html>