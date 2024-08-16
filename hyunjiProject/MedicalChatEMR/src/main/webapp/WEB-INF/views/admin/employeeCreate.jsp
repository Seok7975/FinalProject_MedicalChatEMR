<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>병원장 - 직원 추가</title>
<style>
.form-container {
	width: 100%;
	max-width: 600px; /* 최대 너비를 설정하여 너무 넓지 않도록 제한 */
	padding: 20px;
	background-color: #e2e5e291;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	box-sizing: border-box;
	margin: 0 auto;
}

form {
	margin: 0;
	font-size: 16px;
}

label {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
}

.emplWrite {
	width: 100%;
	padding: 10px;
	margin-bottom: 20px;
	border: 1px solid #ddd;
	border-radius: 5px;
	font-size: 16px;
	box-sizing: border-box;
}

.position {
	margin-right: 6px;
}

.radio-group label {
	margin-right: 20px;
	font-weight: normal;
}

.radio-group {
	margin-bottom: 20px;
}

.emplAdd {
	width: 100%;
	padding: 12px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 25px;
	transition: background-color 0.3s;
}

.emplAdd:hover {
	background-color: #45a049;
}

.form-container h1 {
	margin-bottom: 20px;
	font-size: 24px;
	text-align: center;
}
</style>
</head>
<body>
	<div class="form-container">
		<h1>직원 추가</h1>
		<form id="employeeForm" method="post" enctype="multipart/form-data">
			<div class="radio-group">
				<label><input type="radio" name="job" value="doctor"
					class="position" required > 의사</label> <label><input
					type="radio" name="job" value="nurse" class="position" required checked>
					간호사</label>
			</div>

			<div class="form-group doctor-field">
				<label for="job-title">직급:</label> <select id="job-title-doctor"
					name="job-title" class="emplWrite">
					<option value="인턴">인턴</option>
					<option value="레지던트">레지던트</option>
					<option value="전문의">전문의</option>
					<option value="교수">교수</option>
					<option value="퇴직">퇴직</option>
				</select>
			</div>

			<div class="form-group nurse-field" style="display: none;">
				<label for="job-title">직급:</label> <select id="job-title-nurse"
					name="job-title" class="emplWrite">
					<option value="인턴">인턴</option>
					<option value="정규직">정규직</option>
					<option value="수간호사">수간호사</option>
					<option value="퇴직">퇴직</option>
				</select>
			</div>

			<label for="name">이름:</label> <input type="text" id="name"
				name="name" placeholder="이름" class="emplWrite" required>

			<div class="form-group">
				<label for="phone">전화번호:</label> <input type="text" id="phone"
					name="phone" placeholder="010-1234-5678" class="emplWrite"
					maxlength="13" required>
			</div>

			<label for="ssn">주민번호:</label> <input type="text" id="birthdate"
				name="securityNum" class="emplWrite" placeholder="000000-0000000"
				maxlength="14" required> <label for="email">이메일:</label> <input
				type="email" id="email" name="email" class="emplWrite"
				placeholder="이메일" required>

			<!-- 의사에만 해당하는 필드 -->
			<div class="form-group doctor-field">
				<label for="department">부서:</label> <input type="text"
					id="department" name="departmentId" class="emplWrite">
			</div>
			<div class="form-group doctor-field">
				<label for="specialty">전문분야:</label> <input type="text"
					id="specialty" name="specialty" class="emplWrite">
			</div>
			<!-- 간호사에만 해당하는 필드 -->
			<div class="form-group nurse-field" style="display: none;">
				<label for="role">역할:</label> <input type="text" id="role"
					name="role" class="emplWrite">
			</div>

			<label for="photo">증명사진:</label> <input type="file" id="photo"
				name="photo" accept="image/*" class="emplWrite" required>

			<button type="submit" class="emplAdd">직원 추가</button>
		</form>
	</div>
	<script>
	/* function initEmployeeForm() {
	    console.log("initEmployeeForm 함수가 실행되었습니다.");
	    document.addEventListener('DOMContentLoaded', (event) => {
	        console.log("DOMContentLoaded 이벤트가 발생했습니다.");
	        function updateJobTitleOptions() {
	            const job = document.querySelector('input[name="job"]:checked').value;
	            console.log("선택된 직업: ", job);
	            if (job === "doctor") {
	                document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'block');
	                document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'none');
	            } else if (job === "nurse") {
	                document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'none');
	                document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'block');
	            }
	        }

	        document.querySelectorAll('input[name="job"]').forEach((elem) => {
	        	 console.log("라디오 버튼이 변경되었습니다.", elem.value);
	            elem.addEventListener('change', updateJobTitleOptions);
	        });

	        updateJobTitleOptions(); // 기본적으로 첫 번째 라디오 버튼에 따라 옵션 설정
	    });
	} */
	function initEmployeeForm() {
	    console.log("initEmployeeForm 함수가 실행되었습니다.");

	    function updateJobTitleOptions() {
	        const job = document.querySelector('input[name="job"]:checked').value;
	        console.log("선택된 직업: ", job);
	        if (job === "doctor") {
	            document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'block');
	            document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'none');
	        } else if (job === "nurse") {
	            document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'none');
	            document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'block');
	        }
	    }

	    document.querySelectorAll('input[name="job"]').forEach((elem) => {
	        console.log("라디오 버튼이 변경되었습니다.", elem.value);
	        elem.addEventListener('change', updateJobTitleOptions);
	    });

	    updateJobTitleOptions(); // 기본적으로 첫 번째 라디오 버튼에 따라 옵션 설정
	}


	
        function validateAndSubmit(event) {
            event.preventDefault();
            const ssn = document.getElementById("birthdate").value;
            const phone = document.getElementById("phone").value;

            if (!validateSSN(ssn)) {
                alert("주민번호 형식이 잘못되었습니다. 올바른 형식: 123456-1234567");
                return false;
            }

            if (!validatePhone(phone)) {
                alert("전화번호 형식이 잘못되었습니다. 올바른 형식: 010-1234-5678");
                return false;
            }

            // 여기에서 주민번호로 데이터베이스 유효성 검사를 실행합니다.
            checkSSNInDatabase(ssn, function(isValid) {
                if (!isValid) {
                    alert("이미 존재하는 주민번호입니다.");
                    return false;
                }
                // 유효성 검사가 완료되면 폼을 제출합니다.
                document.querySelector("form").submit();
            });
        }

        function validateSSN(ssn) {
            const ssnPattern = /^\d{6}-\d{7}$/;
            return ssnPattern.test(ssn);
        }

        function validatePhone(phone) {
            const phonePattern = /^\d{3}-\d{4}-\d{4}$/;
            return phonePattern.test(phone);
        }

        function checkSSNInDatabase(ssn, callback) {
            // 여기에 Ajax 요청을 통해 서버와 통신하는 코드를 추가할 수 있습니다.
            // 예시로 setTimeout을 사용하여 비동기 콜백 함수를 처리합니다.
            setTimeout(() => {
                // 가정: DB에 주민번호가 없다고 가정 (즉, 새로운 주민번호)
                const isValid = true;  // 실제 구현 시 서버에서 유효성 검사 결과를 받아옵니다.
                callback(isValid);
            }, 1000);
        }
     // 폼 제출 로직도 initEmployeeForm 안에 포함시켜야 합니다
        function initFormSubmission() {
            document.querySelector("form").addEventListener("submit", function(event) {
                event.preventDefault(); // 기본 제출 동작을 막습니다.
                const job = document.querySelector('input[name="job"]:checked').value;
                const actionUrl = job === "doctor" ? "/doctorCreate" : "/nurseCreate";
                
                const formData = new FormData(this);
                fetch(actionUrl, {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.text())
                .then(data => {
                    alert(data); // 성공 메시지를 알림 창으로 표시합니다.
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('직원 추가 중 오류가 발생했습니다.');
                });
            });
        }
 </script>
</body>
</html>