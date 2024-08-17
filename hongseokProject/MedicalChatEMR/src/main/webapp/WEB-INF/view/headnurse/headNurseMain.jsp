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

.calendar {
	margin-top: 20px;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	width: 100%;
	box-sizing: border-box;
}

.calendar table {
	width: 100%;
	border-collapse: collapse;
}

.calendar th, .calendar td {
	padding: 5px;
	text-align: center;
	border: 1px solid #ddd;
	height: 25px;
	width: 25px;
}

.calendar th {
	background-color: #f0f0f0;
}

.calendar .today {
	background-color: #b8edb5;
}

.calendar .other-month {
	color: #ccc;
}

.calendar-nav {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
}

.calendar-nav button {
	background-color: #f0f0f0;
	border: 1px solid #ddd;
	border-radius: 4px;
	cursor: pointer;
	padding: 5px 10px;
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
</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body>
	<header>
		<div class="logo">
			<img src="resources/img/LOGO.jpg" alt="Logo">
		</div>
		<nav>
			<button id="patient-register-btn" class="nav-btn">환자등록</button>
			<button id="patient-visit-btn" class="nav-btn">환자내원</button>
			<button id="patients-btn" class="nav-btn">환자상세정보</button>
			<button id="messages-btn" class="nav-btn">메시지</button>
			<button id="chat-ai-btn" class="nav-btn">CHAT AI</button>
			<div class="profile-info">
				<img id="profile-image" src="doctorProfile.png" alt="Profile Image">
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
			<div class="calendar">
				<div class="calendar-nav">
					<button id="prev-month">&lt;</button>
					<span id="current-month"></span>
					<button id="next-month">&gt;</button>
				</div>
				<div id="calendar"></div>
			</div>
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
					<label for="patientName">이름:</label> <input type="text"
						id="patientName" name="patientName" required>
				</div>
				<div class="form-group">
					<label for="patientSecurityNum">주민등록번호:</label> <input type="text"
						id="patientSecurityNum" name="patientSecurityNum" maxlength="14"
						required>
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
						id="patientHeight" name="patientHeight" required>
				</div>
				<div class="form-group">
					<label for="patientWeight">체중(kg):</label> <input type="number"
						id="patientWeight" name="patientWeight" required>
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
					<label for="patientTemperature">체온(℃):</label> <input type="text"
						id="patientTemperature" name="patientTemperature" maxlength="4"
						step="0.1">
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
					<label for="visitDate">일자:</label> <input type="date"
						id="visitDate" name="visitDate" required>
				</div>
				<div class="form-group">
					<label for="patientName">성명:</label> <input type="text"
						id="patientName" name="patientName" required>
				</div>
				<div class="form-group">
					<label for="patientSecurityNum">주민등록번호:</label> <input type="text"
						id="patientSecurityNum" name="patientSecurityNum" maxlength="14"
						required>
				</div>
				<div class="form-group">
					<label for="visitReason">내원 사유:</label>
					<textarea id="visitReason" name="visitReason" required></textarea>
				</div>
				<div class="form-group">
					<button type="submit">내원 등록</button>
				</div>
			</form>
		</div>
	</div>

	<script>
        // 메시지 버튼 클릭 이벤트
        document.getElementById('messages-btn').addEventListener('click', function () {
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

        // 메시지 전송 기능 (예시)
        document.getElementById('sendMessage').addEventListener('click', function () {
            const messageInput = document.getElementById('messageInput');
            const message = messageInput.value.trim();

            if (message) {
                const chatMessages = document.querySelector('.chat-messages');
                const messageElement = document.createElement('p');
                messageElement.textContent = message;
                chatMessages.appendChild(messageElement);
                messageInput.value = '';

                // 여기에 실제 메시지 전송 로직을 추가해야 합니다.
            }
        });

        // 캘린더 기능
        function generateCalendar(year, month) {
            const firstDay = new Date(year, month, 1);
            const lastDay = new Date(year, month + 1, 0);
            const daysInMonth = lastDay.getDate();
            const startingDay = firstDay.getDay();

            let calendarHTML = '<table><tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr><tr>';

            for (let i = 0; i < startingDay; i++) {
                calendarHTML += '<td class="other-month"></td>';
            }

            for (let day = 1; day <= daysInMonth; day++) {
                if ((day + startingDay - 1) % 7 === 0 && day !== 1) {
                    calendarHTML += '</tr><tr>';
                }
                const currentDate = new Date();
                const isToday = day === currentDate.getDate() && month === currentDate.getMonth() && year === currentDate.getFullYear();
                calendarHTML += `<td class="${isToday ? 'today' : ''}">${day}</td>`;
            }

            while ((daysInMonth + startingDay) % 7 !== 0) {
                calendarHTML += '<td class="other-month"></td>';
                daysInMonth++;
            }

            calendarHTML += '</tr></table>';
            document.getElementById('calendar').innerHTML = calendarHTML;
            document.getElementById('current-month').textContent = `${year}년 ${month + 1}월`;
        }

        let currentDate = new Date();
        generateCalendar(currentDate.getFullYear(), currentDate.getMonth());

        document.getElementById('prev-month').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() - 1);
            generateCalendar(currentDate.getFullYear(), currentDate.getMonth());
        });

        document.getElementById('next-month').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() + 1);
            generateCalendar(currentDate.getFullYear(), currentDate.getMonth());
        });

        // 탭 전환 기능
        function showAllPatients() {
            document.getElementById('all-patients').style.display = 'block';
            document.getElementById('managed-patients').style.display = 'none';
            document.getElementById('tab-all-patients').classList.add('active');
            document.getElementById('tab-managed-patients').classList.remove('active');
        }

        function showManagedPatients() {
            document.getElementById('all-patients').style.display = 'none';
            document.getElementById('managed-patients').style.display = 'block';
            document.getElementById('tab-all-patients').classList.remove('active');
            document.getElementById('tab-managed-patients').classList.add('active');
        }

        // 모달 기능
        const patientRegisterModal = document.getElementById('patientRegisterModal');
        const patientVisitModal = document.getElementById('patientVisitModal');
        const patientRegisterBtn = document.getElementById('patient-register-btn');
        const patientVisitBtn = document.getElementById('patient-visit-btn');
        const closeBtns = document.getElementsByClassName('close');

        patientRegisterBtn.onclick = function () {
            patientRegisterModal.style.display = 'block';
        }

        patientVisitBtn.onclick = function () {
            patientVisitModal.style.display = 'block';
        }

        for (let closeBtn of closeBtns) {
            closeBtn.onclick = function () {
                patientRegisterModal.style.display = 'none';
                patientVisitModal.style.display = 'none';
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
        document.getElementById('profile-image').addEventListener('click', function (event) {
            event.stopPropagation();
            document.querySelector('.dropdown-menu').style.display = 'block';
        });

        // 문서 클릭 시 드롭다운 메뉴 숨기기
        document.addEventListener('click', function () {
            document.querySelector('.dropdown-menu').style.display = 'none';
        });

        // 상태 변경 기능
        function setStatus(status, color) {
            document.querySelector('.status-indicator').style.backgroundColor = color;
            // 여기에 서버로 상태 변경을 전송하는 로직을 추가할 수 있습니다.
        }

        // 전화번호 자동 포맷팅 기능
        document.getElementById('patientPhone').addEventListener('input', function (e) {
            let x = e.target.value.replace(/\D/g, '').match(/(\d{0,3})(\d{0,4})(\d{0,4})/);
            e.target.value = !x[2] ? x[1] : x[1] + '-' + x[2] + (x[3] ? '-' + x[3] : '');
        });

        // 폼 제출 시 하이픈 제거 (선택적)
//        document.getElementById('patientRegisterForm').addEventListener('submit', function (e) {
//            let phoneInput = document.getElementById('patientPhone');
//            phoneInput.value = phoneInput.value.replace(/-/g, '');
//        });


		
		// 다음 주소api 불러오기
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
                        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                        var addr = ''; // 주소 변수

                        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                            addr = data.roadAddress;
                        } else { // 사용자가 지번 주소를 선택했을 경우(J)
                            addr = data.jibunAddress;
                        }

                        console.log(addr)

                        // 우편번호와 주소 정보를 해당 필드에 넣는다.
                        document.getElementById('patientPostcode').value = data.zonecode;
                        document.getElementById('patientAddress').value = addr;
                        // 커서를 상세주소 필드로 이동한다.
                        document.getElementById('patientDetailAddress').focus();

                        console.log(document.getElementById('partientPostcode'));

                    }

                }).open();
            } catch (error) {
                console.error('Failed to load Daum Postcode script:', error);
                alert('우편번호 서비스를 불러오는 데 실패했습니다. 잠시 후 다시 시도해 주세요.');
            }
        }
        
        // 이메일 도메인 선택 기능
		document.getElementById('emailDomainSelect').addEventListener('change', function() {
		    var domainInput = document.getElementById('patientEmailDomain');
		    if (this.value !== "") {
		        domainInput.value = this.value;
		        domainInput.readOnly = true;
		    } else {
		        domainInput.value = "";
		        domainInput.readOnly = false;
		    }
		});
		        
		// 주민등록번호 자동 포맷팅 기능 (환자 등록)
		document.getElementById('patientSecurityNum').addEventListener('input', function (e) {
		    formatSecurityNum(e.target);
		});
		
		// 주민등록번호 자동 포맷팅 기능 (환자 내원)
		document.getElementById('patientVisitModal').querySelector('[name="patientSecurityNum"]').addEventListener('input', function (e) {
		    formatSecurityNum(e.target);
		});
		
		// 주민등록번호 포맷팅 함수
		function formatSecurityNum(input) {
		    let x = input.value.replace(/\D/g, '').match(/(\d{0,6})(\d{0,7})/);
		    input.value = !x[2] ? x[1] : x[1] + '-' + x[2];
		}
		
		// 키 글자수 제한
		document.getElementById('patientHeight').addEventListener('input', function() {
		    if (this.value.length > 6) {
		        this.value = this.value.slice(0, 6);
		    }
		});

		// 체중 글자수 제한
		document.getElementById('patientWeight').addEventListener('input', function() {
		    if (this.value.length > 6) {
		        this.value = this.value.slice(0, 6);
		    }
		});
		
		// 폼 제출 시 하이픈 제거 (환자 등록)
