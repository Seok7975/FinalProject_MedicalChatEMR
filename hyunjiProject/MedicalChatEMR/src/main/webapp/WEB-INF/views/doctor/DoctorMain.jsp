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
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	overflow-y: auto;
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

.view {
	grid-area: view;
	display: flex;
	flex-wrap: wrap;
	height: auto;
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
	height: 200px;
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
				<textarea id="Symptoms" name="symptoms" placeholder="증상을 입력하세요"></textarea>
			</div>
			<div class="section view" style="grid-row: span 2;">
				<div>이미지뷰</div>
				<div>이미지뷰</div>
				<div>이미지뷰</div>
				<div>이미지뷰</div>
			</div>
			<div class="section diagnosis" style="grid-column: span 3;">
				<h2>상병</h2>
				<p>상병 정보가 여기에 표시됩니다.</p>
			</div>

			<!-- 약품 검색 api -->
			<div class="section search medicine">
				<h2>약품 검색</h2>
				<input type="text" class="searchBox" id="medicine-name"
					placeholder="약품명" oninput="searchMedicine()">
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
							<th>약품명(한글)</th>
							<th>복용법</th>
							<th>업체명</th>
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
					placeholder="약물명" oninput="searchDrug()">
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
	<script>
	
	/*처방 - open api 사용 >> 약물*/
function searchDrug() {
    const drugName = document.getElementById('drug-name').value.trim();
    const resultsDiv = document.getElementById('drug-results');

    const encodedName = encodeURIComponent(drugName);
    fetch('/api/doctor/drugSearch?query=' + encodedName, {
        headers: {
            'Accept': 'application/xml',
        }
    })
    .then(response => response.text())
    .then(str => {
        // XML 데이터를 문자열로 출력
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(str, "application/xml");

        // 올바른 태그 이름으로 데이터 파싱
        const items = xmlDoc.getElementsByTagName('item');

        if (items.length === 0) {
            resultsDiv.innerHTML = '<p>검색된 약품이 없습니다.</p>';
            return;
        }

        resultsDiv.innerHTML = '';  // 기존 내용을 지우고 새로 추가

        for (let i = 0; i < items.length; i++) {
            const drugDiv = document.createElement('div');
            drugDiv.classList.add('drug-result');

            // XML 태그 이름을 정확하게 사용하여 데이터를 읽어옴
            const ingdNameKor = items[i].getElementsByTagName('drugCpntKorNm')[0]?.textContent || '정보 없음';

            // 텍스트가 올바르게 설정되도록 수정
            drugDiv.textContent = ingdNameKor;

            const drugData = {
                cpntCd: items[i].getElementsByTagName('cpntCd')[0]?.textContent || '정보 없음',
                ingdNameKor: ingdNameKor,
                fomlNm: items[i].getElementsByTagName('fomlNm')[0]?.textContent || '정보 없음',
                dosageRouteCode: items[i].getElementsByTagName('dosageRouteCode')[0]?.textContent || '정보 없음',
                dayMaxDosgQyUnit: items[i].getElementsByTagName('dayMaxDosgQyUnit')[0]?.textContent || '정보 없음',
                dayMaxDosgQy: items[i].getElementsByTagName('dayMaxDosgQy')[0]?.textContent || '정보 없음'
            };

            // 클릭하면 처방에 추가
            drugDiv.onclick = () => addPrescription(drugData);

            resultsDiv.appendChild(drugDiv);
        }
    })
    .catch(error => {
        resultsDiv.innerHTML = '<p>약품 데이터를 가져오는 중 오류가 발생했습니다.</p>';
    });
}

/*약물 클릭하면 목록으로 이동하게끔 + 삭제 기능 추가 예정 */
function addPrescription(drugData) {
    const drugPrescriptionTable = document.getElementById('drugPrescriptions').getElementsByTagName('tbody')[0];

    const newRow = drugPrescriptionTable.insertRow();

    newRow.insertCell(0).textContent = drugData.cpntCd || '정보 없음';
    newRow.insertCell(1).textContent = drugData.ingdNameKor || '정보 없음';
    newRow.insertCell(2).textContent = drugData.fomlNm || '정보 없음';
    newRow.insertCell(3).textContent = drugData.dosageRouteCode || '정보 없음';
    newRow.insertCell(4).textContent = drugData.dayMaxDosgQyUnit || '정보 없음';
    newRow.insertCell(5).textContent = drugData.dayMaxDosgQy || '정보 없음';
}

/* 처방 - open api 사용 >> 약품 */
function searchMedicine() {
    const medicineName = document.getElementById('medicine-name').value.trim();
    const resultsDiv = document.getElementById('medicine-results');

    const encodedName = encodeURIComponent(medicineName);
    fetch('/api/doctor/prescriptionsSearch?query=' + encodedName, {
        headers: {
            'Accept': 'application/xml',
        }
    })
    .then(response => response.text())
    .then(str => {
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(str, "application/xml");

        const items = xmlDoc.getElementsByTagName('item');

        if (items.length === 0) {
            resultsDiv.innerHTML = '<p>검색된 약품이 없습니다.</p>';
            return;
        }

        resultsDiv.innerHTML = '';  // 기존 내용을 지우고 새로 추가

        for (let i = 0; i < items.length; i++) {
            const medicineDiv = document.createElement('div');
            medicineDiv.classList.add('medicine-result');

         // 각 필드를 올바른 태그 이름으로 가져옴
            const itemSeq = items[i].getElementsByTagName('itemSeq')[0]?.textContent || '정보 없음'; //약품 코드
            const entpName = items[i].getElementsByTagName('entpName')[0]?.textContent || '정보 없음'; //약품 회사
            const itemName = items[i].getElementsByTagName('itemName')[0]?.textContent || '정보 없음'; //약품 명
            const useMethodQesitm = items[i].getElementsByTagName('useMethodQesitm')[0]?.textContent || '정보 없음'; //복용 방법


            medicineDiv.textContent = itemName;  // 화면에 약품명을 표시

            const medicineData = {
                    entpName: entpName,
                    itemSeq: itemSeq,
                    itemName: itemName,
                    useMethodQesitm: useMethodQesitm
                };

            // 클릭하면 처방에 추가
            medicineDiv.onclick = () => addMedicinePrescription(medicineData);

            resultsDiv.appendChild(medicineDiv);
        }
    })
    .catch(error => {
        resultsDiv.innerHTML = '<p>약품 데이터를 가져오는 중 오류가 발생했습니다.</p>';
    });
}

function addMedicinePrescription(medicineData) {
    const prescriptionTable = document.getElementById('prescriptions').getElementsByTagName('tbody')[0];

    const newRow = prescriptionTable.insertRow();

    newRow.insertCell(0).textContent = medicineData.itemSeq || '정보 없음';  // 약품 코드
    newRow.insertCell(1).textContent = medicineData.entpName || '정보 없음';  // 약품회사
    newRow.insertCell(1).textContent = medicineData.itemName || '정보 없음';  // 약품명
    newRow.insertCell(2).textContent = medicineData.useMethodQesitm || '정보 없음';  // 복용방법
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
		// 처방 삭제 기능 추가
		function addMedicinePrescription(medicineData) {
		    const prescriptionTable = document.getElementById('prescriptions').getElementsByTagName('tbody')[0];

		    const newRow = prescriptionTable.insertRow();

		    newRow.insertCell(0).textContent = medicineData.itemSeq || '정보 없음';  // 약품 코드
		    newRow.insertCell(1).textContent = medicineData.entpName || '정보 없음';  // 약품회사
		    newRow.insertCell(2).textContent = medicineData.itemName || '정보 없음';  // 약품명
		    newRow.insertCell(3).textContent = medicineData.useMethodQesitm || '정보 없음';  // 복용방법

		    // 삭제 버튼 추가
		    const deleteCell = newRow.insertCell(4);
		    const deleteButton = document.createElement('button');
		    deleteButton.textContent = 'X';
		    deleteButton.onclick = function () {
		        prescriptionTable.deleteRow(newRow.rowIndex - 1);
		    };
		    deleteCell.appendChild(deleteButton);
		}

		// 약물 목록 삭제 기능 추가
		function addPrescription(drugData) {
		    const drugPrescriptionTable = document.getElementById('drugPrescriptions').getElementsByTagName('tbody')[0];

		    const newRow = drugPrescriptionTable.insertRow();

		    newRow.insertCell(0).textContent = drugData.cpntCd || '정보 없음';
		    newRow.insertCell(1).textContent = drugData.ingdNameKor || '정보 없음';
		    newRow.insertCell(2).textContent = drugData.fomlNm || '정보 없음';
		    newRow.insertCell(3).textContent = drugData.dosageRouteCode || '정보 없음';
		    newRow.insertCell(4).textContent = drugData.dayMaxDosgQyUnit || '정보 없음';
		    newRow.insertCell(5).textContent = drugData.dayMaxDosgQy || '정보 없음';

		    // 삭제 버튼 추가
		    const deleteCell = newRow.insertCell(6);
		    const deleteButton = document.createElement('button');
		    deleteButton.textContent = 'X';
		    deleteButton.onclick = function () {
		        drugPrescriptionTable.deleteRow(newRow.rowIndex - 1);
		    };
		    deleteCell.appendChild(deleteButton);
		}
	</script>
</body>
<footer> </footer>
</html>
