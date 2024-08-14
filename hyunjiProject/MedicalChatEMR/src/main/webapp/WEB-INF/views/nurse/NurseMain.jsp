<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>전자 의료 기록 시스템</title>
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

.patient-search {
	margin: 10px 0;
	width: 90%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
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
	transition: all 0.4s ease;
}

.leftSidebar, .rightSidebar {
	background-color: #e9e9e9;
	width: 230px;
	padding: 10px;
	box-sizing: border-box;
	overflow-y: auto;
}

.rightSidebar {
	transition: all 0.4s ease;
}

.main {
	flex: 2;
	padding: 20px;
	margin: 0 10px;
	background-color: #f4f4f4;
	overflow-y: auto;
	box-sizing: border-box;
	transition: all 0.4s ease;
}

.card {
	background-color: #ffffff;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	padding: 10px;
	border-radius: 8px;
	height: 100%;
}

table {
	width: 100%;
	border-collapse: collapse;
}

.table-cell {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

th {
	background-color: #f4f4f4;
}

.header h1 {
	margin: 0;
	font-size: 24px;
}

.section {
	margin-bottom: 20px;
}

.section h2 {
	margin-bottom: 10px;
	font-size: 18px;
}

.tabs {
	display: flex;
}

.tab {
	flex: 1;
	text-align: center;
	padding: 10px;
	cursor: pointer;
	background-color: #f0f0f0;
	border-bottom: 2px solid transparent;
	transition: background-color 0.4s, border-bottom 0.3s;
}

.tab.active {
	background-color: #ffffff;
	border-bottom: 2px solid #38a169;
}

.info {
	display: none;
}

.info.active {
	display: block;
}

.editable {
	padding: 4px;
	margin-top: 5px;
}

.editable input {
	border: none;
	outline: none;
	/* Remove default focus outline */
	width: 100%;
	background: transparent;
	font-size: 14px;
	pointer-events: none;
	/* Disable interaction */
	cursor: default;
}

td.editing {
	background-color: #fbf6c390;
}

td.editing input {
	background-color: transparent;
	/* Keep input background transparent */
	pointer-events: auto;
	/* Enable interaction */
	cursor: text;
	transition: all 0.4s ease;
}

.record:hover {
	cursor: pointer;
}

.hidden {
	width: 0;
	padding: 0;
	overflow: hidden;
	display: none;
}
</style>
</head>

<body>
	<header>
		<div class="logo">
			<img src="Img/Logo.png">
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

	<div class="container">
		<div class="leftSidebar">
			<div class="card">
				<div class="tabs">
					<div id="tab-all-patients" class="tab active">전체 환자</div>
					<div id="tab-managed-patients" class="tab">관리 환자</div>
				</div>
				<input class="patient-search" type="text" placeholder="환자 검색"
					id="patientSearch">
				<button id="refresh-list"
					style="width: 100%; padding: 10px; background-color: #38a169; color: white; border: none; border-radius: 4px;">새로고침</button>
				<div id="all-patients-info" class="info active">
					<h2>전체 환자 목록</h2>
					<ul id="patientList"></ul>
				</div>
				<div id="managed-patients-info" class="info">
					<h2>관리 환자 목록</h2>
					<!-- 관리 환자 정보 -->
				</div>
			</div>
		</div>

		<main class="main">
			<section class="patient-details card">
				<div class="header">
					<h1>환자 EHR</h1>
					<button id="edit-btn" class="nav-btn" style="margin-top: 10px;">수정</button>
					<button id="save-btn" class="nav-btn"
						style="margin-top: 10px; display: none;">저장</button>
				</div>
				<div class="section">
					<h2>기본 정보</h2>
					<table id="basic-info-table">
						<tr>
							<th class="table-cell">환자 ID</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.id" readonly></td>
							<th class="table-cell">이름</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.name" readonly></td>
							<th class="table-cell">주민번호</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.securityNum" readonly></td>
						</tr>
						<tr>
							<th class="table-cell">성별</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.gender" readonly></td>
							<th class="table-cell">키</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.height" readonly></td>
							<th class="table-cell">체중</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.weight" readonly></td>
						</tr>
						<tr>
							<th class="table-cell">혈액형</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.bloodType" readonly></td>
							<th class="table-cell">알레르기</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.allergies" readonly></td>
							<th class="table-cell">흡연 여부</th>
							<td class="editable table-cell"><input type="text" value=""
								name="patient.smokingStatus" readonly></td>
						</tr>
						<tr>
							<th class="table-cell">주소</th>
							<td class="editable table-cell" colspan="5"><input
								type="text" value="" name="patient.address" readonly></td>
						</tr>
					</table>
				</div>

				<div class="section">
					<h2>진료 기록</h2>
					<table id="recordTable">
						<tr>
							<th class="table-cell">날짜</th>
							<th class="table-cell">진단</th>
							<th class="table-cell">처방</th>
							<th class="table-cell">담당의</th>
						</tr>
						<!-- 진료 기록 데이터가 여기에 추가됩니다 -->
					</table>
					<div id="record-details" class="section" style="display: none;">
						<h3>진료 정보</h3>
						<table id="details-table">
							<tr>
								<th class="table-cell">항목</th>
								<th class="table-cell">내용</th>
							</tr>
							<tr>
								<td class="table-cell">진료 내용</td>
								<td id="details-content" class="table-cell"></td>
							</tr>
						</table>
					</div>
				</div>
			</section>
		</main>

		<div class="rightSidebar hidden">
			<div class="card">
				<p>메신저 기능</p>
			</div>
		</div>
	</div>

	<script>
        // 프로필 이미지 클릭 시 드롭다운 토글
        document.getElementById('profile-image').addEventListener('click', function (event) {
            const dropdown = document.querySelector('.dropdown-menu');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            event.stopPropagation(); // 이벤트 버블링 방지
        });

        // 클릭 이외의 부분을 클릭했을 때 메뉴가 사라지도록 처리
        document.addEventListener('click', function (event) {
            const dropdown = document.querySelector('.dropdown-menu');
            if (!event.target.matches('#profile-image') && !dropdown.contains(event.target)) {
                dropdown.style.display = 'none';
            }
        });

        // 상태 설정
        function setStatus(status, color) {
            document.querySelector('.status-indicator').style.backgroundColor = color;
        }

        // 탭 전환
        document.getElementById('tab-all-patients').addEventListener('click', function () {
            setActiveTab('all-patients-info', 'tab-all-patients');
        });

        document.getElementById('tab-managed-patients').addEventListener('click', function () {
            setActiveTab('managed-patients-info', 'tab-managed-patients');
        });

        function setActiveTab(infoId, tabId) {
            document.querySelectorAll('.info').forEach(function (info) {
                info.classList.remove('active');
            });
            document.getElementById(infoId).classList.add('active');

            document.querySelectorAll('.tab').forEach(function (tab) {
                tab.classList.remove('active');
            });
            document.getElementById(tabId).classList.add('active');
        }

        // 환자 검색 및 목록 업데이트
        document.addEventListener('DOMContentLoaded', function () {
            document.getElementById('patientSearch').addEventListener('input', function () {
                const searchTerm = document.getElementById('patientSearch').value.toLowerCase();
                if (searchTerm) {
                    fetchPatients(searchTerm);
                } else {
                    // 입력이 없으면 목록을 비우거나 초기 상태로 유지
                    displayPatients([]);
                }
            });
        });

     // 환자 데이터를 가져오는 함수
        function fetchPatients(searchTerm) {
            // JavaScript의 encodeURIComponent 함수를 사용하여 직접 검색어를 인코딩
            const encodedSearchTerm = encodeURIComponent(searchTerm);

            fetch(`/api/patients?name=${encodedSearchTerm}`)
                .then(response => response.json())
                .then(data => {
                    displayPatients(data);
                });
        }


        // 환자를 목록에 표시
        function displayPatients(patients) {
            const patientList = document.getElementById('patientList');
            patientList.innerHTML = '';

            patients.forEach(patient => {
                const li = document.createElement('li');
                li.textContent = patient.name;
                li.setAttribute('data-id', patient.id);
                li.addEventListener('click', () => fetchPatientDetails(patient.id));
                patientList.appendChild(li);
            });
        }

        // 상세 환자 정보를 가져오는 함수
        function fetchPatientDetails(patientId) {
            fetch(`/api/patients/${patientId}`)
                .then(response => response.json())
                .then(data => {
                    showPatientDetails(data.patient, data.medicalRecords);
                });
        }

        // 환자 및 진료 기록 상세 정보를 표시
        function showPatientDetails(patient, records) {
            const basicInfoHtml = `
                <tr>
                    <th class="table-cell">환자 ID</th>
                    <td class="editable table-cell"><input type="text" value="${patient.id}" name="patient.id" readonly></td>
                    <th class="table-cell">이름</th>
                    <td class="editable table-cell"><input type="text" value="${patient.name}" name="patient.name" readonly></td>
                    <th class="table-cell">주민번호</th>
                    <td class="editable table-cell"><input type="text" value="${patient.securityNum}" name="patient.securityNum" readonly></td>
                </tr>
                <tr>
                    <th class="table-cell">성별</th>
                    <td class="editable table-cell"><input type="text" value="${patient.gender}" name="patient.gender" readonly></td>
                    <th class="table-cell">키</th>
                    <td class="editable table-cell"><input type="text" value="${patient.height}" name="patient.height" readonly></td>
                    <th class="table-cell">체중</th>
                    <td class="editable table-cell"><input type="text" value="${patient.weight}" name="patient.weight" readonly></td>
                </tr>
                <tr>
                    <th class="table-cell">혈액형</th>
                    <td class="editable table-cell"><input type="text" value="${patient.bloodType}" name="patient.bloodType" readonly></td>
                    <th class="table-cell">알레르기</th>
                    <td class="editable table-cell"><input type="text" value="${patient.allergies}" name="patient.allergies" readonly></td>
                    <th class="table-cell">흡연 여부</th>
                    <td class="editable table-cell"><input type="text" value="${patient.smokingStatus}" name="patient.smokingStatus" readonly></td>
                </tr>
                <tr>
                	<th class="table-cell">주소</th>
                	<td class="editable table-cell" colspan="5"><input type="text" value="${patient.address}" name="patient.address" readonly></td>
           		 </tr>`;

            document.getElementById('basic-info-table').innerHTML = basicInfoHtml;

            // 진료 기록 업데이트
            const recordTable = document.getElementById('recordTable');
            recordTable.querySelectorAll('.record').forEach(row => row.remove());

            records.forEach(record => {
                const tr = document.createElement('tr');
                tr.className = 'record';
                tr.dataset.details = `
                    증상: ${record.symptoms} | 
                    혈압: ${record.bloodPressure} | 
                    체온: ${record.temperature} | 
                    질병명: ${record.diseaseName} | 
                    처방: ${record.prescriptionName}, ${record.dosagePerTime}mg x ${record.timesPerDay}회 x ${record.totalDays}일 (${record.usageInstructions})
                `;
                tr.innerHTML = `
                    <td class="table-cell">${record.visitDate}</td>
                    <td class="table-cell">${record.diseaseName}</td>
                    <td class="table-cell">${record.prescriptionName}</td>
                    <td class="table-cell">${record.doctorName}</td>
                `;
                tr.addEventListener('click', function () {
                    const detailsContent = tr.dataset.details;
                    const detailsSection = document.getElementById('record-details');
                    const detailsText = document.getElementById('details-content');

                    if (detailsSection.style.display === 'block' && detailsText.innerText === detailsContent) {
                        detailsSection.style.display = 'none';
                        detailsText.innerText = '';
                    } else {
                        detailsText.innerText = detailsContent;
                        detailsSection.style.display = 'block';
                    }
                });

                recordTable.appendChild(tr);
            });
        }

        // 편집 모드 활성화
        document.getElementById('edit-btn').addEventListener('click', function () {
            document.querySelectorAll('.editable').forEach(function (cell) {
                if (cell.querySelector('input').name !== 'patient.id' && cell.querySelector('input').name !== 'patient.securityNum'  && cell.querySelector('input').name !== 'patient.address') {
                    cell.classList.add('editing');
                    cell.querySelector('input').removeAttribute('readonly');
                }
            });

            document.getElementById('edit-btn').style.display = 'none';
            document.getElementById('save-btn').style.display = 'inline-block';
        });

        // 편집 모드 비활성화 및 변경사항 저장
        document.getElementById('save-btn').addEventListener('click', function () {
            document.querySelectorAll('.editable').forEach(function (cell) {
                cell.classList.remove('editing');
                cell.querySelector('input').setAttribute('readonly', true);
            });

            document.getElementById('edit-btn').style.display = 'inline-block';
            document.getElementById('save-btn').style.display = 'none';

            // 필요한 경우 업데이트된 데이터를 서버로 전송
        });

        // 메세지 (오른쪽 사이드바) 부분 버튼
        document.getElementById('messages-btn').addEventListener('click', function () {
            const rightSidebar = document.querySelector('.rightSidebar');
            const mainContent = document.querySelector('.main');
            if (rightSidebar.classList.contains('hidden')) {
                rightSidebar.classList.remove('hidden');
                mainContent.style.flex = '1';
            } else {
                rightSidebar.classList.add('hidden');
                mainContent.style.flex = '2';
            }
        });
    </script>
</body>
</html>
