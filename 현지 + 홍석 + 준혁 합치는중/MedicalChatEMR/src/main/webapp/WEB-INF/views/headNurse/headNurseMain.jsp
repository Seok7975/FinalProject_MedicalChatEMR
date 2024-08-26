<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Medical Chat EMR</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 20px;
	position: relative;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.logo {
	position: absolute;
	left: 10px;
	font-weight: bold;
	font-size: 20px;
}

nav {
	display: flex;
	align-items: center;
	justify-content: center;
	flex: 1;
}

.nav-logo {
	height: auto; /* 네비게이션 바 높이에 맞게 조정 */
	width: 250px; /* 가로 비율 자동 조정 */
	vertical-align: middle; /* 세로 중앙 정렬 */
}

.nav-btn {
	margin: 0 15px;
	padding: 8px 16px;
	background-color: white;
	border: 1px solid transparent;
	border-radius: 8px;
	cursor: pointer;
	font-size: 14px;
	transition: background-color 0.3s, border 0.3s;
	box-sizing: border-box;
}

.nav-btn:hover {
	border: 1px solid #ccc;
}

.profile-info {
	position: absolute;
	right: 30px;
	display: flex;
	align-items: center;
}

.profile-info img {
	width: 50px;
	height: 50px;
	border-radius: 50%;
	object-fit: cover;
	cursor: pointer;
	margin-right: 10px;
}

.status-indicator {
	width: 14px;
	height: 14px;
	border-radius: 50%;
	background-color: #808080;
	display: inline-block;
	margin-right: 10px;
}

.dropdown-menu {
	display: none;
	position: absolute;
	background-color: white;
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
	z-index: 100;
	right: 0;
	top: 60px;
	min-width: 150px;
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
	padding: 20px;
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
	max-height: 300px;
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

#calendar {
	max-width: 3000px;
	height: 400px;
	text-align: center;
	font-size: 0.6em;
	padding-left: 5px;
	padding-right: 5px;
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

.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fefefe;
	margin: 0% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 80%;
	max-width: 500px;
}

.close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
}

.close:hover, .close:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
}

.form-group input, .form-group select {
	width: 100%;
	padding: 8px;
	box-sizing: border-box;
	font-size: 15px;
}

.form-group button {
	padding: 10px 15px;
	background-color: #4CAF50;
	color: white;
	border: none;
	cursor: pointer;
}

.form-group button:hover {
	background-color: #45a049;
}

.card {
	background-color: #ffffff;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	padding: 10px;
	border-radius: 8px;
	height: 100%;
}

.rightSidebar {
	width: 300px;
	background-color: #f0f0f0;
	padding: 20px;
	border-left: 1px solid #ddd;
	transition: width 0.3s ease;
}

.rightSidebar.hidden {
	width: 0;
	padding: 0;
	overflow: hidden;
}

.chat-container {
	display: flex;
	flex-direction: column;
	height: 100%;
}

.chat-messages {
	flex: 1;
	overflow-y: auto;
	margin-bottom: 10px;
}

.chat-input {
	display: flex;
}

.chat-input input {
	flex: 1;
	padding: 5px;
}

.chat-input button {
	padding: 5px 10px;
	background-color: #4CAF50;
	color: white;
	border: none;
	cursor: pointer;
}

.drug-list {
	/*margin-top: 10px; */
	overflow-x: auto;
	/* 가로 스크롤 추가 */
}

.drug-list table {
	width: 100%;
	border-collapse: collapse;
	min-width: 600px;
	/* 테이블의 최소 너비 설정 */
}

.drug-list th, .drug-list td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
	white-space: nowrap;
	/* 텍스트 줄바꿈 방지 */
}

.drug-list th {
	background-color: #f2f2f2;
	font-weight: bold;
	position: sticky;
	/* 헤더를 고정 */
	top: 0;
	/* 헤더를 상단에 고정 */
	z-index: 1;
	/* 다른 요소 위에 표시 */
}

.drug-list tr:nth-child(even) {
	background-color: #f9f9f9;
}

.drug-list tr:hover {
	background-color: #f5f5f5;
}

#visitReason {
	width: 100%;
	/* 너비를 100%로 설정하여 form-group의 너비에 맞춤 */
	height: 150px;
	/* 원하는 높이로 설정 */
	box-sizing: border-box;
	/* 패딩과 테두리를 포함한 너비와 높이를 설정 */
	resize: vertical;
	/* 세로 방향으로만 크기 조절 가능하도록 설정 */
	font-size: 15px;
}

/* 환자등록 : 성별선택 */
.gender-selection {
	display: flex;
	align-items: center;
	margin-top: 30px;
	margin-bottom: 30px;
}

.gender-selection>label {
	margin-right: 10px;
	flex-shrink: 0;
}

.gender-selection .radio-inline {
	display: flex;
	align-items: center;
}

.gender-selection .radio-inline label {
	margin-right: 15px;
	display: flex;
	align-items: center;
}

.gender-selection .radio-inline input[type="radio"] {
	margin-right: 5px;
}

/* 환자등록 : 주소 */
.address-group {
	display: flex;
	flex-direction: column;
}

