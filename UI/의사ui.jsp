<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Medical Dashboard</title>
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

header {
	width: 100%;
	background-color: #b8edb5;
	padding: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.header {
	background-color: #f0f0f0;
	padding: 10px;
	margin-bottom: 20px;
}

.logo img {
	left: 10px;
	position: absolute;
	width: 250px;
	/* Adjust width as needed */
	height: auto;
	/* Maintain aspect ratio */
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
	/* Make this the positioning context */
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
	/* Space between color indicator and text */
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
}

.content {
	flex: 1;
	padding: 10px;
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	display: grid;
	grid-template-areas: "patient-info symptoms view" "history status view"
		"diagnosis diagnosis diagnosis" "search prescriptions prescriptions";
	grid-gap: 20px;
	grid-template-columns: 1fr 1fr 2fr;
	grid-template-rows: auto auto auto 1fr;
}

.sidebar {
	grid-area: sidebar;
}

.section {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	overflow-y: auto;
	max-height: 430px;
}

.section h2 {
	margin-top: 0;
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

.view {
	grid-area: view;
	display: flex;
	flex-wrap: wrap;
	height: 100%;
	gap: 10px;
}

.view div {
	flex: 1 1 calc(50% - 10px);
	height: calc(100%/ 2 - 10px);
	background-color: #ddd;
	padding-top: 30px;
}

.status {
	grid-area: status;
}

.diagnosis {
	grid-area: diagnosis;
	grid-column: span 3;
}

.search {
	grid-area: search;
}

.prescriptions {
	grid-area: prescriptions;
	grid-column: span 2;
}

.table {
	width: 100%;
	border-collapse: collapse;
}

.table th, .table td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

footer {
	display: flex;
	justify-content: space-between;
	padding: 20px;
	border-top: 1px solid #ddd;
	background-color: #f8f8f8;
}

.footer-left, .footer-right {
	width: 50%;
}

.appointment-list ul, .patient-list ul, .patient-management ul {
	list-style: none;
	padding: 0;
}

.tab-buttons {
	display: flex;
	margin-bottom: 20px;
}

.tab-buttons .tab {
	flex: 1;
	padding: 10px;
	text-align: center;
	cursor: pointer;
	background-color: #f0f0f0;
	border: 1px solid #ddd;
	transition: background-color 0.3s, border 0.3s;
}

.tab-buttons .tab.active {
	background-color: #ffffff;
	border-bottom: none;
}
/* 달력 스타일링 */
#calendar {
	max-width: 220px;
	height: 362px; /* 원하는 높이로 설정 */
	font-size: 0.6em; /* 글자 크기 줄이기 */
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
	<header>
		<div class="logo">
			<img src="Img/Logo.png" alt="Logo">
		</div>
		<nav>
			<button id="messages-btn" class="nav-btn">Message</button>
			<button id="chat-ai-btn" class="nav-btn">CHAT AI</button>
			<div class="profile-info">
				<img id="profile-image" src="doctorProfile.png" alt="Profile Image">
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
			<div class="search-section">
				<input type="text" placeholder="환자검색">
				<button>검색</button>
				<button>새로고침</button>
			</div>
			<div class="patient-list" id="all-patients">
				<h2>진료 대기 목록</h2>
				<ul>
					<li>환자1</li>
					<li>환자2</li>
				</ul>
			</div>
			<div class="patient-list" id="managed-patients"
				style="display: none;">
				<h2>진료 완료 목록</h2>
				<ul>
					<li>환자 A</li>
					<li>환자 B</li>
				</ul>
			</div>
			<div id='calendar'></div>
		</section>
		<section class="content">
			<div class="section patient-info">
				<h2>환자 정보</h2>
				<p>이름: 홍길동</p>
				<p>생년월일: 1980-01-01</p>
				<p>내원일: 2024-07-01</p>
				<p>알레르기: 페니실린</p>
				<p>흡연여부: 비흡연</p>
			</div>
			<div class="section history">
				<h2>과거 진료 이력</h2>
				<table class="table">
					<thead>
						<tr>
							<th>진료 날짜</th>
							<th>담당 의사</th>
							<th>질병 코드</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>2024-07-01</td>
							<td>홍길동</td>
							<td>M1036</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="section status">
				<h2>상태</h2>
				<table class="table">
					<thead>
						<tr>
							<th>항목</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>혈압</td>
							<td>정상</td>
						</tr>
						<tr>
							<td>체온</td>
							<td>정상</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="section symptoms">
				<h2>증상</h2>
				<p>2024-07-31</p>
				<p>c/c ankle pain</p>
				<p>9/30 부터 발목통이 시작</p>
			</div>
			<div class="section diagnosis" style="grid-column: span 3;">
				<h2>상병</h2>
				<p>상병 정보가 여기에 표시됩니다.</p>
			</div>
			<div class="section search">
				<h2>약품 검색</h2>
				<input type="text" placeholder="약품명">
				<button>검색</button>
			</div>
			<div class="section prescriptions" style="grid-column: span 2;">
				<h2>처방</h2>
				<table class="table">
					<thead>
						<tr>
							<th>처방의약품 명칭</th>
							<th>1회 투여량</th>
							<th>1회 투여횟수</th>
							<th>총 투여 일수</th>
							<th>용법</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>약물 A</td>
							<td>100mg</td>
							<td>1회</td>
							<td>7일</td>
							<td>하루 3번 식후 30분</td>
						</tr>
						<tr>
							<td>약물 B</td>
							<td>5mg</td>
							<td>2회</td>
							<td>7일</td>
							<td>하루 2번 아침, 저녁</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="section view" style="grid-row: span 2;">
				<div>이미지뷰</div>
				<div>이미지뷰</div>
				<div>이미지뷰</div>
				<div>이미지뷰</div>
			</div>
		</section>
	</main>
	<footer>
		<div class="footer-left">
			<div class="upcoming-events">
				<h2>일정</h2>
				<p>3개월 일정</p>
			</div>
		</div>
		<div class="footer-right">
			<div class="appointment-list">
				<h2>예약 대기자</h2>
				<ul>
					<li>환자 C</li>
					<li>환자 D</li>
				</ul>
			</div>
		</div>
	</footer>
	<script>
		function showAllPatients() {
			document.getElementById('tab-all-patients').classList.add('active');
			document.getElementById('tab-managed-patients').classList
					.remove('active');
			document.getElementById('all-patients').style.display = 'block';
			document.getElementById('managed-patients').style.display = 'none';
		}

		function showManagedPatients() {
			document.getElementById('tab-all-patients').classList
					.remove('active');
			document.getElementById('tab-managed-patients').classList
					.add('active');
			document.getElementById('all-patients').style.display = 'none';
			document.getElementById('managed-patients').style.display = 'block';
		}

		document
				.getElementById('profile-image')
				.addEventListener(
						'click',
						function(event) {
							var dropdown = document
									.querySelector('.dropdown-menu');
							dropdown.style.display = dropdown.style.display === 'block' ? 'none'
									: 'block';
							event.stopPropagation();
							// 이벤트 버블링 방지
						});

		// 클릭 이외의 부분을 클릭했을 때 메뉴가 사라지도록 처리
		document.addEventListener('click', function(event) {
			var dropdown = document.querySelector('.dropdown-menu');
			if (!event.target.matches('#profile-image')
					&& !dropdown.contains(event.target)) {
				dropdown.style.display = 'none';
			}
		});

		function setStatus(status, color) {
			document.querySelector('.status-indicator').style.backgroundColor = color;
		}

		document.getElementById('tab-all-patients').addEventListener('click',
				function() {
					setActiveTab('all-patients-info', 'tab-all-patients');
				});

		document.getElementById('tab-managed-patients').addEventListener(
				'click',
				function() {
					setActiveTab('managed-patients-info',
							'tab-managed-patients');
				});

		function setActiveTab(infoId, tabId) {
			document.querySelectorAll('.info').forEach(function(info) {
				info.classList.remove('active');
			});
			document.getElementById(infoId).classList.add('active');
			ㅣ

			document.querySelectorAll('.tab').forEach(function(tab) {
				tab.classList.remove('active');
			});
			document.getElementById(tabId).classList.add('active');
		}
		document.addEventListener('DOMContentLoaded', function() {
			var calendarEl = document.getElementById('calendar');

			var calendar = new FullCalendar.Calendar(calendarEl, {
				initialView : 'dayGridMonth',
				locale : 'ko',
				headerToolbar : {
					left : 'prev,next today',
					center : 'title',
					right : 'dayGridMonth,timeGridWeek,timeGridDay'
				},
				dateClick : function(info) {
					alert('Date: ' + info.dateStr);
				},
				events : [ {
					title : 'All Day Event',
					start : '2023-08-01'
				}, {
					title : 'Long Event',
					start : '2023-08-07',
					end : '2023-08-10'
				}, ]
			});

			calendar.render();
		});
	</script>
</body>
</html>