//		document.getElementById('patientRegisterForm').addEventListener('submit', function (e) {
//		    removeHyphen(this.querySelector('[name="patientSecurityNum"]'));
//		});
		
		// 폼 제출 시 하이픈 제거 (환자 내원)
//		document.getElementById('patientVisitForm').addEventListener('submit', function (e) {
//		    removeHyphen(this.querySelector('[name="patientSecurityNum"]'));
//		});
		
		// 하이픈 제거 함수
		function removeHyphen(input) {
		    input.value = input.value.replace(/-/g, '');
		}

		// 환자등록
	    document.getElementById('patientRegisterForm').addEventListener('submit', function(e) {
	        e.preventDefault();
	        
	        // 폼 데이터 수집
			const formData = new FormData(this);
			const patientData = {};
			formData.forEach((value, key) => {
			    switch(key) {
			        case 'patientEmailId':
			        case 'patientEmailDomain':
			            if (!patientData.email) patientData.email = '';
			            patientData.email += value + (key === 'patientEmailId' ? '@' : '');
			            break;
			        case 'patientRhFactor':
			        case 'patientABOBloodType':
			            if (!patientData.blood_type) patientData.blood_type = '';
			            patientData.blood_type += value;
			            break;
			        case 'patientName':
			            patientData.name = value;
			            break;
			        case 'patientSecurityNum':
			            patientData.securityNum = value; // replace(/-/g, '');
			            break;
			        case 'patientGender':
			            patientData.gender = value;
			            break;
			        case 'patientAddress':
			            patientData.address = value;
			            break;
			        case 'patientPhone':
			            patientData.phone = value; //.replace(/-/g, '');
			            break;
			        case 'patientHeight':
			            patientData.height = value;
			            break;
			        case 'patientWeight':
			            patientData.weight = value;
			            break;
			        case 'patientAllergies':
			            patientData.allergies = value;
			            break;
			        case 'patientBloodPressure':
			            patientData.blood_pressure = value;
			            break;
			        case 'patientTemperature':
			            patientData.temperature = value; 
			            break;
			        case 'patientSmokingStatus':
			            patientData.smoking_status = value;
			            break;
			        default:
			            patientData[key] = value;
			    }
			});

	
	        // 주민등록번호와 전화번호의 하이픈 유지
	
	        // AJAX 요청
	        fetch('/headnurse/registerPatient', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            },
	            body: JSON.stringify(patientData)
	        })
	        .then(response => response.json())
	        .then(data => {
	            alert('환자가 성공적으로 등록되었습니다.');
	            patientRegisterModal.style.display = 'none';
	            // 필요한 경우 페이지 새로고침 또는 환자 목록 업데이트
	        })
	        .catch(error => {
	            console.error('Error:', error);
	            alert('환자 등록 중 오류가 발생했습니다.');
	        });
	    });


    </script>
</body>

</html>