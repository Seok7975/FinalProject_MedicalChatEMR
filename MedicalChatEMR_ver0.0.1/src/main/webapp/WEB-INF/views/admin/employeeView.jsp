<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>직원 조회 및 수정</title>
<style>
.modal {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgb(0, 0, 0);
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fefefe;
	margin: 15% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 80%;
}

.close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.close:hover, .close:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}
</style>
</head>
<body>
	<h2>직원 조회 및 수정</h2>

	<!-- 검색 폼 -->
	<div class="search-container">
		<label for="search-name">이름:</label> <input type="text"
			id="search-name"> <label for="search-job">직업군:</label> <select
			id="search-job">
			<option value="">전체</option>
			<option value="doctor">의사</option>
			<option value="nurse">간호사</option>
		</select> <label for="search-position">직급:</label> <select id="search-position">
			<option value="">전체</option>
			<!-- 직급 옵션은 스크립트에서 동적으로 추가됩니다 -->
		</select>

		<button onclick="searchEmployees()">검색</button>
	</div>

	<!-- 직원 목록 -->
	<table border="1">
		<thead>
			<tr>
				<th>번호</th>
				<th>이름</th>
				<th>직업군</th>
				<th>직급</th>
				<th>주민등록번호</th>
				<th>이메일</th>
				<th>전화번호</th>
				<th>면허 번호</th>
				<th>패스워드</th>
				<th>소속 진료과</th>
				<th>활동 상태</th>
			</tr>
		</thead>
		<tbody id="employee-table-body">
			<!-- 직원 정보가 여기에 동적으로 추가됩니다 -->
		</tbody>
	</table>

	<!-- 직원 정보 수정 모달 -->
	<div id="employeeModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<h2>직원 정보 수정</h2>
			<form id="employeeForm" method="post">
				<input type="hidden" id="employee-id" name="employeeId"> <label
					for="name">이름:</label> <input type="text" id="name" name="name"
					class="emplWrite" required><br>
				<br> <label for="job-title">직급:</label> <select id="job-title"
					name="jobTitle" class="emplWrite"></select><br>
				<br> <label for="phone">전화번호:</label> <input type="text"
					id="phone" name="phone" class="emplWrite" required><br>
				<br> <label for="email">Email:</label> <input type="email"
					id="email" name="email" class="emplWrite" required><br>
				<br> <label for="password">패스워드:</label> <input type="text"
					id="password" name="password" class="emplWrite"><br>
				<br>

				<div class="doctor-field">
					<label for="department">부서:</label> <input type="text"
						id="department" name="department" class="emplWrite"><br>
					<br>
				</div>

				<button type="submit" class="emplAdd">수정 완료</button>
			</form>
		</div>
	</div>

	<script>
    document.addEventListener('DOMContentLoaded', function() {

        // 직원 검색 함수
        function searchEmployees() {
            // 검색 입력 필드에서 값 가져오기
            const name = document.getElementById('search-name').value;
            const job = document.getElementById('search-job').value;
            const position = document.getElementById('search-position').value;

            // URLSearchParams 객체를 사용하여 쿼리 파라미터 구성
            const params = new URLSearchParams();
            if (name) params.append('name', name); // 이름이 입력되었을 경우 쿼리 파라미터에 추가
            if (job && job !== "전체") params.append('job', job); // 직업군이 선택되었을 경우 쿼리 파라미터에 추가
            if (position) params.append('position', position); // 직급이 선택되었을 경우 쿼리 파라미터에 추가

            // fetch API를 사용하여 서버에 GET 요청 보내기
            fetch('/searchEmployees?' + params.toString())
                .then(response => response.json()) // 서버 응답을 JSON 형태로 파싱
                .then(data => {
                    // 테이블의 기존 내용을 지우기
                    const tableBody = document.getElementById('employee-table-body');
                    tableBody.innerHTML = '';

                    // 응답 데이터(직원 목록)를 테이블에 추가
                    data.forEach((employee, index) => {
                        const row = document.createElement('tr'); // 새로운 테이블 행 생성
                        row.innerHTML = `
                            <td>${index + 1}</td> <!-- 행 번호 -->
                            <td><a href="javascript:void(0);" onclick='openModal(${JSON.stringify(employee)})'>${employee.name}</a></td> <!-- 이름 -->
                            <td>${employee.job == 'doctor' ? '의사' : '간호사'}</td> <!-- 직업군 (의사 또는 간호사) -->
                            <td>${employee.position}</td> <!-- 직급 -->
                            <td>${employee.securityNum}</td> <!-- 주민등록번호 -->
                            <td>${employee.email}</td> <!-- 이메일 -->
                            <td>${employee.phone}</td> <!-- 전화번호 -->
                            <td>${employee.licenseId}</td> <!-- 면허 번호 -->
                            <td>${employee.password}</td> <!-- 패스워드 -->
                            <td>${employee.departmentId || ''}</td> <!-- 소속 진료과 -->
                            <td>${employee.activeStatus}</td> <!-- 활동 상태 -->
                        `;
                        tableBody.appendChild(row); // 테이블에 행 추가
                    });
                })
                .catch(error => console.error('Error fetching employee data:', error)); // 에러 처리
        }

            // 모달 창 열기
            function openModal(employee) {
                const modal = document.getElementById('employeeModal');
                modal.style.display = "block";

                document.getElementById('employee-id').value = employee.id;
                document.getElementById('name').value = employee.name;
                document.getElementById('job-title').value = employee.position;
                document.getElementById('phone').value = employee.phone;
                document.getElementById('email').value = employee.email;
                document.getElementById('password').value = employee.password;

                if (employee.job == 'doctor') {
                    document.querySelectorAll('.doctor-field').forEach(el => el.style.display = 'block');
                    document.getElementById('department').value = employee.departmentId;
                } else {
                    document.querySelectorAll('.doctor-field').forEach(el => el.style.display = 'none');
                }
            }

            // 모달 창 닫기
            document.querySelector('.close').addEventListener('click', function() {
                const modal = document.getElementById('employeeModal');
                modal.style.display = "none";
            });

            // 모달 외부 클릭 시 닫기
            window.onclick = function(event) {
                const modal = document.getElementById('employeeModal');
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }

            // 폼 제출 시 데이터 수정
            document.getElementById('employeeForm').addEventListener('submit', function(event) {
                event.preventDefault();
                const formData = new FormData(this);

                fetch('/updateEmployee', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(data => {
                    alert('수정이 완료되었습니다.');
                    const modal = document.getElementById('employeeModal');
                    modal.style.display = "none";
                    location.reload();  // 페이지 새로고침하여 변경 사항 반영
                })
                .catch(error => {
                    console.error('Error updating employee data:', error);
                    alert('수정 중 오류가 발생했습니다.');
                });
            });

            // 초기 로드 시 직원 목록 가져오기
            fetch('/getEmployees')
                .then(response => response.json())
                .then(data => {
                    const tableBody = document.getElementById('employee-table-body');
                    data.forEach((employee, index) => {
                        const row = document.createElement('tr');
                        row.innerHTML = `
                            <td>${index + 1}</td>
                            <td><a href="javascript:void(0);" onclick='openModal(${JSON.stringify(employee)})'>${employee.name}</a></td>
                            <td>${employee.job == 'doctor' ? '의사' : '간호사'}</td>
                            <td>${employee.position}</td>
                            <td>${employee.securityNum}</td>
                            <td>${employee.email}</td>
                            <td>${employee.phone}</td>
                            <td>${employee.licenseId}</td>
                            <td>${employee.password}</td>
                            <td>${employee.departmentId || ''}</td>
                            <td>${employee.activeStatus}</td>
                        `;
                        tableBody.appendChild(row);
                    });
                })
                .catch(error => console.error('Error fetching employee data:', error));
        });
    </script>
</body>
</html>
