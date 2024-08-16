<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Registration Form</title>
	<link rel="stylesheet" type="text/css" href="resources/css/styles.css">
    <script src="resources/js/script.js"></script>
	<style>
		.hidden {
		    display: none;
		}
		
		button {
		    background-color: #8ae985; /* 버튼 배경색 */
		    color: #ffffff;            /* 버튼 텍스트 색상 */
		    border: none;              /* 버튼 테두리 제거 */
		    padding: 0.75rem 1.5rem;   /* 버튼 안쪽 여백 (상하, 좌우) */
		    border-radius: 0.375rem;   /* 버튼 모서리 둥글기 */
		    cursor: pointer;           /* 버튼 클릭 시 커서 모양 변경 */
		    font-size: 1rem;           /* 버튼 텍스트 크기 */
		    text-align: center;        /* 텍스트 중앙 정렬 */
		    transition: background-color 0.3s, transform 0.3s; /* 배경색과 변형의 부드러운 전환 효과 */
		    width: 100%;               /* 버튼 너비를 부모 요소에 맞춤 */
		}

		button:hover {
		    background-color: #5fe758; /* 버튼 호버 시 배경색 변경 */
		    transform: scale(1.05);    /* 버튼 호버 시 크기 약간 증가 */
		}

		button:focus {
		    outline: 2px solid #0056b3; /* 버튼 포커스 시 테두리 색상 */
		    outline-offset: 2px;        /* 포커스 테두리와 버튼 간격 */
		}

		button:active {
		    background-color: #7cd078; /* 버튼 클릭 시 배경색 변경 */
		    transform: scale(1);       /* 버튼 클릭 시 크기 원상복귀 */
		}
		
		.icon-container {
			display: flex;
			justify-content: center;
			margin-bottom: 24px;
		}

		.icon {
			background-color: #B8EDB5;
			padding: 16px;
			border-radius: 50%;
		}

		.icon svg {
			width: 32px;
			height: 32px;
			color: #ffffff;
		}



	</style>
</head>