.postcode-input-group {
	display: flex;
	gap: 10px;
	margin-bottom: 0px;
}

.postcode-input-group input[type="text"] {
	flex: 3;
	min-width: 0;
}

.postcode-input-group button {
	flex: 1; /* 버튼의 비율을 줄임 */
	white-space: nowrap;
	padding: 4px 0px; /* 상하 패딩을 줄임 */
	background-color: #4CAF50;
	color: white;
	border: none;
	cursor: pointer;
	transition: background-color 0.3s;
	font-size: 1em; /* 글꼴 크기를 더 줄임 */
	line-height: 1; /* 줄 간격을 줄여 텍스트 높이를 낮춤 */
	height: 36.5px; /* 버튼의 높이를 입력 필드와 동일하게 설정 */
}

.postcode-input-group button:hover {
	background-color: #45a049;
}

.address-group input[type="text"] {
	margin-bottom: 10px;
}

/* 기존 CSS와 겹치지 않도록 특정성을 높입니다 */
#patientRegisterModal .form-group.address-group input[type="text"],
	#patientRegisterModal .form-group.address-group button {
	width: 100%;
	box-sizing: border-box;
}

/* 환자등록 : 이메일 */
.email-input-group {
	display: flex;
	gap: 5px;
	align-items: center;
}

.email-input-group input[type="text"], .email-input-group select {
	flex: 1;
	height: 30px;
	padding: 5px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

.email-input-group input[type="text"] {
	min-width: 0;
}

.email-separator {
	font-weight: bold;
	padding: 0 5px;
}

#patientEmailId {
	flex: 2;
}

#patientEmailDomain {
	flex: 1.5;
}

#emailDomainSelect {
	flex: 1.5;
}

/* 환자등록 : 혈액형 */
.blood-type-group {
	margin-bottom: 15px;
}

.blood-type-input-group {
	display: flex;
	gap: 10px;
}

.blood-type-input-group select {
	flex: 1;
	height: 36px;
	padding: 5px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 15px;
}

/* 환자등록 : 알레르기 */
#patientAllergies {
	width: 100%;
	/* 너비를 100%로 설정하여 form-group의 너비에 맞춤 */
	height: 150px;
	/* 원하는 높이로 설정 */
	box-sizing: border-box;
	/* 패딩과 테두리를 포함한 너비와 높이를 설정 */
	resize: vertical;
	/* 세로 방향으로만 크기 조절 가능하도록 설정 */
	font-size: 15px;
}

/* 환자등록 : 흡연 여부 선택을 위한 새로운 스타일 */
.smoking-status-selection {
	display: flex;
	align-items: center;
	margin-top: 15px;
	margin-bottom: 15px;
}

.smoking-status-selection>label {
	margin-right: 10px;
	flex-shrink: 0;
}

.smoking-status-selection .radio-group {
	display: flex;
	align-items: center;
}

.smoking-status-selection .radio-group label {
	margin-right: 15px;
	display: flex;
	align-items: center;
}

.smoking-status-selection .radio-group input[type="radio"] {
	margin-right: 5px;
}

.patient-search-results {
	position: absolute;
	z-index: 1000;
	background-color: #fff;
	border: 1px solid #ccc;
	max-height: 150px;
	overflow-y: auto;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
	width: 498px; /* 입력 필드와 동일한 너비로 설정 */
}

.search-result-item {
	padding: 8px 12px;
	border-bottom: 1px solid #ddd;
}

