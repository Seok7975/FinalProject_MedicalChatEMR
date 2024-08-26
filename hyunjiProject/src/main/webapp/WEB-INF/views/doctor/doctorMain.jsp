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

header {
	width: 100%;
	background-color: #b8edb5;
	padding: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	margin-bottom: 8px;
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
		"diagnosis diagnosis prescriptions" "medicine medicine prescriptions2"
		"drug drug prescriptions3";
	grid-gap: 8px;
	grid-template-columns: 1fr 1fr 2fr;
	grid-template-rows: auto auto auto auto auto;
}

.sidebar {
	grid-area: sidebar;
}

.section {
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	position: relative;
	overflow: hidden; /* 기본적으로 섹션 내에서 스크롤을 감춤 */
}

.section h2 {
	margin: 0;
	padding: 10px;
	background-color: #fafafa;
	position: sticky;
	top: 0;
	z-index: 5;
}

.patient-info {
	grid-area: patient-info;
}

.section .content-scrollable {
	max-height: calc(100% - 40px); /* h2 높이만큼 빼고 나머지 영역에 스크롤 적용 */
	overflow-y: auto; /* 세로 스크롤 생성 */
	padding-top: 10px;
}
/* 내부 콘텐츠가 h2에 가리지 않도록 padding-top 조정 */
.section-content {
	padding-top: 20px;
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
}

.status {
	grid-area: status;
}

.diagnosis {
	grid-area: diagnosis;
}

.table {
	width: 100%;
	border-collapse: collapse;
}

.table th, .table td {
	border: 1px solid #ddd;
	padding: 8px;
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

.patient-details {
	margin-left: 15px;
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
	margin: 10px;
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
	height: 370px;
	box-sizing: border-box;
	margin-left: 3px;
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

.patient-symptoms {
	height: 340px;
	margin: 15px;
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

.diagnosis-results, .medicine-results, .drug-results {
	cursor: pointer;
	margin-left: 15px;
}

.leftSidebar, .rightSidebar {
	background-color: #e9e9e9;
	width: 230px;
	padding: 10px;
	box-sizing: border-box;
	overflow-y: auto;
}

.scrollable-patient-list {
	max-height: 300px; /* 원하는 최대 높이 설정 */
	overflow-y: auto; /* 스크롤 생성 */
}

button.searchList {
	background-color: transparent; /* 배경색 제거 */
	border: none; /* 테두리 제거 */
	font-weight: bold; /* X자 진하게 */
	font-size: 16px; /* 기본 크기 설정 */
	cursor: pointer; /* 클릭 가능한 커서 표시 */
	transition: transform 0.2s ease-in-out; /* 애니메이션 부드럽게 */
}

button.searchList:hover {
	transform: scale(1.2); /* 마우스 오버 시 1.3배 커지게 */
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

.tab-buttons {
	display: flex;
	margin-bottom: 20px;
}

.symptoms .buttons {
	margin: 4px;
	text-align: right;
}

.symptoms .buttons button {
	margin-left: 10px;
	padding: 8px 12px;
	font-size: 14px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.symptoms .buttons button:hover {
	background-color: #45a049;
}

div.scrollable-patient-list {
	max-height: 250px; /* 원하는 최대 높이 설정 */
	overflow-y: auto; /* 스크롤 생성 */
}

.patient-item {
	padding: 10px;
	border-bottom: 1px solid #ddd;
	cursor: pointer;
	text-align: center
}

.patient-item:hover {
	background-color: #f0f0f0;
	text-decoration: none;
}

#visitReason {
	width: 100%;
	height: 150px;
	box-sizing: border-box;
	resize: vertical;
	font-size: 15px;
}

#all-patients {
	display: block; /* 진료 대기 목록은 기본적으로 보임 */
}

#managed-patients {
	display: none; /* 전체 환자 목록은 처음에 숨김 */
}
/* ul과 li 요소의 기본 패딩과 마진 제거 (진료 대기 목록과 전체 환자 목록에 동일한 스타일 적용) */
ul, #patientList {
	padding: 0;
	margin: 0;
	list-style-type: none; /* 리스트 아이콘 제거 */
}

.patient-item, #all-patients li {
	padding: 10px; /* 리스트 아이템에만 패딩 추가 */
	border-bottom: 1px solid #ddd;
	cursor: pointer;
	text-align: left; /* 왼쪽 정렬을 유지합니다 */
}

.patient-item:hover, #all-patients li:hover {
	background-color: #f0f0f0; /* hover 시 동일한 스타일 적용 */
	text-decoration: none;
}

.section.history tbody tr {
	cursor: pointer;
}

.section.history tbody tr:hover {
	color: blue;
	cursor: pointer;
}

/* 진료 작성 모드에서만 삭제 칼럼 보이도록 설정 */
.prescriptions .table th.delete-column, .prescriptions .table td.delete-column
	{
	display: none;
}

.prescriptions .table.show-delete th.delete-column, .prescriptions .table.show-delete td.delete-column
	{
	display: table-cell;
}