<body>
    <section class="container">
		<div class="icon-container">
		    <div class="icon">
		        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
		            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z" />
		        </svg>
		    </div>
		</div>
        <header>Reset Password</header>
		<div class="gender-box">
		                <h3>Position</h3>
		                <div class="gender-option">
		                    <div class="gender">
		                        <input type="radio" id="doctor" name="position" value="Doctor" checked />
		                        <label for="doctor">Doctor</label>
		                    </div>
		                    <div class="gender">
		                        <input type="radio" id="nurse" name="position" value="Nurse" />
		                        <label for="nurse">Nurse</label>
		                    </div>
		                    <div class="gender">
		                        <input type="radio" id="pharmacist" name="position" value="Pharmacist" />
		                        <label for="pharmacist">Pharmacist</label>
		                    </div>
		                </div>
		            </div>

		            <div class="inline-group">
		                <div class="input-box">
		                    <label for="medical-field">회원구분</label>
		                    <select id="medical-field" name="medicalField">
		                        <option hidden>Select Medical Field</option>
		                        <option>내과 (Internal Medicine)</option>
		                        <option>외과 (Surgery)</option>
		                        <option>정형외과 (Orthopedics)</option>
		                        <option>소아과 (Pediatrics)</option>
		                        <option>산부인과 (Obstetrics and Gynecology)</option>
		                        <option>이비인후과 (Otolaryngology)</option>
		                        <option>피부과 (Dermatology)</option>
		                        <option>치과 (Dentistry)</option>
		                        <option>감염의학과 (Infectious Diseases)</option>
		                        <option>종양학과 (Oncology)</option>
		                        <option>응급의학과 (Emergency Medicine)</option>
		                        <option>병리학과 (Pathology)</option>
		                        <option>내분비학과 (Endocrinology)</option>
		                    </select>
		                </div>

		                <div class="input-box input-box-1">
		                    <label for="position-level">Position Level</label>
		                    <select id="position-level" name="positionLevel">
		                        <option hidden>Select Position Level</option>
		                        <option>레지던트 (Resident)</option>
		                        <option>인턴 (Intern)</option>
		                        <option>전문의 (Specialist)</option>
		                        <option>의학교수 (Professor of Medicine)</option>
		                        <option>전임의 (Fellow)</option>
		                        <option>주치의 (Attending Physician)</option>
		                        <option>컨설턴트 (Consultant)</option>
		                        <option>선임 컨설턴트 (Senior Consultant)</option>
		                        <option>최고 의료 책임자 (Chief Medical Officer)</option>
		                    </select>
		                </div>

		                <div class="input-box input-box-2">
		                    <label for="position-level-2">Position Level</label>
		                    <select id="position-level-2" name="positionLevel">
		                        <option hidden>Select Position Level</option>
		                        <option>등록 간호사 (RN)</option>
		                        <option>임상 간호사 전문가(CNS)</option>
		                        <option>간호 실무자 (NP)</option>
		                        <option>간호 조무사(Certified Nursing Assistant)</option>
		                        <option>공인 간호 조산사 (CNM)</option>
		                        <option>공인 등록 간호사(CRNA)</option>
		                        <option>책임 간호사 (Charge Nurse)</option>
		                        <option>간호 관리자 (Nurse Manager)</option>
		                        <option>간호 조정자 (Nurse Coordinator)</option>
		                        <option>최고 간호 책임자 (CNO)</option>
		                    </select>
		                </div>

		                <div class="input-box input-box-3">
		                    <label for="position-level-3">Position Level</label>
		                    <select id="position-level-3" name="positionLevel">
		                        <option hidden>Select Position Level</option>
		                        <option>약사 (Pharmacist)</option>
		                        <option>임상 약사 (Clinical Pharmacist)</option>
		                        <option>병원 약사 (Hospital Pharmacist)</option>
		                        <option>약국 약사 (Community Pharmacist)</option>
		                        <option>약국 관리자 (Pharmacy Manager)</option>
		                        <option>약국 디렉터 (Pharmacy Director)</option>
		                        <option>약제 기술사 (Pharmacy Technician)</option>
		                        <option>약물 치료 관리 약사 (MTM)</option>
		                        <option>약물 감시 전문의 (Pharmacovigilance Specialist)</option>
		                    </select>
		                </div>
		            </div>

            <div class="input-box">
                <label for="full-name">이름</label>
                <input type="text" id="full-name" name="fullName" placeholder="Enter full name" required />
            </div>
			
			<div class="gender-box">
			               <h3>인증 방법</h3>
			               <div class="gender-option">
			                   <div class="gender">
			                       <input type="radio" id="phone-auth" name="authMethod" value="phone" checked onchange="toggleAuthFields()" />
			                       <label for="phone-auth">휴대폰 인증</label>
			                   </div>
			                   <div class="gender">
			                       <input type="radio" id="email-auth" name="authMethod" value="email" onchange="toggleAuthFields()" />
			                       <label for="email-auth">이메일 인증</label>
			                   </div>
			               </div>
			           </div>

			           <div id="phone-field" class="input-box">
			               <label for="phone">휴대폰</label>
			               <input type="tel" id="phone" name="phone" placeholder="Enter phone number" required />
			           </div>

			           <div id="email-field" class="input-box hidden">
			               <label for="email">이메일</label>
			               <input type="email" id="email" name="email" placeholder="Enter email address" required />
			           </div>
            <button type="submit">Submit</button>
        </form>
    </section>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="resources/js/Postcode.js"></script>
	<script>
	       function toggleAuthFields() {
	           const phoneField = document.getElementById('phone-field');
	           const emailField = document.getElementById('email-field');
	           const selectedAuthMethod = document.querySelector('input[name="authMethod"]:checked').value;

	           if (selectedAuthMethod === 'phone') {
	               phoneField.classList.remove('hidden');
	               emailField.classList.add('hidden');
	           } else if (selectedAuthMethod === 'email') {
	               phoneField.classList.add('hidden');
	               emailField.classList.remove('hidden');
	           }
	       }

	       // Initialize visibility based on the default selected radio button
	       document.addEventListener('DOMContentLoaded', () => {
	           toggleAuthFields();
	       });
	   </script>
</body>

</html>