.search-result-item:hover {
	background-color: #ADD8E6; /* 호버링 시 배경 색상 */
}
</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body>
	<header>
		<div class="logo">
			<img src="/img/Logo.png" alt="Logo" class="nav-logo">
		</div>
		<nav>
			<button id="patient-register-btn" class="nav-btn">환자등록</button>
			<button id="patient-visit-btn" class="nav-btn">환자내원</button>
			<button id="patient-reservation-btn" class="nav-btn">예약</button>
			<button id="patients-btn" class="nav-btn">환자상세정보</button>
			<button id="messages-btn" class="nav-btn">메시지</button>
			<button id="chat-ai-btn" class="nav-btn">CHAT AI</button>
			<div class="profile-info">
				<img id="profile-image" src="/images/ProfileImage/현율무_jisoo.png" alt="Profile Image">
				<div class="status-indicator"></div>
				<button id="logout-btn" class="logout-btn">로그아웃</button>
				<div class="dropdown-menu">
					<a href="#" class="status-link"
						onclick="setStatus('away', '#808080')"> <span
						class="color-indicator" style="background-color: #808080;"></span>
						자리 비움
					</a> <a href="#" class="status-link"
						onclick="setStatus('available', '#008000')"> <span
						class="color-indicator" style="background-color: #008000;"></span>
						진료중
					</a> <a href="#" class="status-link"
						onclick="setStatus('busy', '#FF0000')"> <span
						class="color-indicator" style="background-color: #FF0000;"></span>
						수술중
					</a> <a href="#" class="status-link"
						onclick="setStatus('lunch', '#FFA500')"> <span
						class="color-indicator" style="background-color: #FFA500;"></span>
						점심시간
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
			<!-- 			<div class="calendar"> -->
			<!-- 				<div class="calendar-nav"> -->
			<!-- 					<button id="prev-month">&lt;</button> -->
			<!-- 					<span id="current-month"></span> -->
			<!-- 					<button id="next-month">&gt;</button> -->
			<!-- 				</div> -->
			<!-- 				<div id="calendar"></div> -->
			<!-- 			</div> -->
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
			<!-- <div class="section search">
                <h2>약품 검색</h2>
                <input type="text" placeholder="약품명">
                <button>검색</button>
            </div> -->
			<div class="section prescriptions" style="grid-column: span 2;">
				<h2>처방 목록</h2>
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
			<div class="section drug-list">
				<h2>약물 목록</h2>
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
							<td>A01BC23</td>
							<td>아세트아미노펜</td>
							<td>정제</td>
							<td>경구</td>
							<td>mg</td>
							<td>4000</td>
						</tr>
						<tr>
							<td>B02CD34</td>
							<td>이부프로펜123123123123123123123123123123213524345342325432542354235423542354235423542354</td>
							<td>정제</td>
							<td>경구</td>
							<td>mg</td>
							<td>2400</td>
						</tr>
						<tr>
							<td>C03DE45</td>
							<td>메트포르민</td>
							<td>정제</td>
							<td>경구</td>
							<td>mg</td>
							<td>2000</td>
						</tr>
						<tr>
							<td>D04EF56</td>
							<td>오메프라졸</td>
							<td>캡슐</td>
							<td>경구</td>
							<td>mg</td>
							<td>40</td>
						</tr>
						<tr>
							<td>E05FG67</td>
							<td>아토르바스타틴</td>
							<td>정제</td>
							<td>경구</td>
							<td>mg</td>
							<td>80</td>
						</tr>
						<tr>
							<td>B02CD34</td>
							<td>스크롤바
								테스트용~!@~!@~#@#$!@#!@#!@#!@#!@#!@#!@#$~!@#~!@#~~~!@#~!@#~!@#~!@#~23`</td>
							<td>정제</td>
							<td>경구</td>
							<td>mg</td>
							<td>2400</td>
						</tr>
						<tr>
							<td>B02CD34</td>
							<td>스크롤바
								테스트용~!@~!@~#@#$!@#!@#!@#!@#!@#!@#!@#$~!@#~!@#~~~!@#~!@#~!@#~!@#~23`</td>
							<td>정제</td>
							<td>경구</td>
							<td>mg</td>
							<td>2400</td>
						</tr>
					</tbody>
				</table>
			</div>
		</section>
		<section class="rightSidebar hidden">
			<div class="chat-container">
				<h2>메시지</h2>
				<div class="chat-messages">
					<!-- 채팅 메시지들이 여기에 표시됩니다 -->
				</div>
				<div class="chat-input">
					<input type="text" id="messageInput" placeholder="메시지를 입력하세요...">
					<button id="sendMessage">전송</button>
				</div>
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

	<!-- 환자등록 모달 -->
	<div id="patientRegisterModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<h2>신규 환자 등록</h2>
			<form id="patientRegisterForm" method="POST" action="registerPatient">
				<div class="form-group">
					<label for="registerPatientName">이름:</label> <input type="text"
						id="registerPatientName" name="registerPatientName" required>
				</div>
				<div class="form-group">
					<label for="registerPatientSecurityNum">주민등록번호:</label> <input
						type="text" id="registerPatientSecurityNum"
						name="registerPatientSecurityNum" maxlength="14" required>
				</div>
				<div class="gender-selection">
					<label>성별:</label>
					<div class="radio-inline">
						<label> <input type="radio" name="patientGender" value="M"
							required> 남성
						</label> <label> <input type="radio" name="patientGender"
							value="F" required> 여성
						</label>
					</div>
				</div>
				<div class="form-group address-group">
					<label for="patientAddress">주소:</label>
					<div class="postcode-input-group">
						<input type="text" id="patientPostcode" name="patientPostcode"
							placeholder="우편번호" readonly required>
						<button type="button" onclick="execDaumPostcode()">우편번호
							찾기</button>
					</div>
					<input type="text" id="patientAddress" name="patientAddress"
						placeholder="주소" readonly required> <input type="text"
						id="patientDetailAddress" name="patientDetailAddress"
						placeholder="상세주소" required>
				</div>
				<div class="form-group">
					<label for="patientPhone">전화번호:</label> <input type="tel"
						id="patientPhone" name="patientPhone" maxlength="13" required>
				</div>
				<div class="form-group email-group">
					<label for="patientEmail">이메일</label>
					<div class="email-input-group">
						<input type="text" id="patientEmailId" name="patientEmailId"
							placeholder="이메일 아이디" required> <span
							class="email-separator">@</span> <input type="text"
							id="patientEmailDomain" name="patientEmailDomain"
							placeholder="도메인" required> <select
							id="emailDomainSelect">
							<option value="">직접 입력</option>
							<option value="naver.com">naver.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="daum.net">daum.net</option>
							<option value="hanmail.net">hanmail.net</option>
						</select>
					</div>
				</div>
				<div class="form-group blood-type-group">
					<label for="patientBloodType">혈액형:</label>
					<div class="blood-type-input-group">
						<select id="patientRhFactor" name="patientRhFactor" required>
							<option value="">Rh 선택</option>
							<option value="(+)">Rh+</option>
							<option value="(-)">Rh-</option>
						</select> <select id="patientABOBloodType" name="patientABOBloodType"
							required>
							<option value="">선택</option>
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="O">O</option>
							<option value="AB">AB</option>
						</select>
					</div>
				</div>

				<div class="form-group">
					<label for="patientHeight">키(cm):</label> <input type="number"
						id="patientHeight" name="patientHeight" step="0.01" required>
				</div>
				<div class="form-group">
					<label for="patientWeight">체중(kg):</label> <input type="number"
						id="patientWeight" name="patientWeight" step="0.01" required>
				</div>
				<div class="form-group">
					<label for="patientAllergies">알레르기:</label>
					<textarea id="patientAllergies" name="patientAllergies"
						maxlength="1000"></textarea>
				</div>
				<div class="form-group">
					<label for="patientBloodPressure">혈압(mmHg):</label> <input
						type="text" id="patientBloodPressure" name="patientBloodPressure"
						maxlength="10">
				</div>
				<div class="form-group">
					<label for="patientTemperature">체온(℃):</label> <input type="number"
						id="patientTemperature" name="patientTemperature" step="0.1">
				</div>
				<div class="smoking-status-selection">
					<label>흡연 여부:</label>
					<div class="radio-group">
						<label><input type="radio" name="patientSmokingStatus"
							value="Y" required> 예</label> <label><input type="radio"
							name="patientSmokingStatus" value="N" required> 아니오</label>
					</div>
				</div>

				<div class="form-group">
					<button type="submit">환자 등록</button>
				</div>
			</form>
		</div>
	</div>


	<!-- 환자내원 모달 -->
	<div id="patientVisitModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<h2>환자 내원</h2>
			<form id="patientVisitForm">
				<div class="form-group">
					<label for="visitDate">내원(진료) 일자:</label> <input type="date"
						id="visitDate" name="visitDate" required>
				</div>
				<div class="form-group">
					<label for="visitTime">내원(진료) 시각:</label> <input type="time"
						id="visitTime" name="visitTime" required>
				</div>
				<div class="form-group">
					<label for="visitPatientName">성명:</label> <input type="text"
						id="visitPatientName" name="visitPatientName" required
						oninput="searchPatients(this.value)">
					<div id="patientSearchResults" class="patient-search-results"></div>
				</div>

				<div class="form-group">
					<label for="visitPatientSecurityNum">주민등록번호:</label> <input
						type="text" id="visitPatientSecurityNum"
						name="visitPatientSecurityNum" maxlength="14" required>
				</div>
				<div class="form-group">
					<label for="visitReason">내원 사유(증상):</label>
					<textarea id="visitReason" name="visitReason" required></textarea>
				</div>
				<div class="form-group">
					<label for="doctorSelect">담당 의사:</label> <select id="doctorSelect"
						name="doctorName" required>
						<option value="">의사를 선택하세요</option>
					</select>
				</div>

				<div class="form-group">
					<label for="nurseSelect">담당 간호사:</label> <select id="nurseSelect"
						name="nurseN" required>
						<option value="">간호사를 선택하세요</option>
					</select>
				</div>
				<div class="form-group">
					<button type="submit">내원 등록</button>
				</div>
			</form>
		</div>
	</div>

	<script>
	    document.addEventListener('DOMContentLoaded', function() {
	        // 메시지 버튼 클릭 이벤트
	        const messagesBtn = document.getElementById('messages-btn');
	        if (messagesBtn) {
	            messagesBtn.addEventListener('click', function () {
	                const rightSidebar = document.querySelector('.rightSidebar');
	                const content = document.querySelector('.content');
	
	                if (rightSidebar.classList.contains('hidden')) {
	                    rightSidebar.classList.remove('hidden');
	                    content.style.width = 'calc(100% - 600px)'; // 좌우 사이드바를 고려한 너비
	                } else {
	                    rightSidebar.classList.add('hidden');
	                    content.style.width = 'calc(100% - 300px)'; // 왼쪽 사이드바만 고려한 너비
	                }
	            });
	        }
	
	        // 메시지 전송 기능 (예시)
	        const sendMessageBtn = document.getElementById('sendMessage');
	        if (sendMessageBtn) {
	            sendMessageBtn.addEventListener('click', function () {
	                const messageInput = document.getElementById('messageInput');
	                if (messageInput) {
	                    const message = messageInput.value.trim();
	                    if (message) {
	                        const chatMessages = document.querySelector('.chat-messages');
	                        const messageElement = document.createElement('p');
	                        messageElement.textContent = message;
	                        chatMessages.appendChild(messageElement);
	                        messageInput.value = '';
	                        // 여기에 실제 메시지 전송 로직을 추가해야 합니다.
	                    }
	                }
	            });
	        }
	
	        // 캘린더 기능
	        const calendarEl = document.getElementById('calendar');
	        if (calendarEl) {
	            var calendar = new FullCalendar.Calendar(calendarEl, {
	                initialView: 'dayGridMonth',
	                locale: 'ko',
	                headerToolbar: {
	                    left: 'prev,next today',
	                    center: 'title',
	                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
	                },
	                dayHeaderContent: function(arg) {
	                    var dayName = arg.text;
	                    var element = document.createElement('span');
	                    element.innerHTML = dayName;
	                    element.style.fontSize = '1.4em';  // 요일 폰트 크기 증가
	                    element.style.fontWeight = 'bold';  // 요일을 굵게 표시
	                    return { domNodes: [element] };
	                },
	                dayCellContent: function(arg) {
	                    var dayOfWeek = arg.date.getDay();
	                    var dateText = arg.dayNumberText.replace('일', '');
	                    var element = document.createElement('div');
	                    element.innerHTML = dateText;
	                    element.style.fontSize = '1.4em';  // 날짜 숫자 폰트 크기 증가
	                    element.style.fontWeight = 'bold';  // 날짜 숫자를 굵게 표시
	                    
	                    if (dayOfWeek === 0) {  // 일요일
	                        element.style.color = 'red';
	                    } else if (dayOfWeek === 6) {  // 토요일
	                        element.style.color = 'blue';
	                    }
	                    return { domNodes: [element] };
	                },
	                dateClick: function(info) {
	                    var clickedDate = new Date(info.dateStr);
	                    var calendarDate = calendar.getDate();
	
	                    if (clickedDate.getMonth() < calendarDate.getMonth() && clickedDate.getFullYear() === calendarDate.getFullYear() ||
	                        clickedDate.getFullYear() < calendarDate.getFullYear()) {
	                        calendar.prev();
	                    } else if (clickedDate.getMonth() > calendarDate.getMonth() && clickedDate.getFullYear() === calendarDate.getFullYear() ||
	                            clickedDate.getFullYear() > calendarDate.getFullYear()) {
	                        calendar.next();
	                    } else {
	                        alert('Date: ' + info.dateStr);
	                    }
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
	        }
	
	        // 탭 전환 기능
	        function showAllPatients() {
	            const allPatients = document.getElementById('all-patients');
	            const managedPatients = document.getElementById('managed-patients');
	            const tabAllPatients = document.getElementById('tab-all-patients');
	            const tabManagedPatients = document.getElementById('tab-managed-patients');
	
	            if (allPatients && managedPatients && tabAllPatients && tabManagedPatients) {
	                allPatients.style.display = 'block';
	                managedPatients.style.display = 'none';
	                tabAllPatients.classList.add('active');
	                tabManagedPatients.classList.remove('active');
	            }
	        }
	
	        function showManagedPatients() {
	            const allPatients = document.getElementById('all-patients');
	            const managedPatients = document.getElementById('managed-patients');
	            const tabAllPatients = document.getElementById('tab-all-patients');
	            const tabManagedPatients = document.getElementById('tab-managed-patients');
	
	            if (allPatients && managedPatients && tabAllPatients && tabManagedPatients) {
	                allPatients.style.display = 'none';
	                managedPatients.style.display = 'block';
	                tabAllPatients.classList.remove('active');
	                tabManagedPatients.classList.add('active');
	            }
	        }
	
	        // 모달 기능
	        const patientRegisterModal = document.getElementById('patientRegisterModal');
	        const patientVisitModal = document.getElementById('patientVisitModal');
	        const patientRegisterBtn = document.getElementById('patient-register-btn');
	        const patientVisitBtn = document.getElementById('patient-visit-btn');
	        const closeBtns = document.getElementsByClassName('close');
	
	        if (patientRegisterBtn && patientRegisterModal) {
	            patientRegisterBtn.onclick = function () {
	                patientRegisterModal.style.display = 'block';
	            }
	        }
	
	        if (patientVisitBtn && patientVisitModal) {
	            patientVisitBtn.onclick = function () {
	                patientVisitModal.style.display = 'block';
	            }
	        }
	
	        if (closeBtns) {
	            for (let closeBtn of closeBtns) {
	                closeBtn.onclick = function () {
	                    if (patientRegisterModal) patientRegisterModal.style.display = 'none';
	                    if (patientVisitModal) patientVisitModal.style.display = 'none';
	                }
	            }
	        }
	
	        window.onclick = function (event) {
	            if (event.target == patientRegisterModal) {
	                patientRegisterModal.style.display = 'none';
	            }
	            if (event.target == patientVisitModal) {
	                patientVisitModal.style.display = 'none';
	            }
	        }
	
	        // 프로필 이미지 클릭 시 드롭다운 메뉴 표시
	        const profileImage = document.getElementById('profile-image');
	        const dropdownMenu = document.querySelector('.dropdown-menu');
	        if (profileImage && dropdownMenu) {
	            profileImage.addEventListener('click', function (event) {
	                event.stopPropagation();
	                dropdownMenu.style.display = 'block';
	            });
	
	            // 문서 클릭 시 드롭다운 메뉴 숨기기
	            document.addEventListener('click', function () {
	                dropdownMenu.style.display = 'none';
	            });
	        }
	
	        // 상태 변경 기능
	        function setStatus(status, color) {
	            const statusIndicator = document.querySelector('.status-indicator');
	            if (statusIndicator) {
	                statusIndicator.style.backgroundColor = color;
	                // 여기에 서버로 상태 변경을 전송하는 로직을 추가할 수 있습니다.
	            }
	        }
	
	        // 전화번호 자동 포맷팅 기능
	        const patientPhone = document.getElementById('patientPhone');
	        if (patientPhone) {
	            patientPhone.addEventListener('input', function (e) {
	                let x = e.target.value.replace(/\D/g, '').match(/(\d{0,3})(\d{0,4})(\d{0,4})/);
	                e.target.value = !x[2] ? x[1] : x[1] + '-' + x[2] + (x[3] ? '-' + x[3] : '');
	            });
	        }
	
	        // 주소 검색 API 기능
	        function loadDaumPostcodeScript() {
	            return new Promise((resolve, reject) => {
	                if (typeof daum !== 'undefined') {
	                    resolve();
	                    return;
	                }
	                const script = document.createElement('script');
	                script.src = "//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js";
	                script.onload = resolve;
	                script.onerror = reject;
	                document.head.appendChild(script);
	            });
	        }
	
	        async function execDaumPostcode() {
	            try {
	                await loadDaumPostcodeScript();
	                new daum.Postcode({
	                    oncomplete: function (data) {
	                        var addr = ''; // 주소 변수
	
	                        if (data.userSelectedType === 'R') {
	                            addr = data.roadAddress;
	                        } else {
	                            addr = data.jibunAddress;
	                        }
	
	                        const postcodeInput = document.getElementById('patientPostcode');
	                        const addressInput = document.getElementById('patientAddress');
	                        const detailAddressInput = document.getElementById('patientDetailAddress');
	
	                        if (postcodeInput && addressInput && detailAddressInput) {
	                            postcodeInput.value = data.zonecode;
	                            addressInput.value = addr;
	                            detailAddressInput.focus();
	                        }
	                    }
	                }).open();
	            } catch (error) {
	                console.error('Failed to load Daum Postcode script:', error);
	                alert('우편번호 서비스를 불러오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.');
	            }
	        }
	
	        const postcodeBtn = document.querySelector('.postcode-input-group button');
	        if (postcodeBtn) {
	            postcodeBtn.addEventListener('click', execDaumPostcode);
	        }
	
	        // 이메일 도메인 선택 기능
	        const emailDomainSelect = document.getElementById('emailDomainSelect');
	        if (emailDomainSelect) {
	            emailDomainSelect.addEventListener('change', function() {
	                const domainInput = document.getElementById('patientEmailDomain');
	                if (domainInput) {
	                    if (this.value !== "") {
	                        domainInput.value = this.value;
	                        domainInput.readOnly = true;
	                    } else {
	                        domainInput.value = "";
	                        domainInput.readOnly = false;
	                    }
	                }
	            });
	        }
	
	        // 주민등록번호 자동 포맷팅 기능 (환자 등록)
	        const registerPatientSecurityNum = document.getElementById('registerPatientSecurityNum');
	        if (registerPatientSecurityNum) {
	            registerPatientSecurityNum.addEventListener('input', function (e) {
	                formatSecurityNum(e.target);
	            });
	        }
	
	        // 주민등록번호 자동 포맷팅 기능 (환자 내원)
	        const visitPatientSecurityNum = document.getElementById('visitPatientSecurityNum');
	        if (visitPatientSecurityNum) {
	            visitPatientSecurityNum.addEventListener('input', function (e) {
	                formatSecurityNum(e.target);
	            });
	        }
	
	        // 주민등록번호 포맷팅 함수
	        function formatSecurityNum(input) {
	            let x = input.value.replace(/\D/g, '').match(/(\d{0,6})(\d{0,7})/);
	            input.value = !x[2] ? x[1] : x[1] + '-' + x[2];
	        }
	
	        // 키 글자수 제한
	        const patientHeight = document.getElementById('patientHeight');
	        if (patientHeight) {
	            patientHeight.addEventListener('input', function() {
	                if (this.value.length > 6) {
	                    this.value = this.value.slice(0, 6);
	                }
	            });
	        }
	
	        // 체중 글자수 제한
	        const patientWeight = document.getElementById('patientWeight');
	        if (patientWeight) {
	            patientWeight.addEventListener('input', function() {
	                if (this.value.length > 6) {
	                    this.value = this.value.slice(0, 6);
	                }
	            });
	        }
	
	        // 혈압 "/"만 가능하게 제한
	        const patientBloodPressure = document.getElementById('patientBloodPressure');
	        if (patientBloodPressure) {
	            patientBloodPressure.addEventListener('input', function() {
	                this.value = this.value.replace(/[^0-9./]/g, '');
	            });
	        }
	
	        // 체온 글자수 제한
	        const patientTemperature = document.getElementById('patientTemperature');
	        if (patientTemperature) {
	            patientTemperature.addEventListener('input', function() {
	                if (this.value.length > 4) {
	                    this.value = this.value.slice(0, 4);
	                }
	            });
	        }
	
	        // 환자등록 폼 제출 로직
	        const patientRegisterForm = document.getElementById('patientRegisterForm');
	        if (patientRegisterForm) {
	            patientRegisterForm.addEventListener('submit', function(e) {
	                e.preventDefault();
	                const securityNumInput = document.getElementById('registerPatientSecurityNum');
	                const securityNum = securityNumInput ? securityNumInput.value : '';
	
	                // 주민등록번호 유효성 검사
	                fetch('/api/patients/validateSecurityNum', {
	                    method: 'POST',
	                    headers: {
	                        'Content-Type': 'application/json',
	                    },
	                    body: JSON.stringify({ securityNum: securityNum })
	                })
	                .then(response => {
	                    if (response.ok) {
	                        return response.text();
	                    } else {
	                        return response.text().then(text => {
	                            throw new Error(text || '유효하지 않은 주민등록번호입니다.');
	                        });
	                    }
	                })
	                .then(message => {
	                    // 유효성 검사 통과 시 환자 등록 로직 실행
	                    submitPatientRegistrationForm();
	                })
	                .catch(error => {
	                    console.error('Error:', error);
	                    alert('유효성 검사 중 오류가 발생했습니다: ' + error.message);
	                });
	            });
	        }
	
	        // 실제 환자 등록 로직
	        function submitPatientRegistrationForm() {
	            const formData = new FormData(document.getElementById('patientRegisterForm'));
	            const patientData = {};
	
	            formData.forEach((value, key) => {
	                switch(key) {
	                    case 'registerPatientName':
	                        patientData.name = value;
	                        break;
	                    case 'registerPatientSecurityNum':
	                        patientData.securityNum = value;
	                        break;
	                    case 'patientEmailId':
	                    case 'patientEmailDomain':
	                        if (!patientData.email) patientData.email = '';
	                        patientData.email += value + (key === 'patientEmailId' ? '@' : '');
	                        break;
	                    case 'patientRhFactor':
	                    case 'patientABOBloodType':
	                        if (!patientData.bloodType) patientData.bloodType = '';
	                        patientData.bloodType += value;
	                        break;
	                    case 'patientGender':
	                        patientData.gender = value;
	                        break;
	                    case 'patientPostcode':
	                    case 'patientAddress':
	                    case 'patientDetailAddress':
	                        if (!patientData.address) patientData.address = '';
	                        patientData.address += value + ' ';
	                        break;
	                    case 'patientPhone':
	                        patientData.phone = value;
	                        break;
	                    case 'patientHeight':
	                        patientData.height = value;
	                        break;
	                    case 'patientWeight':
	                        patientData.weight = value;
	                        break;
	                    case 'patientAllergies':
	                        patientData.allergies = value.trim() === '' ? null : value;
	                        break;
	                    case 'patientBloodPressure':
	                        patientData.bloodPressure = value.trim() === '' ? null : value;
	                        break;
	                    case 'patientTemperature':
	                        patientData.temperature = value;
	                        break;
	                    case 'patientSmokingStatus':
	                        patientData.smokingStatus = value;
	                        break;
	                    default:
	                        patientData[key] = value;
	                }
	            });
	
	            // AJAX 요청을 통해 환자 등록
	            fetch('/api/patients/registerPatient', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/json', // Content-Type을 JSON으로 설정
	                },
	                body: JSON.stringify(patientData) // JSON 형식으로 변환하여 전송
	            })
	            .then(response => {
	                if (response.status === 409) {
	                    throw new Error('중복된 주민등록번호가 있습니다.');
	                } else if (!response.ok) {
	                    return response.text().then(text => {
	                        throw new Error(text || '환자 등록 중 오류가 발생했습니다.');
	                    });
	                }
	                return response.json();
	            })
	            .then(data => {
	                alert('환자가 성공적으로 등록되었습니다.');
	                document.getElementById('patientRegisterModal').style.display = 'none';
	                // 필요한 경우 페이지 새로고침 또는 환자 목록 업데이트
	            })
	            .catch(error => {
	                console.error('Error:', error);
	                alert('환자 등록 중 오류가 발생했습니다: ' + error.message);
	            });
	        }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	        // 환자 이름을 검색하여 자동 완성 목록을 표시하는 함수
	        function searchPatients(query) {
	            const resultsDiv = document.getElementById('patientSearchResults');
	            if (!resultsDiv) return;
	
	            if (query.length < 2) {
	                resultsDiv.style.display = 'none';
	                return;
	            }
	
	            fetch(`/api/patients/search?name=${query}`)
	                .then(response => response.json())
	                .then(data => {
	                    resultsDiv.innerHTML = ''; // 기존 검색 결과 삭제
	                    if (data.length > 0) {
	                        const filteredData = data.filter(patient => 
	                            patient.name.startsWith(query) || patient.securityNum.startsWith(query)
	                        );
	
	                        if (filteredData.length > 0) {
	                            filteredData.forEach(patient => {
	                                const option = document.createElement('div');
	                                option.textContent = patient.name + '   ' + patient.securityNum; // 이름 (주민등록번호)
	                                option.style.cursor = 'pointer';
	                                option.className = 'search-result-item'; // 클래스 추가
	                                option.onclick = () => {
	                                    // 성명과 주민등록번호 필드에 선택된 환자 정보 입력
	                                    const visitPatientName = document.getElementById('visitPatientName');
	                                    const visitPatientSecurityNum = document.getElementById('visitPatientSecurityNum');
	                                    const visitPatientNo = document.getElementById('visitPatientNo'); // 환자 no를 위한 hidden input
	                                    if (visitPatientName && visitPatientSecurityNum) {
	                                        visitPatientName.value = patient.name;
	                                        visitPatientSecurityNum.value = patient.securityNum;
	                                        resultsDiv.style.display = 'none'; // 검색 결과 숨기기
	                                    }
	                                };
	                                resultsDiv.appendChild(option);
	                            });
	                            resultsDiv.style.display = 'block';
	                        } else {
	                            resultsDiv.style.display = 'none';
	                        }
	                    } else {
	                        resultsDiv.style.display = 'none';
	                    }
	                })
	                .catch(error => {
	                    console.error('Error:', error);
	                });
	        }
	
	        // 검색된 환자 목록에서 선택 시 이벤트
	        const visitPatientNameInput = document.getElementById('visitPatientName');
	        if (visitPatientNameInput) {
	            visitPatientNameInput.addEventListener('input', function () {
	                searchPatients(this.value);
	            });
	        }
	
	        // 의사 목록 불러오기
	        const doctorSelect = document.getElementById('doctorSelect');
	        if (doctorSelect) {
	            fetch(`/api/patients/doctors`)
	                .then(response => response.json())
	                .then(doctors => {
	                    // 이름을 기준으로 ㄱㄴㄷ순으로 정렬
	                    doctors.sort((a, b) => a.name.localeCompare(b.name, 'ko-KR'));
	                    doctors.forEach(doctor => {
	                        const option = document.createElement('option');
	                        // option.value = doctor.name; // 의사의 이름만 value로 사용
	                        option.value = doctor.name; // 의사의 'no'를 value로 설정
	                        option.text = doctor.name + "(" + doctor.departmentId + ")"; // 의사의 이름과 부서를 표시
	                        doctorSelect.appendChild(option);
	                    });
	                });
	        }
	
	        // 간호사 목록 불러오기
	        const nurseSelect = document.getElementById('nurseSelect');
	        if (nurseSelect) {
	            fetch('/api/patients/nurses')
	                .then(response => response.json())
	                .then(nurses => {
	                    // 이름을 기준으로 ㄱㄴㄷ순으로 정렬
	                    nurses.sort((a, b) => a.name.localeCompare(b.name, 'ko-KR'));
	                    nurses.forEach(nurse => {
	                        const option = document.createElement('option');
	                        //option.value = nurse.name; // 간호사의 이름만 value로 사용
	                        option.value = nurse.name; // 간호사의 'no'를 value로 설정
	                        option.text = nurse.position + " " + nurse.name + "(" + nurse.departmentId + ")"; // 간호사의 이름을 표시
	                        nurseSelect.appendChild(option);
	                    });
	                });
	        }
	
	        // 환자 내원 폼 제출 로직
	        function submitPatientVisitForm() {
	            const formData = new FormData(document.getElementById('patientVisitForm'));
	            const visitData = {};
	
	            formData.forEach((value, key) => {
	                switch(key) {
	                    case 'visitDate':
	                        visitData.visitDate = value;
	                        break;
	                    case 'visitTime':
	                        visitData.visitTime = value;
	                        break;
	                    case 'visitPatientName':
	                        visitData.patientName = encodeURIComponent(value); // 인코딩 추가
	                        break;
	                    case 'visitPatientSecurityNum':
	                        visitData.securityNum = value;
	                        break;
	                    case 'visitReason':
	                        visitData.visitReason = encodeURIComponent(value); // 인코딩 추가
	                        break;
	                    case 'doctorSelect':
	                        visitData.doctorName = value; // 의사의 'no'를 전송
	                        break;
	                    case 'nurseSelect':
	                        visitData.nurseName = value; // 간호사의 'no'를 전송
	                        break;
	                    default:
	                        visitData[key] = value;
	                }
	            });
	
				console.log("Sending Visit Data: ", JSON.stringify(visitData)); // 데이터를 콘솔에 출력하여 확인
				
	            // AJAX 요청을 통해 환자 내원 등록
	            fetch('/api/patients/visitPatient', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/json',
	                },
	                body: JSON.stringify(visitData)
	            })
	            .then(response => {
	                if (!response.ok) {
	                    return response.text().then(text => { throw new Error(text || '내원 등록 중 오류가 발생했습니다.'); });
	                }
	                alert('환자내원이 성공적으로 등록되었습니다.');
	                return response.text();
	            })
	            .then(message => {
	                alert(message);
	                document.getElementById('patientVisitModal').style.display = 'none';
	                // 필요한 경우 페이지 새로고침 또는 환자 목록 업데이트
	            })
	            .catch(error => {
	                console.error('Error:', error);
	                alert('내원 등록 중 오류가 발생했습니다: ' + error.message);
	            });
	        }
	    });
	</script>
</body>

</html>