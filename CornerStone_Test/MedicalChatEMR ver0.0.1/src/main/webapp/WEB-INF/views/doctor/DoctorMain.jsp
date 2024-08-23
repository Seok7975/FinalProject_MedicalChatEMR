<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Medical Dashboard</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="icon" href="${contextPath}/img/medical.ico" />
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.css'
	rel='stylesheet' />
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.js'></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/hammerjs@2.0.8"></script>
<script
	src="https://cdn.jsdelivr.net/npm/cornerstone-math@0.1.6/dist/cornerstoneMath.js"></script>
<script src="https://unpkg.com/cornerstone-core"></script>
<script src="https://unpkg.com/cornerstone-math"></script>
<script src="https://unpkg.com/cornerstone-wado-image-loader"></script>
<script
	src="https://cdn.jsdelivr.net/npm/cornerstone-web-image-loader@2.1.0/dist/cornerstoneWebImageLoader.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/cornerstone-wado-image-loader@3.1.0/dist/cornerstoneWADOImageLoader.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/dicom-parser@1.8.4/dist/dicomParser.js"></script>
<script src="${contextPath}/js/cornerstone/cornerstone.min.js"></script>
<script src="${contextPath}/js/cornerstone/cornerstoneMath.min.js"></script>
<script src="${contextPath}/js/cornerstone/dicomParser.min.js"></script>
<script
	src="https://unpkg.com/cornerstone-tools@4.22.1/dist/cornerstoneTools.js"></script>
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
	grid-template-areas: "patient-info symptoms view" "history status view"
		"diagnosis diagnosis diagnosis" "search prescriptions medicine"
		"search prescriptions drug";
	grid-gap: 8px;
	grid-template-columns: 1fr 1fr 2fr;
	grid-template-rows: auto auto auto 1fr;
}

.sidebar {
	grid-area: sidebar;
}

.section {
	diplay: grid;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	overflow-y: auto;
}

.section .dicom {
	width: 100px;
	height: 600px;
}

/* 기본 상태 - 두 개씩 나란히 배치 */
.responsive-view {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	height: 100%;
	overflow-y: auto;
	overflow-x: hidden;
}

.responsive-view .dicomImage {
	flex: 1 1 calc(50% - 10px); /* 두 열로 배치 */
	height: 200px; /* 고정된 높이 설정 */
	display: flex;
	align-items: center;
	justify-content: center;
}

/* 1000px 이하에서 한 열로 배치 */
@media ( max-width : 1000px) {
	.responsive-view .dicomImage {
		flex: 1 1 100%; /* 한 줄씩 배치 */
		height: 200px; /* 고정된 높이 유지 */
	}
}

/* 768px 이하에서 가로 스크롤 생기도록 설정 */
@media ( max-width : 768px) {
	.responsive-view {
		white-space: nowrap; /* div들이 한 줄로 나열되도록 설정 */
		overflow-x: auto; /* 좌우 스크롤 활성화 */
	}
	.responsive-view .dicomImage {
		display: inline-block; /* 한 줄로 나열 */
		width: 300px; /* 고정된 너비 */
		height: 300px; /* 고정된 높이 */
	}
}

/* 1000px 이상으로 돌아왔을 때 기본 2열 그리드로 복귀 */
@media ( min-width : 1001px) {
	.responsive-view .dicomImage {
		flex: 1 1 calc(50% - 10px); /* 두 열로 배치 */
		height: 200px; /* 고정된 높이 설정 */
	}
}

