<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nurse Dashboard</title>
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.css'
	rel='stylesheet' />
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.js'></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

header {
	width: 100%;
	background-color: #b8edb5;
	padding: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	margin-bottom: 8px;
}

.header {
	background-color: #f0f0f0;
	padding: 10px;
	margin-bottom: 20px;
}

.logo {
	display: flex;
	justify-content: flex-start;
	flex: 1;
}

.logo img {
	width: 15vw;
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

.profile-info {
	position: relative;
	display: flex;
	align-items: center;
	margin-right: 30px;
}

.status-indicator {
	position: absolute;
	bottom: 0;
	right: 75px;
	width: 14px;
	height: 14px;
	border-radius: 50%;
	background-color: #808080;
}

.profile-info img {
	width: 60px;
	height: 60px;
	margin: 0 15px;
	margin-left: 15px;
	margin-right: 10px;
	border-radius: 50%;
	object-fit: cover;
	cursor: pointer;
}

.dropdown-menu {
	display: none;
	width: 130px;
	position: absolute;
	background-color: white;
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
	z-index: 100;
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

.container {
	display: flex;
	flex: 1;
}

.sidebar {
	width: 20%;
	background-color: #f0f0f0;
	padding: 20px;
	border-right: 1px solid #ddd;
	box-sizing: border-box;
	margin-right: 8px;
}

.content {
	flex: 1;
	padding: 0px;
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	display: grid;
	grid-template-areas: "patient-info symptoms status" 
		"history diagnosis prescriptions" 
		"medicine medicine medicine";
	grid-gap: 8px;
	grid-template-columns: 1fr 1fr 1fr;
	grid-template-rows: auto auto auto 1fr;
}

.section {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	overflow-y: auto;
}

.section h2 {
	margin-top: 0;
	margin-bottom: 8px;
}

.patient-info {
	grid-area: patient-info;
}

.history {
	grid-area: history;
}

.symptoms {
	grid-area: symptoms;
}

.status {
	grid-area: status;
}

.diagnosis {
	grid-area: diagnosis;
}

.prescriptions {
	grid-area: prescriptions;
}

.medicine {
	grid-area: medicine;
}

.table {
	width: 100%;
	border-collapse: collapse;
}

.table th, .table td {
	border: 1px solid #ddd;
	padding: 4px;
	text-align: center;
}

.scrollable-patient-list {
    max-height: 250px;
    overflow-y: auto;
}

#calendar {
	max-width: 3000px;
	height: 400px;
	text-align: center;
	font-size: 0.6em;
	padding-left: 5px;
	padding-right: 5px;
	margin-top: 30px;
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
	height: 0.6em;
}

.fc-scroller-harness {
	overflow: auto;
}
</style>

</head>

<body>
	<header>
		<nav>
			<div class="logo">
				<img src="/Img/Logo.png" alt="Logo">
			</div>
			<button id="messages-btn" class="nav-btn">Message</button>
			<button id="chat-ai-btn" class="nav-btn">CHAT AI</button>
			<div class="profile-info">
				<img id="profile-image" src="nurseProfile.png" alt="Profile Image">
				<div class="status-indicator"></div>
				<button id="logout-btn" class="logout-btn">Log Out</button>
				<div class="dropdown-menu">
					<a href="#" class="status-link"
						onclick="setStatus('away', '#808080')"> <span
						class="color-indicator" style="background-color: #808080;"></span>자리
						비움
					</a> <a href="#" class="status-link"
						onclick="setStatus('available', '#008000')"> <span
						class="color-indicator" style="background-color: #008000;"></span>진료중
					</a> <a href="#" class="status-link"
						onclick="setStatus('lunch', '#FFA500')"> <span
						class="color-indicator" style="background-color: #FFA500;"></span>점심시간
					</a>
				</div>
			</div>
		</nav>
	</header>

	<main class="container">
		<section class="sidebar">
			<div class="tab-buttons">
				<div class="tab active" id="tab-all-patients"
					onclick="showAllPatients()">대기 환자</div>
				<div class="tab" id="tab-managed-patients"
					onclick="showManagedPatients()">완료 환자</div>
			</div>
			<div class="scrollable-patient-list">
				<h2>진료 대기 목록</h2>
				<ul id="all-patients">
					<li>환자1</li>
					<li>환자2</li>
					<li>환자3</li>
				</ul>
			</div>
			<div class="scrollable-patient-list" id="managed-patients" style="display:none;">
				<h2>진료 완료 목록</h2>
				<ul>
					<li>환자 A</li>
					<li>환자 B</li>
				</ul>
			</div>
			<div id='calendar'></div>
		</section>

		<section class="content">
			<!-- 환자 정보 -->
			<div class="section patient-info">
				<h2>환자 정보</h2>
				<table class="table">
					<tr>
						<th>환자 ID</th>
						<td>12345</td>
						<th>이름</th>
						<td>홍길동</td>
						<th>생년월일</th>
						<td>1980-01-01</td>
						<th>성별</th>
						<td>남성</td>
					</tr>
					<tr>
						<th>혈액형</th>
						<td>A+</td>
						<th>키</th>
						<td>175cm</td>
						<th>체중</th>
						<td>70kg</td>
						<th>흡연 여부</th>
						<td>비흡연</td>
					</tr>
					<tr>
						<th>알레르기</th>
						<td>페니실린</td>
						<th>주소</th>
						<td colspan="5">서울시 강남구</td>
					</tr>
				</table>
			</div>

			<!-- 진료 기록 -->
			<div class="section history">
				<h2>진료 기록</h2>
				<table class="table">
					<thead>
						<tr>
							<th>날짜</th>
							<th>진단</th>
							<th>처방</th>
							<th>담당의</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>2024-07-15</td>
							<td>감기</td>
							<td>해열제, 항생제</td>
							<td>김의사</td>
						</tr>
						<tr>
							<td>2024-06-01</td>
							<td>고혈압</td>
							<td>혈압약</td>
							<td>이의사</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 증상 -->
			<div class="section symptoms">
				<h2>증상</h2>
				<p>두통과 어지러움</p>
			</div>

			<!-- 상태 -->
			<div class="section status">
				<h2>상태</h2>
				<table class="table">
					<thead>
						<tr>
							<th>검사 항목</th>
							<th>결과</th>
							<th>정상 범위</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>혈압</td>
							<td>130/85 mmHg</td>
							<td>120/80 mmHg 이하</td>
						</tr>
						<tr>
							<td>콜레스테롤</td>
							<td>190 mg/dL</td>
							<td>200 mg/dL 이하</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 상병 -->
			<div class="section diagnosis">
				<h2>질병</h2>
				<table class="table">
					<thead>
						<tr>
							<th>질병 코드</th>
							<th>질병 명칭</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>M1036</td>
							<td>만성두통</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 처방 -->
			<div class="section prescriptions">
				<h2>처방</h2>
				<table class="table">
					<thead>
						<tr>
							<th>약품 코드</th>
							<th>업체명</th>
							<th>약품명</th>
							<th>복용법</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>A00123</td>
							<td>제약사</td>
							<td>타이레놀</td>
							<td>1회 500mg 1일 2회</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 투약 정보 -->
			<div class="section medicine">
				<h2>투약 정보</h2>
				<table class="table">
					<thead>
						<tr>
							<th>성분코드</th>
							<th>성분명(한글)</th>
							<th>제형명</th>
							<th>투여경로</th>
							<th>투여 단위</th>
							<th>1일 최대 투여량</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>B12345</td>
							<td>아스피린</td>
							<td>정제</td>
							<td>경구</td>
							<td>500mg</td>
							<td>1일 2회</td>
						</tr>
					</tbody>
				</table>
			</div>
		</section>
	</main>

	<script>
		// 탭 전환
		function showAllPatients() {
			document.getElementById('tab-all-patients').classList.add('active');
			document.getElementById('tab-managed-patients').classList.remove('active');
			document.getElementById('all-patients').style.display = 'block';
			document.getElementById('managed-patients').style.display = 'none';
		}

		function showManagedPatients() {
			document.getElementById('tab-all-patients').classList.remove('active');
			document.getElementById('tab-managed-patients').classList.add('active');
			document.getElementById('all-patients').style.display = 'none';
			document.getElementById('managed-patients').style.display = 'block';
		}

		// 달력 API 함수
		document.addEventListener('DOMContentLoaded', function() {
			var calendarEl = document.getElementById('calendar');

			var calendar = new FullCalendar.Calendar(calendarEl, {
				initialView: 'dayGridMonth',
				locale: 'ko',
				headerToolbar: {
					left: 'prev,next today',
					center: 'title',
					right: 'dayGridMonth,timeGridWeek,timeGridDay'
				},
				dayCellContent: function(e) {
					e.dayNumberText = e.dayNumberText.replace('일', ''); // '일' 문자 제거
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
		});
	</script>
</body>
</html>
