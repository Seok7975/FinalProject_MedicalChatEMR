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

emplAdd:hover {
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
		<form id="employeeForm" method="post" action="employeeCreate"
			enctype="multipart/form-data">
			 <div class="radio-group">
           		 <label><input type="radio" name="job" value="doctor" class="position" onclick="updateJobTitleOptions()" checked required> 의사</label>
           		 <label><input type="radio" name="job" value="nurse" class="position" onclick="updateJobTitleOptions()" required> 간호사</label>
       		 </div>

 <div class="form-group">
            <label for="job-title">직급:</label>
            <select id="job-title" name="job-title" class="emplWrite">
                <!-- 옵션은 JavaScript로 동적으로 생성 -->
            </select>
        </div>
        
			<label for="name">이름:</label>
			<input type="text" id="name" name="name" placeholder="이름" class="emplWrite" required>

  			<div class="form-group">
          	  <label for="phone">전화번호:</label>
           	 <input type="text" id="phone" name="phone" placeholder="010-1234-5678" class="emplWrite" maxlength="13" required>
       		 </div>
       		 
			<label for="ssn">주민번호:</label>
			<input type="text" id="birthdate" name="securityNum" class="emplWrite" placeholder="000000-0000000" maxlength="14" required>

        
			<label for="email">이메일:</label>
			<input type="email" id="email" name="email" class="emplWrite" placeholder="이메일" required>
	   		
	   		<!-- 의사에만 해당하는 필드 -->
	        <div class="form-group doctor-field">
	            <label for="department">부서:</label>
	            <input type="text" id="department" name="departmentId" class="emplWrite">
	        </div>
	        <div class="form-group doctor-field">
	            <label for="specialty">전문분야:</label>
	            <input type="text" id="specialty" name="specialty"  class="emplWrite">
	        </div>
	        <!-- 간호사에만 해당하는 필드 -->
	        <div class="form-group nurse-field" style="display:none;">
	            <label for="role">역할:</label>
	            <input type="text" id="role" name="role">
	        </div>
			
			<label for="photo">증명사진:</label>
			<input type="file" id="photo" name="photo" accept="image/*" class="emplWrite" required>

			<button type="submit" class="emplAdd">직원 추가</button>
		</form>
	</div>
	<script>
	window.onload = function() {
	    var message = "${message}";
	    if (message) {
	        alert(message);
	    }

	    // 기본적으로 첫 번째 라디오 버튼에 따라 옵션 설정
	    updateJobTitleOptions();
	    document.querySelector("form").addEventListener("submit", validateAndSubmit);
	}

	function updateJobTitleOptions() {
	    const jobTitleSelect = document.getElementById("job-title");
	    const doctorOptions = ["인턴", "레지던트", "전문의", "교수", "퇴직"];
	    const nurseOptions = ["인턴", "정규직", "수간호사", "퇴직"];

	    // 직업 선택에 따라 옵션 변경
	    if (document.querySelector('input[name="job"]:checked').value === "doctor") {
	        updateSelectOptions(jobTitleSelect, doctorOptions);
	        document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'block');
	        document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'none');
	    } else if (document.querySelector('input[name="job"]:checked').value === "nurse") {
	        updateSelectOptions(jobTitleSelect, nurseOptions);
	        document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'none');
	        document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'block');
	    }
	}

	function updateSelectOptions(selectElement, options) {
	    selectElement.innerHTML = "";
	    options.forEach(option => {
	        const opt = document.createElement("option");
	        opt.value = option;
	        opt.text = option;
	        selectElement.add(opt);
	    });
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
	</script>
</body>
</html>