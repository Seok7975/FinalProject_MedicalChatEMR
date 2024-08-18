<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>직원 조회/수정/퇴사</title>
    <style>
        /* 검색 바 스타일 */
        .search-container {
            margin-bottom: 20px;
        }

        .search-container label {
            margin-right: 10px;
            font-weight: bold;
        }

        .search-container select, .search-container input[type="text"] {
            margin-right: 10px;
            padding: 5px;
            font-size: 14px;
        }

        .search-container button {
            padding: 6px 12px;
            font-size: 14px;
            cursor: pointer;
        }

        /* 모달 스타일 */
        .modal {
            display: none; /* 초기 상태에서 모달 숨기기 */
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0, 0, 0);
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
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
    <h2>직원 조회/수정/퇴사</h2>

    <!-- 검색 바 -->
    <div class="search-container">
        <label for="search-name">직원명:</label>
        <input type="text" id="search-name" placeholder="이름">
        <label for="search-job">직업군:</label>
        <select id="search-job">
            <option value="">전체</option>
            <option value="doctor">의사</option>
            <option value="nurse">간호사</option>
        </select>
        <label for="search-position">직급:</label>
        <select id="search-position">
            <option value="">전체</option>
            <option value="인턴">인턴</option>
            <option value="레지던트">레지던트</option>
            <option value="전문의">전문의</option>
            <option value="교수">교수</option>
            <option value="정규직">정규직</option>
            <option value="수간호사">수간호사</option>
            <option value="퇴직">퇴직</option>
        </select>
        <button onclick="searchEmployees()">조회</button>
    </div>

    <table>
        <thead>
            <tr>
                <th>NO</th>
                <th>이름</th>
                <th>직업군</th>
                <th>직급</th>
                <th>ID</th>
                <th>전화번호</th>
                <th>Email</th>
            </tr>
        </thead>
        <tbody id="employee-table-body">
            <!-- 검색 결과가 여기에 표시됩니다 -->
        </tbody>
    </table>

    <div id="employeeModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>직원 정보 수정</h2>
            <form id="employeeForm" method="post" enctype="multipart/form-data">
                <input type="hidden" id="employee-id" name="employeeId">
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" class="emplWrite" required><br><br>
                <label for="job-title">직급:</label>
                <select id="job-title" name="job-title" class="emplWrite"></select><br><br>
                <label for="phone">전화번호:</label>
                <input type="text" id="phone" name="phone" class="emplWrite" required><br><br>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" class="emplWrite" required><br><br>

                <div class="doctor-field">
                    <label for="department">부서:</label>
                    <input type="text" id="department" name="department" class="emplWrite"><br><br>
                </div>

                <div class="doctor-field">
                    <label for="specialty">전문분야:</label>
                    <input type="text" id="specialty" name="specialty" class="emplWrite"><br><br>
                </div>

                <div class="nurse-field" style="display: none;">
                    <label for="role">역할:</label>
                    <input type="text" id="role" name="role" class="emplWrite"><br><br>
                </div>

                <button type="submit" class="emplAdd">수정 완료</button>
            </form>
        </div>
    </div>

    <script>
        function searchEmployees() {
            const name = document.getElementById('search-name').value;
            const job = document.getElementById('search-job').value;
            const position = document.getElementById('search-position').value;

            const params = new URLSearchParams();
            if (name) params.append('name', name);
            if (job) params.append('job', job);
            if (position) params.append('position', position);

            fetch('/searchEmployees?' + params.toString())
                .then(response => response.json())
                .then(data => {
                    const tableBody = document.getElementById('employee-table-body');
                    tableBody.innerHTML = '';  // 기존 결과 지우기

                    data.forEach((employee, index) => {
                        const row = document.createElement('tr');
                        row.innerHTML = `
                            <td>${index + 1}</td>
                            <td><a href="javascript:void(0);" onclick='openModal(${JSON.stringify(employee)})'>${employee.name}</a></td>
                            <td>${employee.job == 'doctor' ? '의사' : '간호사'}</td>
                            <td>${employee.jobTitle}</td>
                            <td>${employee.id}</td>
                            <td>${employee.phone}</td>
                            <td>${employee.email}</td>
                        `;
                        tableBody.appendChild(row);
                    });
                })
                .catch(error => console.error('Error fetching employee data:', error));
        }

        // 모달 창 열기
        function openModal(employee) {
            const modal = document.getElementById('employeeModal');
            modal.style.display = "block";

            document.getElementById('employee-id').value = employee.id;
            document.getElementById('name').value = employee.name;
            document.getElementById('job-title').value = employee.jobTitle;
            document.getElementById('phone').value = employee.phone;
            document.getElementById('email').value = employee.email;

            if (employee.job === 'doctor') {
                document.querySelectorAll('.doctor-field').forEach(el => el.style.display = 'block');
                document.querySelectorAll('.nurse-field').forEach(el => el.style.display = 'none');
            } else {
                document.querySelectorAll('.doctor-field').forEach(el => el.style.display = 'none');
                document.querySelectorAll('.nurse-field').forEach(el => el.style.display = 'block');
            }
        }

        document.querySelector('.close').addEventListener('click', function() {
            document.getElementById('employeeModal').style.display = "none";
        });

        window.onclick = function(event) {
            const modal = document.getElementById('employeeModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }

        document.getElementById('employeeForm').addEventListener('submit', function(event) {
            event.preventDefault();
            const formData = new FormData(this);

            fetch('/updateEmployee', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                alert('수정이 완료되었습니다.');
                document.getElementById('employeeModal').style.display = "none";
                location.reload();
            })
            .catch(error => {
                console.error('Error updating employee data:', error);
                alert('수정 중 오류가 발생했습니다.');
            });
        });
    </script>
</body>
</html>
