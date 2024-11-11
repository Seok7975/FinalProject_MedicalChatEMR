<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Medical Chat EMR</title>
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
	padding: 20px;
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	display: grid;
	grid-template-areas: "patient-info symptoms status"
		"history diagnosis diagnosis"
		"prescriptions prescriptions prescriptions" "drugs drugs drugs";
	grid-gap: 20px;
	grid-template-columns: 2fr 1.5fr 1fr;
	grid-template-rows: auto auto auto auto;
}

.section {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background-color: #fafafa;
	max-height: 300px;
}

.section h2 {
	margin-top: 0;
}

.patient-info {
	grid-area: patient-info;
}

.symptoms {
	grid-area: symptoms;
}

.status {
	grid-area: status;
}

.history {
	grid-area: history;
}

.diagnosis {
	grid-area: diagnosis;
}

.prescriptions {
	grid-area: prescriptions;
}

.drugs {
	grid-area: drugs;
}
/* 내부 컨텐츠의 스크롤 설정 */
.patient-details, .patient-symptoms, .status .table tbody, .history .table tbody,
	.diagnosis .table tbody, .prescriptions .table tbody, .drugs .table tbody
	{
	max-height: 200px;
	overflow-y: scroll;
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

.section.history tbody tr.selected {
	color: gray;
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
				<img id="profile-image" src="/images/ProfileImage/doctorProfile.jpg" alt="Profile Image">
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

	<main class="container">
		<section class="sidebar">
			<div class="tab-buttons">
				<div class="tab active" id="tab-all-patients"
					onclick="showAllPatients()">대기 환자</div>
				<div class="tab" id="tab-managed-patients"
					onclick="showManagedPatients()">환자 목록</div>
			</div>
			<div class="search-section">
				<input type="text" placeholder="환자검색">
				<button>검색</button>
				<button id="refreshPatientsBtn">새로고침</button>
			</div>
			<div class="scrollable-patient-list" id="all-patients">
				<h2>진료 대기 목록</h2>
				<ul id="waitingList">
					<li>환자1</li>
					<li>환자2</li>
					<!-- 여기에 실제 대기 환자 목록 데이터를 추가할 수 있습니다. -->
				</ul>
			</div>
			<div class="scrollable-patient-list" id="managed-patients">
				<h2>전체 환자 목록</h2>
				<ul id="patientList"></ul>
				<!-- 전체 환자 목록 -->
			</div>

			<div id='calendar'></div>
		</section>

		<section class="content">
			<!-- 첫 번째 줄: 환자 정보, 증상, 상태 -->
			<div class="section patient-info">
				<h2>환자 정보</h2>
				<div class="patient-details">
					<p>환자를 선택하세요</p>
				</div>
			</div>

			<div class="section symptoms">
				<h2>증상</h2>
				<div class="patient-symptoms">
					<!-- 이곳에 증상 내용 삽입 -->
				</div>
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

			<!-- 두 번째 줄: 과거 진료 이력, 상병 -->
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
						<!-- 이곳에 과거 진료 이력 삽입-->
					</tbody>
				</table>
			</div>

			<div class="section diagnosis">
				<h2>상병</h2>
				<table class="table">
					<thead>
						<tr>
							<th>질병 코드</th>
							<th>질병명</th>
						</tr>
					</thead>
					<tbody>
						<!-- 이곳에 상병 삽입-->
					</tbody>
				</table>
			</div>

			<!-- 세 번째 줄: 처방 목록 -->
			<div class="section prescriptions">
				<h2>처방 목록</h2>
				<table class="table">
					<thead>
						<tr>
							<th>약품 회사</th>
							<th>약품 코드</th>
							<th>약품명</th>
							<th>사용법</th>
						</tr>
					</thead>
					<tbody>
						<!-- 이곳에 처방 목록 삽입-->
					</tbody>
				</table>
			</div>

			<!-- 네 번째 줄: 약물 목록 -->
			<div class="section drugs">
				<h2>약물 목록</h2>
				<table class="table">
					<thead>
						<tr>
							<th>성분 코드</th>
							<th>성분명(한글)</th>
							<th>제형명</th>
							<th>투여 경로</th>
							<th>투여 단위</th>
							<th>1일 최대 투여량</th>
						</tr>
					</thead>
					<tbody>
						<!-- 이곳에 처방 목록 삽입-->
					</tbody>
				</table>
			</div>
		</section>
	</main>
	<script>
	
	 $(document).ready(function () {
         $('#refreshPatientsBtn').on('click', refreshPatientList); // 새로고침 버튼 클릭 시 환자 목록 업데이트
   });
	 
	// 상태 설정 함수 (별도로 분리)
		function setStatus(status, color) {
			$('.status-indicator').css('background-color', color); // 상태 색 변경
			 // 상태를 변경한 후 드롭다운 메뉴 닫기
		    var dropdown = document.querySelector('.dropdown-menu');
		    dropdown.style.display = 'none';
		}

// 새로고침 버튼을 클릭하면 환자 목록만 새로 로드하는 함수
   function refreshPatientList() {
       // 현재 페이지를 0으로 초기화하여 처음부터 새로 불러옴
       currentPage = 0;
       $('#patientList').empty(); // 기존 목록을 비웁니다.
       loadPatients(); // 새로운 환자 목록을 불러옵니다.
   }
	
	 let currentPatientRecords = []; // 전역 변수를 통해 환자의 모든 진료 기록을 저장
	 let currentHighlightedRecord = null; // 현재 강조된 진료 기록을 저장
	 
	// 페이지 로드 시 첫 환자 목록 로드
    document.addEventListener('DOMContentLoaded', loadPatients);
	
	
	
	 // 진료 대기 목록을 보이고, 전체 환자 목록을 숨기는 함수
    function showAllPatients() {
      document.getElementById('tab-all-patients').classList.add('active');
      document.getElementById('tab-managed-patients').classList.remove('active');
      document.getElementById('all-patients').style.display = 'block'; // 진료 대기 목록 보이기
      document.getElementById('managed-patients').style.display = 'none'; // 전체 환자 목록 숨기기
    }

    // 전체 환자 목록을 보이고, 진료 대기 목록을 숨기는 함수
    function showManagedPatients() {
      document.getElementById('tab-all-patients').classList.remove('active');
      document.getElementById('tab-managed-patients').classList.add('active');
      document.getElementById('all-patients').style.display = 'none'; // 진료 대기 목록 숨기기
      document.getElementById('managed-patients').style.display = 'block'; // 전체 환자 목록 보이기
    }

    document.addEventListener('DOMContentLoaded', function () {
      // 처음 로드 시 진료 대기 목록만 보이도록 설정
      document.getElementById('all-patients').style.display = 'block'; // 진료 대기 목록 보이기
      document.getElementById('managed-patients').style.display = 'none'; // 전체 환자 목록 숨기기
    });
		
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
		
		  	let currentPage = 0;
	        const pageSize = 10;

	        // 환자 목록 로드
			async function loadPatients() {
			    try {
			    	
			    	const response = await fetch('/api/patients/patientList?offset=' + currentPage + '&limit=' + pageSize, {
			    	     method: 'GET', 
			    	    headers: {
			    	        'Content-Type': 'application/json'
			    	    }
			    	});
			
			        
			        // 응답이 제대로 들어왔는지 확인
			        if (!response.ok) {
			            throw new Error('네트워크 응답이 올바르지 않습니다.');
			        }
			        
			     // JSON 응답을 파싱하여 patients 변수에 할당
			        const patients = await response.json();
			
			        // 데이터가 존재하는지 확인
			        if (!patients || patients.length == 0) {
			            console.log("환자 데이터가 없습니다.");
			            return;
			        }
			        
			      //스크롤
			    	window.addEventListener('scroll', () => {
			    	    console.log('스크롤 이벤트 발생'); // 스크롤 이벤트가 발생할 때마다 로그 출력
			    	    if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 100) {
			    	        console.log('추가 환자 목록 로드 중...');
			    	        loadPatients();
			    	    }
			    	});
			      
			        
			        const patientList = document.getElementById('patientList');
			        patients.forEach(patient => {
			            const patientDiv = document.createElement('div');
			            patientDiv.classList.add('patient-item');
			
			            // 텍스트 추가 (이름과 생년월일 표시)
			            patientDiv.textContent = patient.name + ' (' + patient.birthDate + ')';
			
			            // 클릭 이벤트 추가
			            patientDiv.addEventListener('click', () => {
			                loadPatientDetails(patient.no);
			            });
			
			            patientList.appendChild(patientDiv);
			            console.log('환자 목록에 추가:', patient.name); // 각 환자가 추가될 때마다 로그 출력
			        });
			
			        currentPage += pageSize;
			    } catch (error) {
			        console.error("환자 목록 로드 중 오류:", error);
			    }
			}
	        
	        // 특정 환자의 기본 정보 로드
	        async function loadPatientDetails(patientNo) {
	            try {
	                const response = await fetch('/api/patients/info/' + patientNo, {
	                    method: 'GET',
	                    headers: {
	                        'Content-Type': 'application/json',
	                    }
	                });
	            	
	            	// 응답 상태 확인
	                if (!response.ok) {
	                    throw new Error('네트워크 응답이 올바르지 않습니다.');
	                }
	            	
	                const data = await response.json();
	                
	                const patientInfoSection = document.querySelector('.section.patient-info');
	                // 환자 정보를 삽입할 요소가 있는지 확인
	                let patientDetails = patientInfoSection.querySelector('.patient-details');
	                if (!patientDetails) {
	                    // 기존 정보가 없다면 새로 생성
	                    patientDetails = document.createElement('div');
	                    patientDetails.classList.add('patient-details');
	                    patientInfoSection.appendChild(patientDetails);
	                }
	                
	                patientDetails.innerHTML = 
	                    '<p>이름: ' + data.name + '</p>' +
	                    '<p>주민번호: ' + data.securityNum + '</p>' +
	                    '<p>성별: ' + (data.gender == 'M' ? '남성' : '여성') + '</p>' +
	                    '<p>주소: ' + data.address + '</p>' +
	                    '<p>전화번호: ' + data.phone + '</p>' +
	                    '<p>이메일: ' + data.email + '</p>' +
	                    '<p>혈액형: ' + data.bloodType + '</p>' +
	                    '<p>키: ' + data.height + ' cm</p>' +
	                    '<p>몸무게: ' + data.weight + ' kg</p>' +
	                    '<p>알레르기: ' + data.allergies + '</p>' +
	                    '<p>흡연 여부: ' + (data.smokingStatus == 'Y' ? '흡연' : '비흡연') + '</p>';

	             // 상태 정보 업데이트
	                const statusTbody = document.querySelector('.section.status tbody');
	                statusTbody.innerHTML = 
	                    '<tr><td>혈압</td><td>' + (data.bloodPressure || '정보 없음') + '</td></tr>' +
	                    '<tr><td>체온</td><td>' + (data.temperature ? data.temperature + ' ℃' : '정보 없음') + '</td></tr>';
	    	        
	                // 진료 기록도 함께 로드
	                await loadPatientMedicalRecords(patientNo);

	            } catch (error) {
	                console.error("환자 정보 로드 중 오류:", error);
	            }
	        }

	     // 환자의 진료 기록 및 관련 데이터 불러오기
	        async function loadPatientMedicalRecords(patientNo) {
	            try {
	                const response = await fetch('/api/patients/recordsPatientNo/' + patientNo, {
	                    method: 'GET',
	                    headers: {
	                        'Content-Type': 'application/json',
	                    }
	                });

	                if (!response.ok) {
	                    throw new Error('네트워크 응답이 올바르지 않습니다.');
	                }

	                const data = await response.json(); // JSON 응답을 파싱

	                // 최신 진료 기록 표시
	                if (data.length > 0) {
	                    const latestRecord = data[0]; // 최신 기록이 첫 번째에 있다고 가정
	                    updateRecordSections(latestRecord);
	                    updateRecordHistory(data); // 진료 기록 섹션 업데이트
	                    
	                    // 최신 기록 강조
	                    highlightRecord(latestRecord.chartNum);
	                } else {
	                    console.log('진료 기록이 없습니다.');
	                }

	            } catch (error) {
	                console.error("진료 기록 로드 중 오류:", error);
	            }
	        }
	     
	     // 기록을 강조하고 클릭 이벤트를 추가하는 함수
	        function updateRecordHistory(records) {
	            const historySection = document.querySelector('.section.history tbody');
	            historySection.innerHTML = '';

	            records.forEach(record => {
	                const row = document.createElement('tr');
	                row.dataset.chartnum = record.chartNum; //클릭한 부분 색 변한
	                row.innerHTML = '<td>' + record.visitDate + '</td><td>' + record.doctorName + '</td>';
	                row.addEventListener('click', () => {
	                    updateRecordSections(record);
	                    highlightRecord(record.chartNum); // 클릭 시 강조
	                });
	                historySection.appendChild(row);
	            });
	        }
	     
	     // 진료 기록 데이터를 받아서 각 섹션을 업데이트하는 함수
	        function updateRecordSections(record) {
	            // 증상 섹션 업데이트
	            const symptomsSection = document.querySelector('.patient-symptoms');
	            if (!record.symptoms || record.symptoms.trim().length === 0) {
	                symptomsSection.innerHTML = '<p>' + "작성된 증상이 없습니다." + '</p>';
	            } else {
	                symptomsSection.innerHTML = '<p>' + record.symptoms + '</p>';
	            }
	            // 과거 진료 이력 섹션 업데이트
	            //const historySection = document.querySelector('.section.history tbody');
	            //historySection.innerHTML = ''; // 기존 데이터를 지우고 최신 데이터를 추가
	            //historySection.innerHTML += '<tr><td>' + record.visitDate + '</td><td>' + record.doctorName + '</td></tr>';

	            // 진단 섹션 업데이트
	            const diagnosisSection = document.querySelector('.section.diagnosis tbody');
	            diagnosisSection.innerHTML = '';
	            record.diagnoses.forEach(function(diagnosis) {
	                diagnosisSection.innerHTML += '<tr><td>' + diagnosis.diseaseCode + '</td><td>' + diagnosis.diseaseName + '</td></tr>';
	            });

	            // 처방 목록 섹션 업데이트
	            const prescriptionsSection = document.querySelector('.section.prescriptions tbody');
	            prescriptionsSection.innerHTML = '';
	            record.prescriptions.forEach(function(prescription) {
	                prescriptionsSection.innerHTML += '<tr><td>' + prescription.entpName + '</td><td>' + prescription.itemSeq + '</td><td>' + prescription.itemName + '</td><td>' + prescription.useMethodQesitm + '</td></tr>';
	            });

	            // 약물 목록 섹션 업데이트
	            const drugsSection = document.querySelector('.section.drugs tbody');
	            drugsSection.innerHTML = '';
	            record.drugs.forEach(function(drug) {
	                drugsSection.innerHTML += '<tr><td>' + drug.cpntCd + '</td><td>' + drug.ingdNameKor + '</td><td>' + drug.fomlNm + '</td><td>' + drug.dosageRouteCode + '</td><td>' + drug.dayMaxDosgQyUnit + '</td><td>' + drug.dayMaxDosgQy + '</td></tr>';
	            });
	        }
	     
	     // 진료 기록을 강조하는 함수
		function highlightRecord(chartNum) {
		    if (currentHighlightedRecord) {
		        currentHighlightedRecord.classList.remove('selected');
		    }
		    const rows = document.querySelectorAll('.section.history tbody tr');
		    rows.forEach(row => {
		        if (row.dataset.chartnum == chartNum) {
		            row.classList.add('selected');
		            currentHighlightedRecord = row;
		        }
		    });
	     }
	</script>
</body>

</html>
