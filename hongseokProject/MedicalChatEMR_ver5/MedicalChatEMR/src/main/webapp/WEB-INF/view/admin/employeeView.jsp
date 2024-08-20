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
	<form id="search-form"
		onsubmit="event.preventDefault(); searchEmployees();">
		<div class="search-container">
			<label for="search-name">이름:</label> <input type="text"
				id="search-name"> <label for="search-job">직업군:</label> <select
				id="search-job" onchange="updatePositionOptions()">
				<option value="">전체</option>
				<option value="doctor">의사</option>
				<option value="nurse">간호사</option>
			</select> <label for="search-position">직급:</label> <select
				id="search-position">
				<option value="">전체</option>
			</select>
			<button type="submit">검색</button>
		</div>
	</form>

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
			<form id="employeeForm" method="post"
				onsubmit="updateEmployee(event)">
				<input type="hidden" id="employee-id" name="employeeId"> <label
					for="name">이름:</label> <input type="text" id="name" name="name"
					class="emplWrite" required><br> <br> <label
					for="job-title">직급:</label> <select id="job-title" name="jobTitle"
					class="emplWrite"></select><br> <br> <label for="phone">전화번호:</label>
				<input type="text" id="phone" name="phone" class="emplWrite"
					required><br> <br> <label for="email">Email:</label>
				<input type="email" id="email" name="email" class="emplWrite"
					required><br> <br> <label for="password">패스워드:</label>
				<input type="text" id="password" name="password" class="emplWrite"><br>
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
        // 직급 옵션을 업데이트하는 함수
        function updatePositionOptions() {
            const job = document.getElementById('search-job').value;
            const positionSelect = document.getElementById('search-position');
            positionSelect.innerHTML = ''; // 기존 옵션 제거

            if (job == 'doctor') {
                positionSelect.innerHTML = `
                    <option value="">전체</option>
                    <option value="인턴">인턴</option>
                    <option value="레지던트">레지던트</option>
                    <option value="전문의">전문의</option>
                    <option value="교수">교수</option>
                    <option value="퇴직">퇴직</option>
                `;
            } else if (job == 'nurse') {
                positionSelect.innerHTML = `
                    <option value="">전체</option>
                    <option value="N">간호사</option>
					<option value="H">수간호사</option>
                    <option value="퇴직">퇴직</option>
                `;
            } else {
                positionSelect.innerHTML = '<option value="">전체</option>'; // 전체 선택 시 초기화
            }
        }
        
        // 직원 검색을 수행하는 함수
       function searchEmployees() {
    const name = document.getElementById('search-name').value;
    const job = document.getElementById('search-job').value;
    const position = document.getElementById('search-position').value;

    const params = new URLSearchParams();
    if (name) params.append('name', name);
    if (job && job !== "전체") params.append('job', job);
    if (position) params.append('position', position);

    fetch('/searchEmployees?' + params.toString())
        .then(response => response.json())
        .then(data => {
            console.log("Received data:", data); // 데이터 로그 확인

            if (Array.isArray(data)) {
                const tableBody = document.getElementById('employee-table-body');
                tableBody.innerHTML = ''; // 기존의 테이블 초기화

                data.forEach((employee, index) => {
                    console.log("Processing employee:", employee); // 각 직원 정보 로그 확인

                    const row = document.createElement('tr');

                    const noCell = document.createElement('td');
                    noCell.textContent = employee.no || '';
                    row.appendChild(noCell);

                    const nameCell = document.createElement('td');
                    const nameLink = document.createElement('a');
                    nameLink.href = "javascript:void(0);";
                    nameLink.onclick = () => openModal(employee);
                    nameLink.textContent = employee.name || '';
                    nameCell.appendChild(nameLink);
                    row.appendChild(nameCell);

                    const jobCell = document.createElement('td');
                    jobCell.textContent = employee.job === 'doctor' ? '의사' : '간호사';
                    row.appendChild(jobCell);

                    const positionCell = document.createElement('td');
                    positionCell.textContent = employee.position || '';
                    row.appendChild(positionCell);

                    const securityNumCell = document.createElement('td');
                    securityNumCell.textContent = employee.securityNum || '';
                    row.appendChild(securityNumCell);

                    const emailCell = document.createElement('td');
                    emailCell.textContent = employee.email || '';
                    row.appendChild(emailCell);

                    const phoneCell = document.createElement('td');
                    phoneCell.textContent = employee.phone || '';
                    row.appendChild(phoneCell);

                    const licenseIdCell = document.createElement('td');
                    licenseIdCell.textContent = employee.licenseId || '';
                    row.appendChild(licenseIdCell);

                    const passwordCell = document.createElement('td');
                    passwordCell.textContent = employee.password || '';
                    row.appendChild(passwordCell);

                    const departmentIdCell = document.createElement('td');
                    departmentIdCell.textContent = employee.departmentId || '';
                    row.appendChild(departmentIdCell);

                    const activeStatusCell = document.createElement('td');
                    activeStatusCell.textContent = employee.activeStatus || '';
                    row.appendChild(activeStatusCell);

                    tableBody.appendChild(row); // 테이블에 행 추가
                });
            } else {
                console.error('Expected array but got:', data);
            }
        })
        .catch(error => console.error('Error fetching employee data:', error));
}

        // 직원 정보를 수정할 모달 창을 여는 함수
        function openModal(employee) {
	    const modal = document.getElementById('employeeModal');
	    modal.style.display = "block";
	
	    // 기본 정보 설정
	    document.getElementById('employee-id').value = employee.id;
	    document.getElementById('name').value = employee.name;
	    document.getElementById('phone').value = employee.phone;
	    document.getElementById('email').value = employee.email;
	    document.getElementById('password').value = employee.password;
	
	    // 직업군에 따라 직급 선택 박스 업데이트
	    const jobTitleSelect = document.getElementById('job-title');
	    jobTitleSelect.innerHTML = ''; // 기존 옵션 초기화
	
	    if (employee.job == 'doctor') {
	        document.querySelector('.doctor-field').style.display = 'block';
	        document.getElementById('department').value = employee.departmentId;
	
	        // 의사 직급 옵션 설정
	        jobTitleSelect.innerHTML = `
	            <option value="인턴">인턴</option>
	            <option value="레지던트">레지던트</option>
	            <option value="전문의">전문의</option>
	            <option value="교수">교수</option>
	            <option value="퇴직">퇴직</option>
	        `;
	    } else if (employee.job == 'nurse') {
	        document.querySelector('.doctor-field').style.display = 'none';
	
	        // 간호사 직급 옵션 설정
	        jobTitleSelect.innerHTML = `
	            <option value="N">간호사</option>
	            <option value="H">수간호사</option>
	            <option value="퇴직">퇴직</option>
	        `;
	    }

    // 현재 직원의 직급 선택
    jobTitleSelect.value = employee.position;
}


        // 모달 창을 닫는 함수
        function closeModal() {
            const modal = document.getElementById('employeeModal');
            modal.style.display = "none";
        }

        // 직원 정보를 업데이트하는 함수
        function updateEmployee(event) {
            event.preventDefault();

            const formData = new FormData(document.getElementById('employeeForm'));
      			fetch('/updateEmployee', {
			    method: 'POST',
			    body: formData
			})
			.then(response => {
			    if (!response.ok) {
			        console.error('Server responded with status:', response.status, response.statusText);
			        throw new Error('Network response was not ok');
			    }
			    return response.text();
			})
			.then(data => {
			    alert('수정이 완료되었습니다.');
			    closeModal();
			    searchEmployees(); // 수정 후 목록 갱신
			})
			.catch(error => {
			    console.error('Error updating employee data:', error);
			    alert('수정 중 오류가 발생했습니다.');
			});
        }

        document.addEventListener('DOMContentLoaded', function() {
            searchEmployees(); // 페이지 로드 시 직원 목록 초기 로드
            
            document.querySelector('.close').addEventListener('click', closeModal);
        });
    </script>
</body>
</html>
