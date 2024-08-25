<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>병원장 페이지</title>
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.css'
	rel='stylesheet' />
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.js'></script>
<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!--비활동 함수-->
<script src="/js/common/activity-tracker.js"></script>
<style>
html, body {
	margin: 0;
	padding: 0;
	height: 100%;
	overflow-x: hidden;
	font-family: Arial, sans-serif;
}

body {
	display: flex;
	flex-direction: column;
}

.adminhd {
	background-color: #b8edb5;
	color: black;
	padding: 10px 0;
	position: relative;
	z-index: 1000;
}

.adminhd .settingnavbar {
	list-style-type: none;
	margin: 0;
	padding: 0;
	display: flex;
	justify-content: center;
}

.adminhd .settingnavbar li {
	display: inline-block;
	list-style: none;
	margin: 0 15px;
	padding: 0;
	position: relative;
}

.adminhd .settingnavbar a {
	display: block;
	color: black;
	text-align: center;
	padding: 14px 20px;
	text-decoration: none;
}

.adminhd .settingnavbar li:hover {
	background-color: #a3d9a5;
}

.dropdown-content {
	display: none;
	position: absolute;
	background-color: #fff;
	min-width: 160px;
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
	z-index: 1000;
}

.dropdown-content a {
	color: black;
	padding: 12px 16px;
	text-decoration: none;
	display: block;
	text-align: left;
}

.dropdown-content a:hover {
	background-color: #ddd;
}

.dropdown:hover .dropdown-content {
	display: block;
}