/* 진료 기록의 회색 표시 스타일 */
.selected-record {
	color: lightgray;
}

/* 모달 스타일 */
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
	margin: 15% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 80%;
	max-width: 600px;
	border-radius: 8px;
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
	<header>
		<nav>
			<div class="logo">
				<img src="/img/Logo.png" alt="Logo">
			</div>
			<button id="messages-btn" class="nav-btn">Message</button>
			<button id="chat-ai-btn" class="nav-btn">CHAT AI</button>
			<div class="profile-info">
				<img id="profile-image" src="doctorProfile.png" alt="Profile Image">
				<div class="status-indicator"></div>
				<form id="logout-form" action="/logout" method="POST">
					<button id="logout-btn" class="logout-btn">Log Out</button>
				</form>
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
	<!-- 모달 창 -->
	<div id="chatModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<h2>Chat with AI</h2>
			<div id="chatContent"
				style="max-height: 300px; overflow-y: auto; margin-bottom: 10px;">
				<!-- Chat content will appear here -->
			</div>
			<input type="text" id="userInput"
				placeholder="Type your message here" style="width: 80%;">
			<button id="sendChatBtn">Send</button>
		</div>
	</div>
	<main class="container">
		<section class="sidebar">
			<div class="tab-buttons">
				<div class="tab" id="tab-waiting-patients">진료 대기 환자</div>
				<div class="tab active" id="tab-all-patients">전체 환자 목록</div>

			</div>
			<div class="search-section">
				<input type="text" placeholder="환자검색">
				<button>검색</button>
				<button>새로고침</button>
			</div>
			<div class="scrollable-patient-list" id="waiting-patients"
				style="display: none;">
				<h2>진료 대기 목록</h2>
				<ul id="waitingList">
					<li>환자1</li>
					<li>환자2</li>
				</ul>
			</div>
			<div class="scrollable-patient-list" id="all-patients"
				style="display: block;">
				<h2>전체 환자 목록</h2>
				<hr>
				<ul id="patientList"></ul>
			</div>

			<div id='calendar'></div>
		</section>
		<section class="content">
			<div class="section patient-info">
				<h2>환자 정보</h2>
				<div class="patient-details">
					<p>환자를 선택하세요</p>
				</div>
			</div>

			<div class="section history">
				<h2>과거 진료 이력</h2>
				<table class="table">
					<thead>
						<tr>
							<th>진료 날짜</th>
							<th>담당 의사</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2">진료 기록 없음</td>
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
							<td>정보 없음</td>
						</tr>
						<tr>
							<td>체온</td>
							<td>정보 없음</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="section symptoms">
				<h2>증상</h2>
				<div class="patient-symptoms"></div>
				<textarea style="display: none;" placeholder="환자의 증상을 입력하세요..."></textarea>
				<div class="buttons">
					<button id="createDiagnosisBtn">진료
						작성</button>
					<button id="saveDataBtn" style="display: none;"
						onclick="saveData()">저장</button>
				</div>
			</div>

			<div class="section view" style="grid-row: span 2;">
				<div>정보 없음</div>
				<div>정보 없음</div>
				<div>정보 없음</div>
				<div>정보 없음</div>
			</div>

			<div class="section search diagnosis" style="grid-column: span 1;">
				<h2>질병 검색</h2>
				<input type="text" id="diagnosis-name" class="searchBox"
					placeholder="질병명" onchange="searchDiagnosis()">
				<div id="diagnosis-results" style="max-height: 350px;"></div>
			</div>
			<div class="section prescriptions diagnosis"
				style="grid-column: span 2;">
				<h2>상병</h2>
				<table class="table" id="diagnosis">
					<thead>
						<tr>
							<th>질병 코드</th>
							<th>질병 명칭</th>
							<th class="delete-column">삭제</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>

			<div class="section search medicine">
				<h2>약품 검색</h2>
				<input type="text" class="searchBox" id="medicine-name"
					placeholder="약품명" onchange="searchMedicine()">
				<div id="medicine-results" style="max-height: 350px;"></div>
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
							<th class="delete-column">삭제</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>

			<div class="section search drug">
				<h2>약물 검색</h2>
				<input type="text" class="searchBox" id="drug-name"
					placeholder="약물명" onchange="searchDrug()">
				<div id="drug-results" style="max-height: 350px;"></div>
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
							<th class="delete-column">삭제</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</section>
	</main>
	<script>
	  let diagnosisMode = false;
	  let previousHighlightChartNum = null; // 이전 하이라이트 기록 번호 저장
	  let selectedPatientNo = null; // 선택된 환자 번호 저장
	  let selectedRecordDate = null; // 선택된 진료 기록 날짜 저장
	  
	  let currentPage = 0;
	  let records = []; 
	  const pageSize = 10;

	  $(document).ready(function () {
            initializeCalendar(); 
            initializePatientList(); 
            initializeTabs(); 
            initializeProfileDropdown(); 
            initializeChatModal(); 
            bindEventHandlers();
      });

		// 이벤트 핸들러 바인딩
      function bindEventHandlers() {
    	  $('#createDiagnosisBtn').off('click').on('click', toggleDiagnosisMode);
            $('#saveDataBtn').on('click', saveData);
      }

  		// 진료 작성 모드 전환 함수
      function toggleDiagnosisMode() {
    	  // 환자가 선택되지 않은 경우 경고 메시지 출력
    	  if (!selectedPatientNo) {
    	    alert('환자를 먼저 선택해주세요.');
    	    return;
    	  }
    	  
    	  diagnosisMode = !diagnosisMode; // 진료 작성 모드 전환 여부 토글

            if (diagnosisMode) {
            	// 진료 작성 모드: 증상 입력 가능 및 삭제 칼럼 표시
                $('.patient-symptoms').hide();
                $('.symptoms textarea').show().val(''); // textarea 비우기
                $('#saveDataBtn').show();
                $('#createDiagnosisBtn').text('작성 취소'); // 버튼 텍스트 변경
                
                
                // 삭제 칼럼 보이게 하기
                $('.section.prescriptions table').addClass('show-delete'); // 처방 섹션
                $('.section.diagnosis table').addClass('show-delete');     // 진단 섹션
                $('.section.drug table').addClass('show-delete');          // 약물 섹션

                // 진료 작성 모드에서 필요한 데이터들 비우기
                $('#diagnosis tbody').empty();
                $('#prescriptions tbody').empty();
                $('#drugPrescriptions tbody').empty();
                
                // 과거 진료 이력 하이라이트 제거
                $('.section.history tbody tr').removeClass('selected-record');
            } else {
            	// 진료 작성 모드 취소: 원래 상태로 복귀
				closeDiagnosisMode(); // 진료 작성 모드 닫기
				
				 // 이전 진료 데이터 복원
		        if (previousHighlightChartNum) {
		            const recordToRestore = getRecordByChartNum(previousHighlightChartNum); // 해당 기록 가져오기
		            if (recordToRestore) {
		                updateRecordSections(recordToRestore); // 데이터 복원
		            }
		            highlightRecord(previousHighlightChartNum); // 이전 하이라이트 복원
		        }
            }
      }
  		
   // 기록 번호로 해당 기록을 찾는 함수
      function getRecordByChartNum(chartNum) {
          // 과거 기록을 찾아서 반환 (예: `records` 변수로 전체 기록을 저장하고 있다고 가정)
          return records.find(record => record.chartNum === chartNum);
   }

   	// 진료 작성 모드 종료 및 초기화 함수
      function closeDiagnosisMode() {
            diagnosisMode = false;
            
            $('.symptoms textarea').hide(); // 텍스트 영역 숨기기 및 기존 데이터 복원
            $('.section.prescriptions table').removeClass('show-delete'); // 삭제 칼럼 숨기기
            $('.section.diagnosis table').removeClass('show-delete');     // 삭제 칼럼 숨기기
            $('.section.drug table').removeClass('show-delete');          // 삭제 칼럼 숨기기
            
            $('.patient-symptoms').show(); // 원래 증상 텍스트 보이기
            $('#saveDataBtn').hide(); // 저장 버튼 숨기기
            $('#createDiagnosisBtn').text('진료 작성'); // 버튼 텍스트 복귀
            
            // 진료 작성 중에 추가된 데이터를 초기화
           $('#diagnosis tbody').empty();
            $('#prescriptions tbody').empty();
            $('#drugPrescriptions tbody').empty(); 

            // 진료 작성 모드에서 추가된 데이터를 복원하는 로직
            const currentRecord = getRecordByChartNum(previousHighlightChartNum);
            if (currentRecord) {
                updateRecordSections(currentRecord);
            }
      }

   	// 데이터 저장 함수 (증상 저장 및 모드 종료)
      function saveData() {
    	// 과거 진료 내역 수정 불가
    	  if (selectedRecordDate && !isToday(selectedRecordDate)) {
    	    alert('과거 진료 내역은 수정할 수 없습니다.');
    	    return;
    	  }
    	
            const symptoms = $('.symptoms textarea').val();// textarea 내용 가져오기
            $('.patient-symptoms').html('<p>' + symptoms + '</p>');// p 태그로 교체
            alert('진료 정보가 저장되었습니다.');
            closeDiagnosisMode(); // 진료 작성 모드 종료 > 진료 본거 바로 다 가져올 수 있도록 하기 재호출?
      }
   	
   //진료 기록을 로드하고 최신 기록을 회색으로 표시
		async function loadPatientMedicalRecords(patientNo) {
			try {
				const response = await fetch('/api/patients/recordsPatientNo/' + patientNo, {
					method: 'GET',
					headers: { 'Content-Type': 'application/json' }
				});

				if (!response.ok) throw new Error('진료 기록 불러오기 실패');

				records = await response.json();
				updateRecordHistory(records);

				if (records.length > 0) {
					updateRecordSections(records[0]);
					highlightRecord(records[0].chartNum); // 첫 번째 기록을 회색으로 표시
				}
			} catch (error) {
				console.error(error);
			}
		}
		
		// 기록의 히스토리 업데이트 함수
		function updateRecordHistory(records) {
			const historySection = document.querySelector('.section.history tbody');
			historySection.innerHTML = '';

			records.forEach(function(record) {
				const row = document.createElement('tr');
				row.setAttribute('data-chart-num', record.chartNum); // chartNum 속성 추가
				row.innerHTML = '<td>' + record.visitDate + '</td><td>' + record.doctorName + '</td>';
				row.addEventListener('click', function() {
					updateRecordSections(record);
					highlightRecord(record.chartNum); // 선택한 기록을 회색으로 표시
				});
				historySection.appendChild(row);
			});
		}
		
		
		// 환자의 기록 섹션 업데이트 함수
		function updateRecordSections(record) {
			closeDiagnosisMode(); // 진료 작성 모드 종료

			const symptomsSection = $('.patient-symptoms');
			const symptomsTextarea = $('.symptoms textarea');
			
			//마지막으로 봤던 차트 증상 데이터 복원
			symptomsSection.html(record.symptoms ? '<p>' + record.symptoms + '</p>' : '<p>작성된 증상이 없습니다.</p>');
			symptomsTextarea.hide();

			 // 진단, 처방, 약물 목록 복원
		    updateDiagnosisTable(record.diagnoses);
		    updatePrescriptionsTable(record.prescriptions);
		    updateDrugsTable(record.drugs);
		}
		
		// 테이블 갱신 함수들 (진단, 처방, 약물)
		function updateDiagnosisTable(diagnoses) {
		    const diagnosisTable = document.querySelector('#diagnosis tbody');
		    diagnosisTable.innerHTML = '';

		    diagnoses.forEach(function (diagnosis) {
		        const row = document.createElement('tr');
		        row.innerHTML = '<td>' + diagnosis.diseaseCode + '</td><td>' + diagnosis.diseaseName + '</td>';
		        diagnosisTable.appendChild(row);
		    });
		}
		
		function updatePrescriptionsTable(prescriptions) {
		    const prescriptionsTable = document.querySelector('#prescriptions tbody');
		    prescriptionsTable.innerHTML = '';

		    prescriptions.forEach(function (prescription) {
		        const row = document.createElement('tr');
		        row.innerHTML = '<td>' + prescription.itemSeq + '</td><td>' + prescription.entpName + '</td><td>' + prescription.itemName + '</td><td>' + prescription.useMethodQesitm + '</td>';
		        prescriptionsTable.appendChild(row);
		    });
		}

		// 약물 테이블 업데이트 함수 (과거 진료 이력 로드 시)
			function updateDrugsTable(drugs) {
		    const drugsTable = document.querySelector('#drugPrescriptions tbody');
		    drugsTable.innerHTML = '';
		
		    drugs.forEach(function (drug) {
		        const row = document.createElement('tr');
		        row.innerHTML = '<td>' + drug.cpntCd + '</td><td>' + drug.ingdNameKor + '</td><td>' + drug.fomlNm + '</td><td>' + drug.dosageRouteCode + '</td><td>' + drug.dayMaxDosgQyUnit + '</td><td>' + drug.dayMaxDosgQy + '</td>';
		        drugsTable.appendChild(row);
		    });
		}
		
		// 기록을 하이라이트하여 표시하는 함수 (회색으로 변경)
		function highlightRecord(chartNum) {
		    $('.section.history tbody tr').removeClass('selected-record'); // 기존 하이라이트 제거
		    const targetRow = $('.section.history tbody tr[data-chart-num="' + chartNum + '"]');
		    if (targetRow.length) {
		        targetRow.addClass('selected-record'); // 하이라이트 추가
		        previousHighlightChartNum = chartNum; // 이전 하이라이트 기록 번호 저장
		    }
		}

		// 각 삭제 버튼의 항목 제거 함수
		function removeDiagnosis(button) {
			const row = button.parentNode.parentNode;
			row.parentNode.removeChild(row);
		}

		function removePrescription(button) {
			const row = button.parentNode.parentNode;
			row.parentNode.removeChild(row);
		}

		function removeDrug(button) {
			const row = button.parentNode.parentNode;
			row.parentNode.removeChild(row);
		}

		// 상태 설정 함수 (별도로 분리)
		function setStatus(status, color) {
			$('.status-indicator').css('background-color', color); // 상태 색 변경
		}

      function initializePatientList() {
            loadPatients();

            let isFetching = false;
            window.addEventListener('scroll', function() {
                if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 100 && !isFetching) {
                    isFetching = true;
                    loadPatients().finally(function() {
                        isFetching = false;
                    });
                }
            });
      }

      async function loadPatients() {
            try {
                const response = await fetch('/api/patients/patientList?offset=' + currentPage + '&limit=' + pageSize, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' }
                });

                if (!response.ok) throw new Error('네트워크 응답이 올바르지 않습니다.');

                const patients = await response.json();
                if (!patients || patients.length === 0) return;

                const patientList = document.getElementById('patientList');
                patients.forEach(function(patient) {
                    const patientDiv = document.createElement('div');
                    patientDiv.classList.add('patient-item');
                    patientDiv.textContent = patient.name + ' (' + patient.birthDate + ')';
                    patientDiv.addEventListener('click', function() {
                        loadPatientDetails(patient.no);
                    });
                    patientList.appendChild(patientDiv);
                });

                currentPage += pageSize;
            } catch (error) {
                console.error('환자 목록 로드 중 오류:', error);
            }
      }
      
   // 환자 클릭 시 진료 기록을 불러오는 함수
      async function loadPatientDetails(patientNo) {
            try {
                const response = await fetch('/api/patients/info/' + patientNo, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' }
                });

                if (!response.ok) throw new Error('네트워크 응답이 올바르지 않습니다.');

                const data = await response.json();
                
                // 환자 정보 및 상태 업데이트
                updatePatientInfo(data);
                
                // 선택된 환자 번호 저장
                selectedPatientNo = patientNo;
                
                // 최신 진료 기록 불러오기 및 첫 번째 기록 하이라이트
                await loadPatientMedicalRecords(patientNo);
                
            } catch (error) {
                console.error('환자 정보 로드 중 오류:', error);
            }
      }
   
      function updatePatientInfo(data) {
    	    const patientInfoSection = document.querySelector('.section.patient-info');
    	    let patientDetails = patientInfoSection.querySelector('.patient-details');
    	    if (!patientDetails) {
    	        patientDetails = document.createElement('div');
    	        patientDetails.classList.add('patient-details');
    	        patientInfoSection.appendChild(patientDetails);
    	    }

    	    patientDetails.innerHTML =
    	        '<p>이름: ' + data.name + '</p>' +
    	        '<p>주민번호: ' + data.securityNum + '</p>' +
    	        '<p>성별: ' + (data.gender === 'M' ? '남성' : '여성') + '</p>' +
    	        '<p>주소: ' + data.address + '</p>' +
    	        '<p>전화번호: ' + data.phone + '</p>' +
    	        '<p>이메일: ' + data.email + '</p>' +
    	        '<p>혈액형: ' + data.bloodType + '</p>' +
    	        '<p>키: ' + data.height + ' cm</p>' +
    	        '<p>몸무게: ' + data.weight + ' kg</p>' +
    	        '<p>알레르기: ' + data.allergies + '</p>' +
    	        '<p>흡연 여부: ' + (data.smokingStatus === 'Y' ? '흡연' : '비흡연') + '</p>';

    	    const statusTbody = document.querySelector('.section.status tbody');
    	    statusTbody.innerHTML =
    	        '<tr><td>혈압</td><td>' + (data.bloodPressure || '정보 없음') + '</td></tr>' +
    	        '<tr><td>체온</td><td>' + (data.temperature ? data.temperature + ' ℃' : '정보 없음') + '</td></tr>';
    	}

   		// 환자의 진료 기록 불러오기
      async function loadPatientMedicalRecords(patientNo) {
            try {
                const response = await fetch('/api/patients/recordsPatientNo/' + patientNo, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' }
                });

                if (!response.ok) throw new Error('진료 기록 불러오기 실패');

                const records = await response.json();
                updateRecordHistory(records);

                // 최신 기록을 첫 번째로 불러와서 하이라이트 처리
                if (records.length > 0) {
                    updateRecordSections(records[0]);
                    highlightRecord(records[0].chartNum); // 첫 번째 기록 하이라이트
                }

            } catch (error) {
                console.error(error);
            }
      }

   // 진료 기록 리스트 갱신 및 하이라이트 적용
      function updateRecordHistory(records) {
            const historySection = document.querySelector('.section.history tbody');
            historySection.innerHTML = '';

            records.forEach(function (record) {
                const row = document.createElement('tr');
                row.setAttribute('data-chart-num', record.chartNum); // chartNum 속성 추가
                row.innerHTML = '<td>' + record.visitDate + '</td><td>' + record.doctorName + '</td>';
                row.addEventListener('click', function () {
                    updateRecordSections(record); // 기록 클릭 시 해당 기록 업데이트
                    highlightRecord(record.chartNum); // 클릭한 기록 하이라이트
                });
                historySection.appendChild(row);
            });
        }

   // 기록의 섹션 업데이트 함수
     function updateRecordSections(record) {
    	 // 선택한 진료 기록의 날짜를 저장 (이 날짜가 오늘과 다른지 확인)
    	  selectedRecordDate = new Date(record.visitDate);
    	 
   		 closeDiagnosisMode(); // 진료 작성 모드 종료

          const symptomsSection = $('.patient-symptoms');
          const symptomsTextarea = $('.symptoms textarea');
          symptomsSection.html(record.symptoms ? '<p>' + record.symptoms + '</p>' : '<p>작성된 증상이 없습니다.</p>');
          symptomsTextarea.hide();

          updateDiagnosisTable(record.diagnoses);
          updatePrescriptionsTable(record.prescriptions);
          updateDrugsTable(record.drugs);
      }

   // 처방 테이블 업데이트 함수
      function updatePrescriptionsTable(prescriptions, addDeleteColumn = false) {
          const prescriptionsTable = document.querySelector('#prescriptions tbody');
          prescriptionsTable.innerHTML = '';

          prescriptions.forEach(function (prescription) {
              const row = document.createElement('tr');
              row.innerHTML =
                  '<td>' + prescription.itemSeq + '</td>' +
                  '<td>' + prescription.entpName + '</td>' +
                  '<td>' + prescription.itemName + '</td>' +
                  '<td>' + prescription.useMethodQesitm + '</td>' +
                  (addDeleteColumn ? '<td class="delete-column"><button class="searchList" onclick="removePrescription(this)">X</button></td>' : '');
              prescriptionsTable.appendChild(row);
          });
      }


   // 약물 테이블 업데이트 함수
      function updateDrugsTable(drugs, addDeleteColumn = false) {
          const drugsTable = document.querySelector('#drugPrescriptions tbody');
          drugsTable.innerHTML = '';

          drugs.forEach(function (drug) {
              const row = document.createElement('tr');
              row.innerHTML =
                  '<td>' + drug.cpntCd + '</td>' +
                  '<td>' + drug.ingdNameKor + '</td>' +
                  '<td>' + drug.fomlNm + '</td>' +
                  '<td>' + drug.dosageRouteCode + '</td>' +
                  '<td>' + drug.dayMaxDosgQyUnit + '</td>' +
                  '<td>' + drug.dayMaxDosgQy + '</td>' +
                  (addDeleteColumn ? '<td class="delete-column"><button class="searchList" onclick="removeDrug(this)">X</button></td>' : '');
              drugsTable.appendChild(row);
          });
      }

   // 각 삭제 버튼의 항목 제거 함수
      function removeDiagnosis(button) {
          const row = button.parentNode.parentNode;
          row.parentNode.removeChild(row);
      }

      function removePrescription(button) {
          const row = button.parentNode.parentNode;
          row.parentNode.removeChild(row);
      }

      function removeDrug(button) {
          const row = button.parentNode.parentNode;
          row.parentNode.removeChild(row);
      }


      function initializeCalendar() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                dayCellContent: function (e) {
                    e.dayNumberText = e.dayNumberText.replace('일', '');
                },
                events: [{
                    title: 'All Day Event',
                    start: '2023-08-01'
                }, {
                    title: 'Long Event',
                    start: '2023-08-07',
                    end: '2023-08-10'
                }]
            });
            calendar.render();
      }

      function initializeTabs() {
            $('#tab-all-patients').on('click', showAllPatients);
            $('#tab-waiting-patients').on('click', showWaitingPatients);
      }

      function showAllPatients() {
            $('#tab-all-patients').addClass('active');
            $('#tab-waiting-patients').removeClass('active');
            $('#all-patients').show();
            $('#waiting-patients').hide();
      }

      function showWaitingPatients() {
            $('#tab-waiting-patients').addClass('active');
            $('#tab-all-patients').removeClass('active');
            $('#waiting-patients').show();
            $('#all-patients').hide();
      }

      function initializeProfileDropdown() {
            document.getElementById('profile-image').addEventListener('click', function (event) {
                var dropdown = document.querySelector('.dropdown-menu');
                dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
                event.stopPropagation();
            });

            document.addEventListener('click', function (event) {
                var dropdown = document.querySelector('.dropdown-menu');
                if (!event.target.matches('#profile-image') && !dropdown.contains(event.target)) {
                    dropdown.style.display = 'none';
                }
            });
      }
   // 오늘 날짜인지 확인하는 함수
      function isToday(date) {
        const today = new Date();
        return date.getDate() === today.getDate() &&
               date.getMonth() === today.getMonth() &&
               date.getFullYear() === today.getFullYear();
      }

      function initializeChatModal() {
            const modal = document.getElementById('chatModal');
            const btn = document.getElementById('chat-ai-btn');
            const span = document.getElementsByClassName('close')[0];

            // 모달 열기
            btn.onclick = function () {
                modal.style.display = 'block';
            }

            //모달 닫기
            span.onclick = function () {
                modal.style.display = 'none';
            }

         	// 모달 외부 클릭 시 모달 닫기
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }

            $('#sendChatBtn').click(function () {
                sendMessageToAI();
            });

            $('#userInput').keypress(function (e) {
                if (e.which == 13) {
                    sendMessageToAI();
                }
            });
            // API 검색 결과 클릭 외 영역 클릭 시 닫힘 처리
            $(document).click(function (e) {
                const target = $(e.target);

                // 클릭한 영역이 모달이나 Chat AI 버튼이 아닌 경우 모달 닫기
                if (!target.closest('#chatModal').length && !target.closest('#chat-ai-btn').length) {
                    modal.style.display = 'none';
                }

                // 클릭한 영역이 질병 검색결과와 관련 없으면 닫기
                if (!target.closest('#diagnosis-name').length && !target.closest('#diagnosis-results').length) {
                    $('#diagnosis-results').hide();
                }

                // 클릭한 영역이 약품 검색결과와 관련 없으면 닫기
                if (!target.closest('#medicine-name').length && !target.closest('#medicine-results').length) {
                    $('#medicine-results').hide();
                }

                // 클릭한 영역이 약물 검색결과와 관련 없으면 닫기
                if (!target.closest('#drug-name').length && !target.closest('#drug-results').length) {
                    $('#drug-results').hide();
                }
            });
      }

      function sendMessageToAI() {
            const userMessage = $('#userInput').val().trim();
            if (userMessage) {
                $('#chatContent').append('<p><strong>You:</strong> ' + userMessage + '</p>');
                $('#userInput').val('');

                $.ajax({
                    url: '/api/doctor/chatgpt',
                    method: 'GET',
                    data: { prompt: userMessage },
                    success: function (response) {
                        $('#chatContent').append('<p><strong>AI:</strong> ' + response + '</p>');
                        $('#chatContent').scrollTop($('#chatContent')[0].scrollHeight);
                    },
                    error: function (error) {
                        $('#chatContent').append('<p><strong>AI:</strong> Error occurred while communicating with AI.</p>');
                    }
                });
            }
      }
      
        // 질병 검색 api
        // 검색 함수 (진료 작성 모드가 아니면 경고 메시지 출력)
       function searchDiagnosis() {
    	   if (!diagnosisMode) {
    	        alert('진료 작성시에만 검색 기능을 이용할 수 있습니다.');
    	        $('#diagnosis-name').val(''); // 검색 칸을 비우기
					return;
    	   }
    	   
           const diagnosisName = $('#diagnosis-name').val().trim();
           
	           if (!diagnosisName) {
	               $('#diagnosis-results').hide(); // 검색어가 없으면 결과 숨김
	               return;
	           }
	           
	        // 검색어가 입력될 때만 검색 결과 갱신
           $.ajax({
               url: '/api/doctor/diagnosisSearch',
               method: 'GET',
               data: {
                   query: diagnosisName
               },
               dataType: 'xml', // XML 데이터 타입으로 설정
               success: function (xml) {
            	   $('#diagnosis-results').empty(); // 기존 결과 비움
                   const items = $(xml).find('item'); // XML에서 item 태그를 찾아 반복 처리

                   if (items.length == 0) {
                       $('#diagnosis-results').append('<p>검색 결과가 없습니다.</p>').show();
                       return;
                   }

                   // 검색된 각 item에 대한 처리
                   items.each(function () {
                       const diseaseCode = $(this).find('diseaseCode').text();
                       const diseaseName = $(this).find('diseaseName').text();

                       // 검색 결과를 화면에 표시 (클릭 이벤트 추가)
                       const resultDiv = $('<div class="diagnosis-results">' + diseaseName + '</div>');
                       resultDiv.on('click', function () {
                           addDiagnosisToTable(diseaseCode, diseaseName);
                       });
                       $('#diagnosis-results').append(resultDiv).show(); //결과를 화면에 표시
                   });
               },
               error: function (error) {
                   $('#diagnosis-results').html('<p>오류가 발생했습니다.</p>');
               }
           });
       }

    // 검색된 질병, 약품, 약물 항목 추가 함수
       function addDiagnosisToTable(diseaseCode, diseaseName) {
           const newRowHtml =
               '<tr>' +
               '<td>' + diseaseCode + '</td>' +
               '<td>' + diseaseName + '</td>' +
               '<td><button class="searchList" onclick="$(this).closest(\'tr\').remove()">X</button></td>' +
               '</tr>';
           $('#diagnosis tbody').append(newRowHtml);
           $('#diagnosis-name').val('');  // 검색어 삭제
       }
    
   

    // - 약품 검색
       function searchMedicine() {
    	
    	   if (!diagnosisMode) {
    	        alert('진료 작성시에만 검색 기능을 이용할 수 있습니다.');
    	        $('#medicine-name').val(''); // 검색 칸을 비우기
    	        return;
    	    }

    	   
           const medicineName = $('#medicine-name').val().trim();
           
           if (!medicineName) {
               $('#medicine-results').hide(); // 검색어가 없으면 결과 숨김
               return;
           }

           $.ajax({
               url: '/api/doctor/prescriptionsSearch',
               method: 'GET',
               data: {
                   query: medicineName
               },
               dataType: 'xml',
               success: function (xml) {

                   const items = $(xml).find('item');

                   if (items.length === 0) {
                       $('#medicine-results').append('<p>검색 결과가 없습니다.</p>');
                       return;
                   }

                   items.each(function () {
                       const itemSeq = $(this).find('itemSeq').text();
                       const entpName = $(this).find('entpName').text();
                       const itemName = $(this).find('itemName').text();
                       const useMethod = $(this).find('useMethodQesitm').text();

                       const resultDiv = $('<div class="medicine-results">' + itemName + '</div>');
                       resultDiv.on('click', function () {
                           addMedicineToTable(itemSeq, itemName, entpName, useMethod);
                       });
                       $('#medicine-results').append(resultDiv).show();
                   });
               },
               error: function () {
                   $('#medicine-results').html('<p>오류가 발생했습니다.</p>');
               }
           });
       }
    
       function addMedicineToTable(itemSeq, itemName, entpName, useMethod) {
   	    const newRowHtml =
   	        '<tr>' +
   	        '<td>' + itemSeq + '</td>' +
   	        '<td>' + entpName + '</td>' +
   	        '<td>' + itemName + '</td>' +
   	        '<td>' + useMethod + '</td>' +
   	        '<td><button class="searchList" onclick="$(this).closest(\'tr\').remove()">X</button></td>' +
   	        '</tr>';
   	     $('#prescriptions tbody').append(newRowHtml);
   	    $('#medicine-name').val('');  // 검색어 삭제
   	}
      
       // 약물 검색 API
       function searchDrug() {
    	   
    	   if (!diagnosisMode) {
    	        alert('진료 작성시에만 검색 기능을 이용할 수 있습니다.');
    	        $('#drug-name').val(''); // 검색 칸을 비우기
    	        return;
    	    }
    	   
           const drugName = $('#drug-name').val().trim();
           if (!drugName) {
               $('#drug-results').hide(); // 검색어가 없으면 결과 숨김
               return;
           }

           $.ajax({
               url: '/api/doctor/drugSearch',
               method: 'GET',
               data: {
                   query: drugName
               },
               dataType: 'xml',
               success: function (xml) {
                   const items = $(xml).find('item');

                   if (items.length === 0) {
                	   $('#drug-results').append('<p>검색 결과가 없습니다.</p>').show();
                       return;
                   }

                   items.each(function () {
                       const cpntCd = $(this).find('cpntCd').text();
                       const ingdNameKor = $(this).find('ingdNameKor').text();
                       const fomlNm = $(this).find('fomlNm').text();
                       const dosageRouteCode = $(this).find('dosageRouteCode').text();
                       const dayMaxDosgQyUnit = $(this).find('dayMaxDosgQyUnit').text();
                       const dayMaxDosgQy = $(this).find('dayMaxDosgQy').text();

                       const resultDiv = $('<div class="drug-results">' + ingdNameKor + '</div>');
                       resultDiv.on('click', function () {
                           addDrugToTable(cpntCd, ingdNameKor, fomlNm, dosageRouteCode, dayMaxDosgQyUnit, dayMaxDosgQy);
                       });
                       $('#drug-results').append(resultDiv).show();
                   });
               },
               error: function () {
                   $('#drug-results').html('<p>오류가 발생했습니다.</p>');
               }
           });
       }
      
      function addDrugToTable(cpntCd, ingdNameKor, fomlNm, dosageRouteCode, dayMaxDosgQyUnit, dayMaxDosgQy) {
   	    const newRowHtml =
   	        '<tr>' +
   	        '<td>' + cpntCd + '</td>' +
   	        '<td>' + ingdNameKor + '</td>' +
   	        '<td>' + fomlNm + '</td>' +
   	        '<td>' + dosageRouteCode + '</td>' +
   	        '<td>' + dayMaxDosgQyUnit + '</td>' +
   	        '<td>' + dayMaxDosgQy + '</td>' +
   	        '<td><button class="searchList" onclick="$(this).closest(\'tr\').remove()">X</button></td>' +
   	        '</tr>';
   	     $('#drugPrescriptions tbody').append(newRowHtml);
   	    $('#drug-name').val('');  // 검색어 삭제
   	}
      
   // 검색 결과를 관리하는 함수
      function setupSearchFocusAndClick(searchInputId, searchResultsId) {
          // 검색창 클릭 시 기존 검색 결과 유지
          $('#' + searchInputId).on('focus', function () {
              $('#' + searchResultsId).show(); // 검색창 클릭 시 검색 결과 보이기
          });

          // 다른 곳을 클릭해도 검색 결과가 사라지지 않음
          $(document).on('click', function (event) {
              // 검색창이나 검색 결과를 클릭하지 않으면 결과를 숨기지 않음
              if (!$(event.target).closest('#' + searchInputId).length && !$(event.target).closest('#' + searchResultsId).length) {
                  // 검색창 외부를 클릭해도 결과를 숨기지 않도록 비움 (이벤트 비움)
              }
          });
      }

      // 진단(상병), 처방, 약물 검색창에 대해 설정 적용
      setupSearchFocusAndClick('diagnosis-name', 'diagnosis-results');
      setupSearchFocusAndClick('medicine-name', 'medicine-results');
      setupSearchFocusAndClick('drug-name', 'drug-results');


    </script>
</body>
</html>