.section h2 {
	margin-top: 0;
	margin-bottom: -3px;
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

.section.dicom {
	width: 80%; /* 기존의 크기에서 줄임 */
	margin: 0 auto; /* 가운데 정렬 */
}

.section .view {
	grid-area: view;
	display: flex;
	flex-wrap: wrap;
	margin-bottom: 5px;
	gap: 8px;
	height: 100%;
	overflow-y: auto; /* 세로 스크롤 추가 */
	overflow-x: hidden; /* 가로 스크롤은 숨김 */
}

.view div {
	flex: 1 1 calc(50% - 8px); /* 각 div의 너비 조정 */
	height: 150px; /* 높이 조정 */
	background-color: #ddd;
	display: flex;
	align-items: center;
	justify-content: center;
}

.responsive-view .dicomImage {
	flex: 1 1 calc(50% - 10px); /* 두 열로 배치 */
	height: 200px; /* 고정된 높이 설정 */
	background-color: #ddd;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden; /* 이미지가 컨테이너를 넘어가지 않도록 설정 */
}

/* 900px 이하에서 한 열로 배치 */
@media ( max-width : 900px) {
	.responsive-view .dicomImage {
		flex: 1 1 100%; /* 한 줄씩 배치 */
		height: 200px; /* 고정된 높이 유지 */
	}
}

/* 600px 이하에서 가로 스크롤 생기도록 설정 */
@media ( max-width : 600px) {
	.responsive-view {
		overflow-x: auto; /* 좌우 스크롤 활성화 */
		white-space: nowrap; /* div들이 한 줄로 나열되도록 설정 */
	}
	.responsive-view .dicomImage {
		display: inline-block; /* 한 줄로 나열 */
		width: 300px; /* 고정된 너비 */
		height: 300px; /* 고정된 높이 */
	}
}

/* 901px 이상에서 2열 그리드로 복귀 */
@media ( min-width : 901px) {
	.responsive-view {
		overflow-x: hidden; /* 다시 기본 설정으로 복귀 */
		white-space: normal; /* 기본 줄바꿈 상태로 복귀 */
	}
	.responsive-view .dicomImage {
		display: flex; /* 다시 flexbox 레이아웃 적용 */
		flex: 1 1 calc(50% - 10px); /* 두 열로 배치 */
		height: 200px; /* 고정된 높이 유지 */
	}
}

.status {
	grid-area: status;
}

.diagnosis {
	grid-area: diagnosis;
	grid-column: span 3;
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

footer {
	display: flex;
	padding: 20px;
	border-top: 1px solid #ddd;
	background-color: #f8f8f8;
}

footer p {
	text-align: center;
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

.medicine-result, .drug-result {
	margin-bottom: 10px;
	cursor: pointer;
}

.search, .search2 {
	max-height: 300px;
	overflow-y: auto;
	overflow-x: hidden;
}

.prescriptions, .prescriptions2 {
	max-height: 300px;
	overflow-y: auto;
	overflow-x: auto;
}

.searchBox {
	align-content: center;
	margin-bottom: 10px;
}

.content h2 {
	padding: 10px
}

.form-container {
	width: 100%;
	max-width: 570px; /* 최대 너비를 설정하여 너무 넓지 않도록 제한 */
	padding: 10px;
	background-color: #e2e5e291;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	box-sizing: border-box;
	margin: 3px auto 3px auto;
}

.symptoms textarea {
	width: calc(100% - 6px); /* 부모 요소의 너비에서 margin을 뺀 값 */
	height: 280px;
	box-sizing: border-box;
	margin: 0px;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 5px;
	font-size: 16px;
	resize: none; /* 사용자가 크기 조정하지 못하도록 설정 */
	overflow-y: auto; /* 세로 스크롤 */
	overflow-x: hidden; /* 가로 스크롤 숨김 */
}

.symptoms textarea::placeholder {
	color: #aaa;
}

.history {
	grid-area: history;
	font-size: 13px; /* 폰트 크기를 줄였습니다. */
}

.history .table th {
	font-size: 12px; /* 표의 제목 부분 폰트 크기도 줄였습니다. */
}
/* 처방 표 폰트 크기 조정 */
.prescriptions .table, .drug .table {
	font-size: 14px; /* 전체 폰트 크기를 줄였습니다. */
}

.prescriptions .table th, .drug .table th {
	font-size: 12px; /* 표의 제목 부분 폰트 크기를 줄였습니다. */
}

.diagnosis-results, .medicine-results, .drug-results, .searchList {
	cursor: pointer;
}

.leftSidebar, .rightSidebar {
	background-color: #e9e9e9;
	width: 230px;
	padding: 10px;
	box-sizing: border-box;
	overflow-y: auto;
}

.scrollable-patient-list {
	max-height: 250px; /* 원하는 최대 높이 설정 */
	overflow-y: auto; /* 스크롤 생성 */
}

.buttonSection {
	display: flex;
	justify-content: flex-start;
	margin-bottom: 10px;
}

.viewer {
	background-color: #28a745; /* 주된 녹색 색상 */
	user-select: none;
	color: white; /* 글자색을 흰색으로 설정 */
	padding: 5px 10px; /* 버튼 안쪽 여백 */
	border: none; /* 테두리 제거 */
	border-radius: 8px; /* 둥근 모서리 */
	font-size: 0.75em; /* 글자 크기 설정 */
	font-weight: bold; /* 글자를 굵게 표시 */
	cursor: pointer; /* 커서가 손가락 모양으로 변경 */
	transition: background-color 0.3s, transform 0.2s, box-shadow 0.2s;
	color: white; /* 부드러운 전환 효과 */
}

.viewer:hover {
	background-color: #218838; /* 호버 시 조금 더 짙은 녹색으로 변경 */
	transform: translateY(-2px); /* 호버 시 버튼을 약간 위로 이동 */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
}

.viewer:active {
	background-color: #1e7e34; /* 클릭 시 더 짙은 녹색 */
	transform: translateY(0); /* 클릭 시 원래 위치로 복원 */
	box-shadow: none; /* 클릭 시 그림자 제거 */
}
</style>

</head>

<body>
	<span id="contextPath" hidden>${contextPath}</span>
	<header>
		<nav>
			<div class="logo">
				<img src="/Img/Logo.png" alt="Logo">
			</div>
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
				<button>새로고침</button>
			</div>
			<div class="patient-list" id="all-patients">
				<h2>진료 대기 목록</h2>
				<div class="scrollable-patient-list">
					<ul>
						<c:forEach var="patient" items="${patientList}">
							<li onclick="showPatientInfo(${patient.no})">${patient.name}</li>
						</c:forEach>
					</ul>
				</div>
			</div>
			<div class="patient-list" id="managed-patients"
				style="display: none;">
				<h2>진료 완료 목록</h2>
				<div class="scrollable-patient-list">
					<ul>
						<li>환자 A</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
						<li>환자 B</li>
					</ul>
				</div>
			</div>
			<div id='calendar'></div>
		</section>
		<section class="content">
			<div id="patient-info" class="section patient-info">
				<h2>환자 정보</h2>
				<p>
					이름: <span id="patient-name"></span>
				</p>
				<p>
					생년월일: <span id="patient-birthdate"></span>
				</p>
				<p>
					체중: <span id="patient-weight"></span>
				</p>
				<p>
					키: <span id="patient-height"></span>
				</p>
				<p>
					내원일: <span id="patient-visit-date"></span>
				</p>
				<p>
					알레르기: <span id="patient-allergies"></span>
				</p>
				<p>
					흡연여부: <span id="patient-smoking-status"></span>
				</p>
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
				<textarea id="symptoms" name="symptoms" placeholder="증상을 입력하세요"></textarea>
			</div>
			<!-- 이미지 확인 테스트  -->
			<div class="section dicom">
				<div class="buttonSection">
					<button class="viewer">자세히 보기</button>
				</div>
				<div class="view  responsive-view" style="grid-row: span 2;">
					<div class="dicomImage" data-value="0"></div>
					<div class="dicomImage" data-value="1"></div>
					<div class="dicomImage" data-value="2"></div>
					<div class="dicomImage" data-value="3"></div>
				</div>
			</div>

			<!-- 질병 API -->
			<div class="section search diagnosis" style="grid-column: span 1;">
				<h2>질병 검색</h2>
				<input type="text" id="diagnosis-name" class="searchBox"
					placeholder="질병명" onchange="searchDiagnosis()">
				<div id="diagnosis-results" style="max-height: 350px;">
					<!-- 검색 결과가 여기에 추가됩니다 -->
				</div>
			</div>
			<div class="section prescriptions diagnosis"
				style="grid-column: span 2;">
				<h2>상병</h2>
				<table class="table" id="diagnosis">
					<thead>
						<tr>
							<th>질병 코드</th>
							<th>질병 명칭</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<!-- 질병 리스트가 여기에 추가 -->
					</tbody>
				</table>
			</div>


			<!-- 약품 검색 api -->
			<div class="section search medicine">
				<h2>약품 검색</h2>
				<input type="text" class="searchBox" id="medicine-name"
					placeholder="약품명" onchange="searchMedicine()">
				<div id="medicine-results" style="max-height: 350px;">
					<!-- 검색 결과가 여기에 추가됩니다 -->
				</div>
			</div>
			<div class="section prescriptions medicine"
				style="grid-column: span 2;">
				<h2>처방</h2>
				<table class="table" id="prescriptions">
					<thead>
						<tr>
							<th>약품 코드</th>
							<th>업체명</th>
							<th>약품명(한글)</th>
							<th>복용법</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<!-- 처방 리스트가 여기에 추가 -->
					</tbody>
				</table>
			</div>

			<!--약물 검색 api-->
			<div class="section search drug">
				<h2>약물 검색</h2>
				<input type="text" class="searchBox" id="drug-name"
					placeholder="약물명" onchange="searchDrug()">
				<div id="drug-results" style="max-height: 350px;">
					<!-- 검색 결과가 여기에 추가됩니다 -->
				</div>
			</div>
			<div class="section prescriptions drug" style="grid-column: span 2;">
				<h2>약물 목록</h2>
				<table class="table" id="drugPrescriptions">
					<thead>
						<tr>
							<th>성분코드</th>
							<th>성분명(한글)</th>
							<th>제형명</th>
							<th>투여경로</th>
							<th>투여 단위</th>
							<th>1일 최대 투여량</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<!-- 처방 리스트가 여기에 추가 -->
					</tbody>
				</table>
			</div>
		</section>
	</main>
	<input type="text" id="pid" value="${patient.no}" hidden />

	<script>
		$(document)
				.ready(
						function() {
							// API 검색 결과 클릭 외 영역 클릭 시 닫힘
							$(document)
									.click(
											function(e) {
												const target = $(e.target);

												// 클릭한 영역이 질병 검색결과와 관련 없으면 닫기
												if (!target
														.closest('#diagnosis-name').length
														&& !target
																.closest('#diagnosis-results').length) {
													$('#diagnosis-results')
															.hide();
												}

												// 클릭한 영역이 약품 검색결과와 관련 없으면 닫기
												if (!target
														.closest('#medicine-name').length
														&& !target
																.closest('#medicine-results').length) {
													$('#medicine-results')
															.hide();
												}

												// 클릭한 영역이 약물 검색결과와 관련 없으면 닫기
												if (!target
														.closest('#drug-name').length
														&& !target
																.closest('#drug-results').length) {
													$('#drug-results').hide();
												}
											});

							// 질병 검색창에 포커스가 있으면 검색결과를 다시 보여줌
							$('#diagnosis-name').on('focus', function() {
								$('#diagnosis-results').show();
							});

							// 약품 검색창에 포커스가 있으면 검색결과를 다시 보여줌
							$('#medicine-name').on('focus', function() {
								$('#medicine-results').show();
							});

							// 약물 검색창에 포커스가 있으면 검색결과를 다시 보여줌
							$('#drug-name').on('focus', function() {
								$('#drug-results').show();
							});
						});

		//질병 검색 api
		function searchDiagnosis() {
			const diagnosisName = $('#diagnosis-name').val().trim();

			$
					.ajax({
						url : '/api/doctor/diagnosisSearch',
						method : 'GET',
						data : {
							query : diagnosisName
						},
						dataType : 'xml', // XML 데이터 타입으로 설정
						success : function(xml) {
							$('#diagnosis-results').empty(); // 기존 결과를 비움
							$('#diagnosis tbody').empty(); // 테이블의 기존 데이터를 비움 (선택적으로 초기화할 수 있음)

							const items = $(xml).find('item'); // XML에서 item 태그를 찾아 반복 처리

							if (items.length === 0) {
								$('#diagnosis-results').append(
										'<p>검색 결과가 없습니다.</p>');
								return;
							}

							// 검색된 각 item에 대한 처리
							items
									.each(function() {
										const diseaseCode = $(this).find(
												'disease_code').text();
										const diseaseName = $(this).find(
												'disease_name').text();

										// 검색 결과를 화면에 표시 (클릭 이벤트 추가)
										const resultDiv = $('<div class="diagnosis-results">'
												+ diseaseName + '</div>');
										resultDiv.on('click', function() {
											addDiagnosisToTable(diseaseCode,
													diseaseName);
										});
										$('#diagnosis-results').append(
												resultDiv);
									});
						},
						error : function(error) {
							$('#diagnosis-results').html('<p>오류가 발생했습니다.</p>');
						}
					});
		}

		// 질병 항목을 테이블에 추가하는 함수
		function addDiagnosisToTable(diseaseCode, diseaseName) {

			const newRowHtml = '<tr>'
					+ '<td>'
					+ diseaseCode
					+ '</td>'
					+ '<td>'
					+ diseaseName
					+ '</td>'
					+ '<td><button class="searchList" onclick="$(this).closest(\'tr\').remove()">X</button></td>'
					+ '</tr>';

			$('#diagnosis tbody').append(newRowHtml);
		}

		//약품 검색 API
		function searchMedicine() {
			const medicineName = $('#medicine-name').val().trim();

			$.ajax({
				url : '/api/doctor/prescriptionsSearch',
				method : 'GET',
				data : {
					query : medicineName
				},
				dataType : 'xml',
				success : function(xml) {
					$('#medicine-results').empty();
					$('#prescriptions tbody').empty();

					const items = $(xml).find('item');

					if (items.length === 0) {
						$('#medicine-results').append('<p>검색 결과가 없습니다.</p>');
						return;
					}

					items.each(function() {
						const itemSeq = $(this).find('itemSeq').text();
						const entpName = $(this).find('entpName').text();
						const itemName = $(this).find('itemName').text();
						const useMethod = $(this).find('useMethodQesitm')
								.text();

						const resultDiv = $('<div class="medicine-results">'
								+ itemName + '</div>');
						resultDiv.on('click', function() {
							addMedicineToTable(itemSeq, itemName, entpName,
									useMethod);
						});
						$('#medicine-results').append(resultDiv);
					});
				},
				error : function() {
					$('#medicine-results').html('<p>오류가 발생했습니다.</p>');
				}
			});
		}

		//약품 목록에 추가
		function addMedicineToTable(itemSeq, itemName, entpName, useMethod) {
			const newRowHtml = '<tr>'
					+ '<td>'
					+ itemSeq
					+ '</td>'
					+ '<td>'
					+ itemName
					+ '</td>'
					+ '<td>'
					+ useMethod
					+ '</td>'
					+ '<td>'
					+ entpName
					+ '</td>'
					+ '<td><button class="searchList" onclick="$(this).closest(\'tr\').remove()">X</button></td>'
					+ '</tr>';
			$('#prescriptions tbody').append(newRowHtml);
		}

		// 약물 검색 API
		function searchDrug() {
			const drugName = $('#drug-name').val().trim();

			$.ajax({
				url : '/api/doctor/drugSearch',
				method : 'GET',
				data : {
					query : drugName
				},
				dataType : 'xml',
				success : function(xml) {
					$('#drug-results').empty();
					$('#drugPrescriptions tbody').empty();

					const items = $(xml).find('item');

					if (items.length === 0) {
						$('#drug-results').append('<p>검색 결과가 없습니다.</p>');
						return;
					}

					items.each(function() {
						const cpntCd = $(this).find('cpntCd').text();
						const ingdNameKor = $(this).find('drugCpntKorNm')
								.text();
						const fomlNm = $(this).find('fomlNm').text();
						const dosageRouteCode = $(this).find('dosageRouteCode')
								.text();
						const dayMaxDosgQyUnit = $(this).find(
								'dayMaxDosgQyUnit').text();
						const dayMaxDosgQy = $(this).find('dayMaxDosgQy')
								.text();

						const resultDiv = $('<div class="drug-results">'
								+ ingdNameKor + '</div>');
						resultDiv.on('click', function() {
							addDrugToTable(cpntCd, ingdNameKor, fomlNm,
									dosageRouteCode, dayMaxDosgQyUnit,
									dayMaxDosgQy);
						});
						$('#drug-results').append(resultDiv);
					});
				},
				error : function() {
					$('#drug-results').html('<p>오류가 발생했습니다.</p>');
				}
			});
		}

		//약물 목록에 추가
		function addDrugToTable(cpntCd, ingdNameKor, fomlNm, dosageRouteCode,
				dayMaxDosgQyUnit, dayMaxDosgQy) {
			const newRowHtml = '<tr>'
					+ '<td>'
					+ cpntCd
					+ '</td>'
					+ '<td>'
					+ ingdNameKor
					+ '</td>'
					+ '<td>'
					+ fomlNm
					+ '</td>'
					+ '<td>'
					+ dosageRouteCode
					+ '</td>'
					+ '<td>'
					+ dayMaxDosgQyUnit
					+ '</td>'
					+ '<td>'
					+ dayMaxDosgQy
					+ '</td>'
					+ '<td><button class="searchList" onclick="$(this).closest(\'tr\').remove()">X</button></td>'
					+ '</tr>';

			$('#drugPrescriptions tbody').append(newRowHtml);
		}

		/*전체 환자 관리 환자 */
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

		//환자 관리 목록
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

			document.querySelectorAll('.tab').forEach(function(tab) {
				tab.classList.remove('active');
			});
			document.getElementById(tabId).classList.add('active');
		}

		//프로필 활동상태
		function setStatus(status, color) {
			document.querySelector('.status-indicator').style.backgroundColor = color;
		}


		/*달력 API 함수*/
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
				dayCellContent : function(e) {
					e.dayNumberText = e.dayNumberText.replace('일', ''); // '일' 문자 제거
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

		/*API 데이터 DB에 저장*/
		function saveData() {
			// 진단 데이터 수집
			const diagnosisData = [];
			$('#diagnosis tbody tr').each(function() {
				const diseaseCode = $(this).find('td:nth-child(1)').text();
				const diseaseName = $(this).find('td:nth-child(2)').text();
				diagnosisData.push({
					disease_code : diseaseCode,
					disease_name : diseaseName
				});
			});

			// 처방 데이터 수집
			const prescriptionData = [];
			$('#prescriptions tbody tr').each(function() {
				const itemSeq = $(this).find('td:nth-child(1)').text();
				const itemName = $(this).find('td:nth-child(2)').text();
				const useMethod = $(this).find('td:nth-child(3)').text();
				const entpName = $(this).find('td:nth-child(4)').text();
				prescriptionData.push({
					itemSeq : itemSeq,
					itemName : itemName,
					useMethodQesitm : useMethod,
					entpName : entpName
				});
			});

			// 약물 데이터 수집
			const drugData = [];
			$('#drugPrescriptions tbody tr').each(
					function() {
						const cpntCd = $(this).find('td:nth-child(1)').text();
						const ingdNameKor = $(this).find('td:nth-child(2)')
								.text();
						const fomlNm = $(this).find('td:nth-child(3)').text();
						const dosageRouteCode = $(this).find('td:nth-child(4)')
								.text();
						const dayMaxDosgQyUnit = $(this)
								.find('td:nth-child(5)').text();
						const dayMaxDosgQy = $(this).find('td:nth-child(6)')
								.text();
						drugData.push({
							cpntCd : cpntCd,
							drugCpntKorNm : ingdNameKor,
							fomlNm : fomlNm,
							dosageRouteCode : dosageRouteCode,
							dayMaxDosgQyUnit : dayMaxDosgQyUnit,
							dayMaxDosgQy : dayMaxDosgQy
						});
					});

			// 데이터 저장 요청을 서버로 전송
			const requestData = {
				diagnosis : diagnosisData,
				prescriptions : prescriptionData,
				drugs : drugData
			};

			$.ajax({
				url : '/api/doctor/saveAllPrescriptions',
				method : 'POST',
				contentType : 'application/json',
				data : JSON.stringify(requestData),
				success : function(response) {
					alert("저장되었습니다.");
				},
				error : function(error) {
					console.error("저장 중 오류 발생", error);
					alert("저장 중 오류가 발생했습니다.");
				}
			});
		}
		
		
		
		
	    // cornerstone 관련 설정
	    console.log("Setting external libraries");
	    cornerstoneWADOImageLoader.external.cornerstone = cornerstone;
	    cornerstoneWebImageLoader.external.cornerstone = cornerstone;
	    cornerstoneTools.external.cornerstone = cornerstone;
	    cornerstoneTools.external.Hammer = Hammer;
	    cornerstoneWADOImageLoader.external.dicomParser = dicomParser;

	    // 이미지 로더 등록
	    console.log("Configuring image loader");
	    cornerstoneWADOImageLoader.configure({});
	    
	    let originalImageSize = null;
	    let currentViewport = null;
	    let contextPath = $('#contextPath').text();

	    const elements = document.querySelectorAll('.dicomImage'); // 모든 dicomImage div 요소 선택
		
	    // 모든 dicomImage 요소를 cornerstone에 활성화
	    elements.forEach(element => {
	        cornerstone.enable(element);
	    });
	    
	    
	 // 자세히 보기 버튼 이벤트
	    $('.viewer').on('click', function() {
	        // pid 값을 input 필드에서 가져오기
	        const pid = document.getElementById('pid').value;
	        console.log("pid : ",pid);
	        // 서버로 POST 요청 전송
	        fetch(contextPath + '/viewer', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json'
	            },
	            body: JSON.stringify({ pid: pid })
	        })
	        .then(response => {
	            if (response.ok) {
	                // 성공적으로 처리된 경우, pid를 쿼리 파라미터로 전달하여 새로운 페이지로 이동
	                window.location.href = contextPath + `/viewer?pid=${pid}`;
	            } else {
	                console.error('서버 응답 오류');
	            }
	        })
	        .catch(error => {
	            console.error('요청 중 오류 발생', error);
	        });
	    });



window.addEventListener('resize', function() {
    adjustLayout();
});
function adjustLayout() {
    const screenWidth = window.innerWidth;
    
    // 900px 이상일 경우 2x2 레이아웃으로 설정
    if (screenWidth >= 901) {
        document.querySelectorAll('.responsive-view .dicomImage').forEach(element => {
            element.style.flex = "1 1 calc(50% - 10px)";
            element.style.height = "200px";
            element.style.display = "flex";
        });
    } 
    // 900px 이하일 경우 1열 레이아웃으로 설정
    else if (screenWidth < 900 && screenWidth > 600) {
        document.querySelectorAll('.responsive-view .dicomImage').forEach(element => {
            element.style.flex = "1 1 100%";
            element.style.height = "200px";
            element.style.display = "flex";
        });
    }
    // 600px 이하일 경우 inline-block 레이아웃 설정
    else if (screenWidth <= 600) {
        document.querySelectorAll('.responsive-view .dicomImage').forEach(element => {
            element.style.display = "inline-block";
            element.style.width = "300px";
            element.style.height = "300px";
        });
    }
}

// 페이지 로드 시 레이아웃 조정
adjustLayout();
		
function showPatientInfo(patientNo) {
    $.ajax({
        url: '/getPatientInfo',
        method: 'GET',
        data: { no: patientNo }, // 환자 ID를 전달
        success: function(data) {
            // 서버로부터 받은 환자 정보를 HTML에 표시
            const patient = data;
            $('#patient-name').text(patient.name);
            $('#patient-birthdate').text(patient.securityNum);
            $('#patient-weight').text(patient.weight + 'kg');
            $('#patient-height').text(patient.height + 'cm');
            $('#patient-address').text(patient.address);
            $('#patient-phone').text(patient.phone);
            $('#patient-email').text(patient.email);
            $('#patient-bloodType').text(patient.bloodType);
            $('#patient-bloodPressure').text(patient.bloodPressure);
            $('#patient-temperature').text(patient.temperature + '°C');
            $('#patient-allergies').text(patient.allergies);
            $('#patient-smoking-status').text(patient.smokingStatus === 'Y' ? '흡연' : '비흡연');
            $('#pid').val(patient.no);
            
            // pid 값을 업데이트한 후 확인
            console.log("Updated pid:", $('#pid').val());

            // 이 시점에서 pid 값을 가져와도 문제없어야 함
            const pid = $('#pid').val();
            console.log("Final pid:", pid);
            // DICOM 파일을 화면에 표시
            const dicomFiles = patient.dicomFiles;
            if (dicomFiles && dicomFiles.length > 0) {
                dicomFiles.forEach((fileData, index) => {
                    const byteCharacters = atob(fileData.file_data); // Base64 디코딩
                    const byteNumbers = new Array(byteCharacters.length);
                    for (let i = 0; i < byteCharacters.length; i++) {
                        byteNumbers[i] = byteCharacters.charCodeAt(i);
                    }
                    const byteArray = new Uint8Array(byteNumbers);
                    const fileBlobUrl = URL.createObjectURL(new Blob([byteArray]));
                    const imageId = 'wadouri:' + fileBlobUrl;

                    // DICOM 이미지를 해당 요소에 로드
                    if (index < $('.dicomImage').length) {
                        const element = $('.dicomImage')[index];
                        cornerstone.loadImage(imageId).then(function(image) {
                            cornerstone.displayImage(element, image);
                        }).catch(function(err) {
                            console.error('Error loading image:', err);
                        });
                    }
                });
            } else {
                console.log('No DICOM files found for this patient.');
            }
        },
        error: function(xhr, status, error) {
            console.error("Error fetching patient info:", xhr.responseText);
        }
    });
}






		
		
		
	</script>
</body>
<footer> </footer>
</html>