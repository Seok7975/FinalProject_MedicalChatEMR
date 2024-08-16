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
    <style>
        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
        }


        .header-barra {
            background-color: #b8edb5;
            color: #fff;
            padding: 0.5rem 0;
        }

        .header-barra .container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .header-barra .header-text {
            font-size: 0.875rem;
        }

        .header-barra .header-text a {
            color: #fff;
            text-decoration: none;
            margin-right: 2rem;
        }

        .header-barra .header-text a:hover {
            text-decoration: underline;
        }

        .header-barra .header-text i {
            margin-left: 0.3rem;
        }

        .header-barra .header-text img {
            vertical-align: middle;
            margin-top: -2px;
            height: 15px;
        }

        .bg-holder {
            position: absolute;
            width: 100%;
            min-height: 100%;
            top: 0;
            left: 0;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: -1;
        }

        .login-container {
            position: relative;
            width: 100%;
            max-width: 99%;
            height: 99vh;
            padding: 2rem;
            background: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }


        .divider-content-center {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 0 1rem;
            background-color: #fff;
            font-size: 0.9rem;
            font-weight: 500;
            color: #999;
        }


        hr {
            border: 0;
            border-top: 1px solid #ddd;
            margin: 1.5rem 0;
        }

        /* Button styling */
        .btn-outline-secondary {
            border-color: #ddd;
            color: #333;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            background-color: #f8f9fa;
            color: #333;
            border-color: #ccc;
        }

        .btn-outline-secondary i {
            margin-right: 0.5rem;
        }


        .login-container img {
            max-width: 150px;
            height: auto;
            margin-bottom: 1rem;
        }


        .form-control-lg {
            height: 3.5rem;
            font-size: 1.125rem;
        }

        .form-check-input {
            margin-top: 0.3rem;
        }

        .form-check-label {
            margin-left: 0.5rem;
        }


        .bg-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: #fff;
            font-size: 1.5rem;
            font-weight: 700;
            width: 80%;
            background-color: rgba(0, 0, 0, 0.5);
            padding: 1rem;
            border-radius: 8px;
        }

        .bg-text ul {
            list-style: none;
            padding: 0;
            margin: 1rem 0 0;
            text-align: left;
        }

        .bg-text ul li {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            font-size: 1rem;
            font-weight: 400;
        }

        .bg-text ul li i {
            margin-right: 0.5rem;
        }

        .background-footer {
            background-color: #b8edb5;
            padding: 2rem 0;
        }

        .background-footer a {
            color: #333;
            text-decoration: none;
        }

        .background-footer a:hover {
            text-decoration: underline;
        }

        .background-footer .text-gral-footer {
            color: #333;
            font-size: 0.875rem;
        }

        .background-footer .menu-footer a {
            display: block;
            margin-bottom: 0.5rem;
        }

        .background-footer .centrar-contenido-horizontal {
            display: flex;
            justify-content: center;
        }

        .background-footer .margen-logos-us {
            margin-top: 1rem;
        }

        @media (max-width: 991px) {
            .bg-holder {
                display: none;
            }

            .login-container {
                padding: 1rem;
            }

            .background-footer {
                text-align: center;
            }

            .background-footer .menu-footer {
                text-align: center;
                margin-bottom: 1rem;
            }

            .background-footer .margen-logo-footer {
                display: flex;
                flex-direction: column;
                align-items: center;
            }
        }

        .col-lg-6.position-relative.d-none.d-lg-block {
            flex: 0 0 75%;
            max-width: 75%;
        }

        .col-lg-6.d-flex.align-items-center.justify-content-center {
            flex: 0 0 25%;
            max-width: 25%;
        }

        .bg-holder-downside {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            color: #fff;
            padding: 1rem;
            text-align: center;
            font-size: 0.875rem;
        }

        .bg-holder-downside a {
            color: #b8edb5;
            text-decoration: none;
        }

        .bg-holder-downside a:hover {
            text-decoration: underline;
        }

        .foreignSupport {
            margin-top: 1rem;
            text-align: center;
        }

        .enIcon {
            display: inline-block;
            background-color: #b8edb5;
            color: #fff;
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            margin-top: 0.5rem;
        }
    </style>
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