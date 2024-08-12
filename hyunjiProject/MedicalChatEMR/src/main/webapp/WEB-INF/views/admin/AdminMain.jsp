<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>병원장 페이지</title>
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.css' rel='stylesheet' />
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.0/main.min.js'></script>
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

        .adminhd {
            background-color: #b8edb5;
            color: black;
            padding: 10px 0;
            position: relative;
            z-index: 1000;
        }

        .adminhd .settingnavbar {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }

        .adminhd .settingnavbar li {
            display: inline-block;
            list-style: none;
            margin: 0 15px;
            padding: 0;
            position: relative;
        }

        .adminhd .settingnavbar a {
            display: block;
            color: black;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
        }

        .adminhd .settingnavbar li:hover {
            background-color: #a3d9a5;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #fff;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1000;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
        }

        .dropdown-content a:hover {
            background-color: #ddd;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .adminhd li a, .dropbtn {
            display: inline-block;
            color: black;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }

        .container {
            display: flex;
            flex: 1;
        }

        aside {
            width: 250px;
            background-color: #f0f0f0;
            padding: 20px;
            box-sizing: border-box;
            border-right: 1px solid black;
        }

        aside div {
            margin-bottom: 20px;
        }

        main {
            display: flex;
            flex: 1;
            padding: 20px;
            justify-content: center;
            position: relative;
            z-index: 1;
        }

        .sidebarL {
            width: 250px;
            background-color: #f0f0f0;
            padding: 10px;
            padding-top: 20px;
            border-right: 1px solid #ddd;
            box-sizing: border-box;
        }

        .sidebarR {
            width: 250px;
            background-color: #f0f0f0;
            padding: 10px;
            padding-top: 20px;
            border-left: 1px solid #ddd;
            box-sizing: border-box;
        }

        .content {
            flex-grow: 1;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        header {
            width: 100%;
            background-color: #b8edb5;
            padding: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

        .dropdown-menu {
            display: none;
            width: 130px;
            position: absolute;
            background-color: white;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1000;
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

        .section {
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fafafa;
            overflow-y: auto;
            max-height: 430px;
        }

        .section h2 {
            margin-top: 0;
        }

        #calendar {
            max-width: 220px;
            height: 362px;
            font-size: 0.6em;
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
    <header class="adminhd">
        <div class="logo">
            <img src="Img/Logo.png" alt="Logo">
        </div>
        <nav>
            <ul class="settingnavbar">
                <li class="dropdown"><a href="javascript:void(0)" class="dropbtn">인적관리</a>
                    <div class="dropdown-content">
                        <a href="javascript:void(0)" onclick="loadContent('/admin/employee-create')">직원 생성</a>
                        <a href="javascript:void(0)" onclick="loadContent('/admin/employee-view')">직원 조회/수정/퇴사</a>
                    </div>
                </li>
                <li class="dropdown"><a href="javascript:void(0)" class="dropbtn" onclick="loadContent('/medicalView.jsp')">진료조회</a></li>
            </ul>
            <div class="profile-info">
                <img id="profile-image" src="doctorProfile.png" alt="Profile Image">
                <div class="status-indicator"></div>
                <button id="logout-btn" class="logout-btn">Log Out</button>
                <div class="dropdown-menu">
                    <a href="#" class="status-link" onclick="setStatus('away', '#808080')"> 
                        <span class="color-indicator" style="background-color: #808080;"></span>자리 비움
                    </a>
                    <a href="#" class="status-link" onclick="setStatus('available', '#008000')"> 
                        <span class="color-indicator" style="background-color: #008000;"></span>진료중
                    </a>
                    <a href="#" class="status-link" onclick="setStatus('lunch', '#FFA500')"> 
                        <span class="color-indicator" style="background-color: #FFA500;"></span>점심시간
                    </a>
                </div>
            </div>
        </nav>
    </header>
    <main class="container">
        <section class="sidebarL">
            <div class="search-section">
                <input type="text" placeholder="환자검색">
                <button>검색</button>
                <button>새로고침</button>
            </div>
            <div id='calendar'></div>
        </section>
        <section class="content" id="content">
            <div class="board">
                <p>메인 보드 입니다.</p>
            </div>
        </section>
        <section class="sidebarR">
            <div class="Message">
                <p>이곳에 메시지를 추가하세요.</p>
            </div>
        </section>
    </main>
    <footer></footer>
    <script>
    //달력 api함수
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            if (calendarEl) {
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    locale: 'ko',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    },
                    dateClick: function(info) {
                        alert('Date: ' + info.dateStr);
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
            } else {
                console.error('Calendar element not found');
            }
        });

        //활동 상태 표시 함수
        function setStatus(status, color) {
            document.querySelector('.status-indicator').style.backgroundColor = color;
        }

        document.getElementById('profile-image').addEventListener('click', function(event) {
            var dropdown = document.querySelector('.dropdown-menu');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            event.stopPropagation();
        });

        document.addEventListener('click', function(event) {
            var dropdown = document.querySelector('.dropdown-menu');
            if (!event.target.matches('#profile-image') && !dropdown.contains(event.target)) {
                dropdown.style.display = 'none';
            }
        });

        //메인 보드에 원하는 기능 가진 페이지 동적으로 불러올 수 있는 함수
        function loadContent(url) {
            fetch(url)
                .then(response => response.text())
                .then(data => {
                    document.querySelector('.board').innerHTML = data;
                })
                .catch(error => console.error('Error fetching data:', error));
        }
    </script>
</body>
</html>