<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>직원 조회 및 수정</title>
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.css'
	rel='stylesheet' />
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.js'></script>
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

html, body {
	margin: 0;
	padding: 0;
	height: 100%;
	overflow-x: hidden;
	font-family: Arial, sans-serif;
	font-size: 14px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	background-color: white;
	border-radius: 5px;
	overflow: hidden;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	font-size: 12px;
}

th, td {
	padding: 8px 10px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #f2f2f2;
	color: #333;
	font-size: 12px;
}

tr:hover {
	background-color: #f5f5f5;
}

.modal {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: #fff;
	margin: 10% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 50%;
	border-radius: 10px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.close, .close-chat {
	color: #aaa;
	float: right;
	font-size: 24px;
	font-weight: bold;
	cursor: pointer;
}

.close:hover, .close:focus, .close-chat:hover, .close-chat:focus {
	color: black;
	text-decoration: none;
}

.emplWrite {
	width: 100%;
	padding: 8px;
	margin-bottom: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
	font-size: 12px;
}

.emplAdd {
	width: 100%;
	padding: 10px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	margin-top: 10px;
	transition: background-color 0.3s;
	font-size: 12px;
}

.emplAdd:hover {
	background-color: #45a049;
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
				<h2>직원 조회 및 수정</h2>
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
							<input type="hidden" id="employee-id" name="employeeId">
							<label for="name">이름:</label> <input type="text" id="name"
								name="name" class="emplWrite" required><br> <br>
							<label for="job-title">직급:</label> <select id="job-title"
								name="jobTitle" class="emplWrite"></select><br> <br> <label
								for="phone">전화번호:</label> <input type="text" id="phone"
								name="phone" class="emplWrite" required><br> <br>
							<label for="email">Email:</label> <input type="email" id="email"
								name="email" class="emplWrite" required><br> <br>
							<label for="password">패스워드:</label> <input type="text"
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

			</div>
		</section>
		<section class="sidebarR">
			<div class="Message">
				<div id="employee-table-message">
					<!-- 직원 정보가 여기에 동적으로 추가됩니다 -->
				</div>
			</div>
		</section>
		<!-- 1:1 채팅 모달 -->
		<div id="chatModal" class="modal">
			<div class="modal-content">
				<span class="close-chat">&times;</span>
				<h2>1:1 채팅</h2>
				<div id="chatHistory">
					<!-- 채팅 기록이 여기에 표시됩니다 -->
				</div>
				<textarea id="chatMessage" placeholder="메시지를 입력하세요..."></textarea>
				<button id="sendMessageButton">보내기</button>
			</div>
		</div>
	</main>
	<footer></footer>

	<script>
        // 닫기 버튼이 모든 모달에 작동하도록 설정
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.close').forEach(function(closeBtn) {
                closeBtn.addEventListener('click', closeModal);
            });

            document.querySelectorAll('.close-chat').forEach(function(closeChatBtn) {
                closeChatBtn.addEventListener('click', closeChatModal);
            });

            // 초기 직원 목록 불러오기
            searchEmployees();
            loadAllEmployees(); // 처음 로드된 상태의 직원 리스트를 유지

            // WebSocket 설정
            connectWebSocket();
        });

        // 직원 목록을 검색과 무관하게 유지
        function loadAllEmployees() {
            fetch('/admin/getEmployees')
                .then(response => response.json())
                .then(data => {
                    const messageContainer = document.getElementById('employee-table-message');
                    messageContainer.innerHTML = '';

                    if (Array.isArray(data)) {
                        data.forEach(employee => {
                            const employeeMessage = document.createElement('div');
                            employeeMessage.dataset.userId = employee.no;
                            employeeMessage.textContent = employee.name + " " + employee.position + " " + employee.activeStatus;

                            // 이름 클릭 시 채팅 모달 열기
                            employeeMessage.addEventListener('click', function() {
                                openChatModal(employee.name);
                            });

                            messageContainer.appendChild(employeeMessage);
                        });
                    } else {
                        console.error('Expected array but got:', data);
                    }
                })
                .catch(error => console.error('Error fetching employee data:', error));
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

            fetch('/admin/searchEmployees?' + params.toString())
                .then(response => response.json())
                .then(data => {
                    const tableBody = document.getElementById('employee-table-body');
                    tableBody.innerHTML = '';

                    if (Array.isArray(data)) {
                        data.forEach(employee => {
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

        // 직원 정보를 수정할 모달 창을 여는 함수
        function openModal(employee) {
            const modal = document.getElementById('employeeModal');
            modal.style.display = "block";

            document.getElementById('employee-id').value = employee.no;
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

        // 모달 창을 닫는 함수
        function closeModal() {
            const modal = document.getElementById('employeeModal');
            modal.style.display = "none";
        }

        // 직원 이름 클릭 시 1:1 채팅 모달 열기
        function openChatModal(employeeName) {
            const chatModal = document.getElementById('chatModal');
            chatModal.style.display = "block";

            document.getElementById('chatHistory').innerHTML = '';
            document.getElementById('chatMessage').value = '';

            stompClient.subscribe('/topic/chat/' + employeeName, function(chatMessage) {
                showChatMessage(JSON.parse(chatMessage.body));
            });

            document.getElementById('sendMessageButton').onclick = function() {
                sendMessage(employeeName);
            };
        }

        function showChatMessage(message) {
            const chatHistory = document.getElementById('chatHistory');
            const messageElement = document.createElement('div');
            messageElement.textContent = message.sender + ": " + message.content;
            chatHistory.appendChild(messageElement);
        }

        function sendMessage(employeeName) {
            const messageContent = document.getElementById('chatMessage').value.trim();
            if (messageContent) {
                const chatMessage = {
                    sender: '현재 사용자',
                    content: messageContent
                };
                stompClient.send("/app/chat/" + employeeName, {}, JSON.stringify(chatMessage));
                document.getElementById('chatMessage').value = '';
            }
        }

        function closeChatModal() {
            const chatModal = document.getElementById('chatModal');
            chatModal.style.display = "none";
        }

        // WebSocket 연결 설정
        var stompClient = null;
        function connectWebSocket() {
            const socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                console.log('Connected: ' + frame);

                stompClient.subscribe('/topic/status', function(statusUpdate) {
                    updateEmployeeStatus(JSON.parse(statusUpdate.body));
                });
            });
        }

        function updateEmployeeStatus(status) {
            const employeeMessages = document.getElementById('employee-table-message');
            const employeeDivs = employeeMessages.getElementsByTagName('div');

            for (let i = 0; i < employeeDivs.length; i++) {
                const employeeDiv = employeeDivs[i];
                if (employeeDiv.dataset.userId === status.userId) {
                    employeeDiv.innerHTML = status.userId + " " + status.position + " " + status.status;
                    break;
                }
            }
        }
    </script>
</body>
</html>