// 비활동 시간 설정: 30초 (테스트 용도)
//let inactivityTime = 30 * 1000;

let inactivityTime = 30 * 60 * 1000; // 30분
let logoutTimer;

function resetLogoutTimer() {
    clearTimeout(logoutTimer); // 기존 타이머 초기화
    logoutTimer = setTimeout(logUserOut, inactivityTime); // 새 타이머 시작
}

function logUserOut() {
    // 비활동 로그아웃 처리
    $.post("/inactivity-logout", function() {
        // 비활동 로그아웃 후 로그인 페이지로 리디렉트하고, 파라미터 추가
        window.location.href = "/loginMain?logoutSuccess=true&reason=inactivity"; 
    });
}

$(document).ready(function() {
    // 사용자 활동 감지 이벤트 등록
    $(document).on('mousemove keydown click scroll', resetLogoutTimer);
    resetLogoutTimer(); // 페이지 로드 시 타이머 시작
});


// 로그아웃 버튼 클릭 시 자의적 로그아웃 처리
$(document).on('click', '#logout-btn', function() {
    // 확인 창 띄우기
    var confirmLogout = confirm("로그아웃 하시겠습니까?");
    
    // 사용자가 확인을 눌렀을 때만 로그아웃 진행
    if (confirmLogout) {
        $.post("/logout", function() {
            window.location.href = "/loginMain"; // 자의적 로그아웃 후 로그인 페이지로 리디렉트
        });
    }
});



//<script src="/js/common/activity-tracker.js"></script> //이렇게 jsp에서 불러오기