.adminhd li a, .dropbtn {
	display: inline-block;
	color: black;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

.container {
	display: flex;
	flex: 1;
}

aside {
	width: 250px;
	background-color: #f0f0f0;
	padding: 20px;
	box-sizing: border-box;
	border-right: 1px solid black;
}

aside div {
	margin-bottom: 20px;
}

main {
	display: flex;
	flex: 1;
	padding: 20px;
	justify-content: center;
	position: relative;
	z-index: 1;
}

.sidebarL {
	width: 250px;
	background-color: #f0f0f0;
	padding: 10px;
	padding-top: 20px;
	border-right: 1px solid #ddd;
	box-sizing: border-box;
}

.sidebarR {
	width: 250px;
	background-color: #f0f0f0;
	padding: 10px;
	padding-top: 20px;
	border-left: 1px solid #ddd;
	box-sizing: border-box;
}

.content {
	flex-grow: 1;
	padding: 20px;
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	box-sizing: border-box;
	display: flex;
	justify-content: center;
	align-items: center;
}

header {
	width: 100%;
	background-color: #b8edb5;
	padding: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.logo img {
	left: 10px;
	position: absolute;
	width: 250px;
	height: auto;
}

nav {
	display: flex;
	align-items: center;
	justify-content: flex-end;
	flex: 1;
}

.nav-btn {
	margin: 0 5px;
	padding: 5px 10px;
	background-color: white;
	border: 1px solid transparent;
	border-radius: 8px;
	cursor: pointer;
	font-size: 14px;
	transition: background-color 0.3s, border 0.3s;
}

.nav-btn:hover {
	border: 1px solid #ccc;
}

.logout-btn {
	margin-bottom: -50px;
	font-size: 12px;
	cursor: pointer;
	background-color: white;
	border: 1px solid transparent;
	border-radius: 3px;
}

.logout-btn:hover {
	background-color: #e2deded8;
}

.dropdown-menu {
	display: none;
	width: 130px;
	position: absolute;
	background-color: white;
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	top: 65px;
	right: 35px;
}

.dropdown-menu a {
	display: block;
	padding: 8px 16px;
	text-decoration: none;
	color: black;
	border-bottom: 1px solid #ddd;
}

.dropdown-menu a:last-child {
	border-bottom: none;
}

.dropdown-menu a:hover {
	background-color: #f4f4f4;
}

.color-indicator {
	display: inline-block;
	width: 10px;
	height: 10px;
	border-radius: 50%;
	margin-right: 8px;
}

.section {
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	overflow-y: auto;
	max-height: 430px;
}

.section h2 {
	margin-top: 0;
}

#calendar {
	max-width: 220px;
	height: 362px;
	font-size: 0.6em;
}

.fc-header-toolbar {
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
}

.fc-toolbar-chunk {
	margin: 2px 0;
}

.fc-daygrid-day {
	height: 1em;
}

.fc-scroller-harness {
	overflow: auto;
}
</style>
</head>
<body>
	<header class="adminhd">
		<div class="logo">
			<a href="/admin/main"><img src="/img/Logo.png" alt="Logo"></a>
		</div>
		<nav>
			<ul class="settingnavbar">
				<li class="dropdown"><a href="javascript:void(0)"
					class="dropbtn">인적관리</a>
					<div class="dropdown-content">
						<a href="/admin/employeeCreate">직원 생성</a> <a
							href="/admin/employeeView">직원 조회/수정/퇴사</a>
					</div></li>
				<li class="dropdown"><a href="javascript:void(0)"
					class="dropbtn" onclick="loadContent('/admin/medicalView')">진료조회</a></li>
			</ul>
		</nav>
	</header>
	<main class="container">
		<section class="sidebarL">
			<div id='calendar'></div>
		</section>
		<section class="content" id="content">
			<div class="board">
				<p>메인 보드 입니다.</p>
			</div>
		</section>
		<section class="sidebarR">
			<div class="Message">
				<p>이곳에 메시지를 추가하세요.</p>
			</div>
		</section>
	</main>
	<footer></footer>
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            if (calendarEl) {
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    locale: 'ko',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    },
                    dateClick: function(info) {
                        alert('Date: ' + info.dateStr);
                    },
                    events: [
                        {
                            title: 'All Day Event',
                            start: '2023-08-01'
                        },
                        {
                            title: 'Long Event',
                            start: '2023-08-07',
                            end: '2023-08-10'
                        }
                    ]
                });

                calendar.render();
            } else {
                console.error('Calendar element not found');
            }
        });
    
        <!-- function loadContent(url) {
            fetch(url)
                .then(response => response.text())
                .then(data => {
                    const board = document.querySelector('.board');
                    board.innerHTML = data;

                    // URL에 따라 추가 스크립트 실행
                    if (url.includes('employeeCreate')) {
                        function validateAndSubmit(event) {
                            event.preventDefault();

                            const ssn = document.getElementById("birthdate").value;
                            const phone = document.getElementById("phone").value;
                            const email = document.getElementById("email").value;
                            const name = document.getElementById("name").value;
                            const department = document.getElementById("department").value;

                            if (!validateName(name)) {
                                alert("이름을 입력해 주세요.");
                                return;
                            }

                            if (!validateEmail(email)) {
                                alert("이메일 형식이 잘못되었습니다. 올바른 형식: example@example.com");
                                return;
                            }

                            if (!validateSSN(ssn)) {
                                alert("주민번호 형식이 잘못되었습니다. 올바른 형식: 123456-1234567");
                                return;
                            }

                            if (!validatePhone(phone)) {
                                alert("전화번호 형식이 잘못되었습니다. 올바른 형식: 010-1234-5678");
                                return;
                            }

                            if (!validateDepartment(department)) {
                                alert("부서를 선택해 주세요.");
                                return;
                            }

                            checkSSNInDatabase(ssn, function(isValid) {
                                if (!isValid) {
                                    alert("이미 존재하는 주민번호입니다.");
                                    return;
                                }
                                submitForm();
                            });
                        }

                        function validateName(name) {
                            return name.trim() !== "";
                        }

                        function validateEmail(email) {
                            const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
                            return emailPattern.test(email);
                        }

                        function validateSSN(ssn) {
                            const ssnPattern = /^\d{6}-\d{7}$/;
                            return ssnPattern.test(ssn);
                        }

                        function validatePhone(phone) {
                            const phonePattern = /^\d{3}-\d{4}-\d{4}$/;
                            return phonePattern.test(phone);
                        }

                        function validateDepartment(department) {
                            return department !== "";
                        }

                        function checkSSNInDatabase(ssn, callback) {
                            fetch('/admin/checkDuplicateSSN', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({ ssn: ssn })
                            })
                            .then(response => response.json())
                            .then(data => {
                                callback(!data.duplicate);
                            })
                            .catch(error => {
                                console.error('Error checking SSN:', error);
                                callback(false);
                            });
                        }

                        function submitForm() {
                            const form = document.querySelector("form");
                            const job = document.querySelector('input[name="job"]:checked');
                            
                            if (!job) {
                                alert('직업을 선택해 주세요.');
                                return;
                            }

                            const actionUrl = job.value == "doctor" ? "/admin/doctorCreate" : "/admin/nurseCreate";

                            const formData = new FormData(form);
                            fetch(actionUrl, {
                                method: 'POST',
                                body: formData
                            })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('네트워크 응답이 정상이 아닙니다.');
                                }
                                return response.text();
                            })
                            .then(data => {
                                alert(data); 
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('직원 추가 중 오류가 발생했습니다.');
                            });
                        }

                        document.getElementById('birthdate').addEventListener('input', function() {
                            let value = this.value.replace(/[^0-9]/g, '');

                            if (value.length > 6) {
                                this.value = value.slice(0, 6) + '-' + value.slice(6, 13);
                            } else {
                                this.value = value;
                            }
                        });

                        document.getElementById('birthdate').addEventListener('blur', function() {
                            const ssn = this.value;
                            if (ssn.length == 14) {
                                checkDuplicateSSN(ssn);
                            }
                        });

                        function checkDuplicateSSN(ssn) {
                            fetch('/admin/checkDuplicateSSN', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({ ssn: ssn })
                            })
                            .then(response => response.json())
                            .then(data => {
                                if (data.duplicate) {
                                    alert('이미 존재하는 주민번호입니다.');
                                    document.getElementById('birthdate').value = '';
                                }
                            })
                            .catch(error => {
                                console.error('Error checking SSN:', error);
                                alert('주민번호 중복 확인 중 오류가 발생했습니다.');
                            });
                        }

                        function initializeFormScripts() {
                            function updateJobTitleOptions() {
                                const jobElement = document.querySelector('input[name="job"]:checked');

                                if (jobElement) {
                                    const job = jobElement.value;

                                    if (job == "doctor") {
                                        document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'block');
                                        document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'none');
                                        document.getElementById('position-doctor').disabled = false;
                                        document.getElementById('position-doctor').style.display = 'block';
                                        document.getElementById('position-nurse').disabled = true;
                                        document.getElementById('position-nurse').style.display = 'none';
                                        
                                    } else if (job == "nurse") {
                                        document.querySelectorAll('.doctor-field').forEach(e => e.style.display = 'none');
                                        document.querySelectorAll('.nurse-field').forEach(e => e.style.display = 'block');
                                        document.getElementById('position-nurse').disabled = false;
                                        document.getElementById('position-nurse').style.display = 'block';
                                        document.getElementById('position-doctor').disabled = true;
                                        document.getElementById('position-doctor').style.display = 'none';
                                    }
                                } else {
                                    console.error("No job selected or radio buttons not loaded properly.");
                                }
                            }

                            const jobInputs = document.querySelectorAll('input[name="job"]');
                            jobInputs.forEach((elem) => {
                                elem.removeEventListener('change', updateJobTitleOptions);
                                elem.addEventListener('change', updateJobTitleOptions);
                            });

                            updateJobTitleOptions();

                            const form = document.querySelector("form");
                            if (form) {
                                form.removeEventListener('submit', handleFormSubmit);
                                form.addEventListener("submit", handleFormSubmit);
                            }
                        }

                        function handleFormSubmit(event) {
                            event.preventDefault();
                            const job = document.querySelector('input[name="job"]:checked');
                            if (!job) {
                                alert('직업을 선택해 주세요.');
                                return;
                            }
                            const actionUrl = job.value == "doctor" ? "/admin/doctorCreate" : "/admin/nurseCreate";

                            const formData = new FormData(event.target);
                            fetch(actionUrl, {
                                method: 'POST',
                                body: formData
                            })
                            .then(response => response.text())
                            .then(data => {
                                alert(data); 
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('직원 추가 중 오류가 발생했습니다.');
                            });
                        }

                        document.addEventListener('DOMContentLoaded', function() {
                            initializeFormScripts();
                        });
                    } else if (url.includes('employeeView')) {
                        function updatePositionOptions() {
                            const job = document.getElementById('search-job').value;
                            const positionSelect = document.getElementById('search-position');
                            positionSelect.innerHTML = '';

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
                                positionSelect.innerHTML = '<option value="">전체</option>';
                            }
                        }

                        function searchEmployees() {
                            const name = document.getElementById('search-name').value;
                            const job = document.getElementById('search-job').value;
                            const position = document.getElementById('search-position').value;

                            const params = new URLSearchParams();
                            if (name) params.append('name', name);
                            if (job && job !== "전체") params.append('job', job);
                            if (position) params.append('position', position);

                            fetch('/admin/searchEmployees?' + params.toString())
                                .then(response => response.json())
                                .then(data => {
                                    if (Array.isArray(data)) {
                                        const tableBody = document.getElementById('employee-table-body');
                                        tableBody.innerHTML = '';

                                        data.forEach((employee, index) => {
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
                                            jobCell.textContent = employee.job == 'doctor' ? '의사' : '간호사';
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

                                            tableBody.appendChild(row);
                                        });
                                    } else {
                                        console.error('Expected array but got:', data);
                                    }
                                })
                                .catch(error => console.error('Error fetching employee data:', error));
                        }

                        function openModal(employee) {
                            const modal = document.getElementById('employeeModal');
                            modal.style.display = "block";
                        
                            document.getElementById('employee-id').value = employee.id;
                            document.getElementById('name').value = employee.name;
                            document.getElementById('phone').value = employee.phone;
                            document.getElementById('email').value = employee.email;
                            document.getElementById('password').value = employee.password;
                        
                            const jobTitleSelect = document.getElementById('job-title');
                            jobTitleSelect.innerHTML = '';

                            if (employee.job == 'doctor') {
                                document.querySelector('.doctor-field').style.display = 'block';
                                document.getElementById('department').value = employee.departmentId;
                        
                                jobTitleSelect.innerHTML = `
                                    <option value="인턴">인턴</option>
                                    <option value="레지던트">레지던트</option>
                                    <option value="전문의">전문의</option>
                                    <option value="교수">교수</option>
                                    <option value="퇴직">퇴직</option>
                                `;
                            } else if (employee.job == 'nurse') {
                                document.querySelector('.doctor-field').style.display = 'none';
                        
                                jobTitleSelect.innerHTML = `
                                    <option value="N">간호사</option>
                                    <option value="H">수간호사</option>
                                    <option value="퇴직">퇴직</option>
                                `;
                            }

                            jobTitleSelect.value = employee.position;
                        }

                        function closeModal() {
                            const modal = document.getElementById('employeeModal');
                            modal.style.display = "none";
                        }

                        function updateEmployee(event) {
                            event.preventDefault();

                            const formData = new FormData(document.getElementById('employeeForm'));
                            fetch('/admin/updateEmployee', {
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
                                searchEmployees();
                            })
                            .catch(error => {
                                console.error('Error updating employee data:', error);
                                alert('수정 중 오류가 발생했습니다.');
                            });
                        }

                        document.addEventListener('DOMContentLoaded', function() {
                            searchEmployees();
                        });
                        document.querySelector('.close').addEventListener('click', closeModal);
                    } else if (url.includes('medicalView')) {
                        // 진료 조회 페이지 스크립트
                    }
                })
                .catch(error => console.error('Error fetching data:', error));
        }

        const EmployeeCreate = {
            handleFormSubmit: function(event) {
                event.preventDefault();
                alert("직원 생성이 처리되었습니다.");
            }
        };

        const EmployeeView = {
            handleFormSubmit: function(event) {
                event.preventDefault();
                alert("직원 조회/수정/퇴사가 처리되었습니다.");
            }
        };-->
    </script>

</body>
</html>