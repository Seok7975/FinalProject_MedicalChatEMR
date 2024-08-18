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
		<form id="employeeForm" method="post" 
			enctype="multipart/form-data">
			<div class="radio-group">
				<label><input type="radio" name="job" value="doctor"
					class="job" required> 의사</label> <label><input
					type="radio" name="job" value="nurse" class="job" required>
					간호사</label>
			</div>

			<div class="form-group doctor-field">
				<label for="position">직급:</label> <select id="position-doctor"
					name="position" class="emplWrite">
					<option value="인턴">인턴</option>
					<option value="레지던트">레지던트</option>
					<option value="전문의">전문의</option>
					<option value="교수">교수</option>
					<option value="퇴직">퇴직</option>
				</select>
			</div>

			<div class="form-group nurse-field" style="display: none;">
				<label for="position">직급:</label> <select id="position-nurse"
					name="position" class="emplWrite">
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
				<label for="specialty">전문분야:</label> <input type="text"
					id="specialty" name="specialty" class="emplWrite">
			</div>

			<label for="photo">증명사진:</label> <input type="file" id="photo"
				name="photo" accept="image/*" class="emplWrite" required>

			<button type="submit" class="emplAdd">직원 추가</button>
		</form>
	</div>
</body>
<script src="/js/admin/employeeCreate.js"></script>

</html>
