<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OHIF-XNAT Viewer</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="icon" href="${contextPath}/img/medical.ico" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<link rel="stylesheet" href="${contextPath}/css/viewer.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.7.1/jszip.min.js"></script>
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

</head>

<body>
	<span id="contextPath" hidden>${contextPath}</span>
	<div class="container">
		<header class="header">
			<nav>
				<div class="logo">
					<img src="/Img/Logo.png" alt="Logo">
				</div>
			</nav>
		</header>
		<nav class="toolbar">
			<div class="interface-toolbar">
				<button class="interface-button tool-button" data-tool="defaultTool">
					<i class="fas fa-hand-pointer"></i> Default Tool
				</button>
				<button class="interface-button tool-button" data-tool="windowLevel">
					<i class="fas fa-adjust"></i> 윈도우 레벨
				</button>
				<button class="interface-button tool-button" data-tool="invert">
					<i class="fas fa-adjust"></i> 흑백 반전
				</button>
				<button class="interface-button tool-button" data-tool="imageMove">
					<i class="fas fa-arrows-alt"></i> 이동
				</button>
				<button class="interface-button tool-button" data-tool="scrollLoop">
					<i class="fas fa-sync-alt"></i> 스크롤 루프
				</button>
				<button class="interface-button tool-button" data-tool="playClip">
					<i class="fas fa-play"></i> 플레이클립
				</button>
				<button class="interface-button" data-tool="tools">
					<i class="fa-solid fa-toolbox"></i> <span class="tools_naming">도구</span>
					<i class="fa-solid fa-caret-down"></i>
				</button>
				<!-- 도구 드롭 다운 메뉴 -->
				<div class="toolModalChildren">
					<button class="interface-button tool-button" data-tool="magnify">
						<i class="fa-solid fa-magnifying-glass"></i>돋보기
					</button>
					<button class="interface-button tool-button" data-tool="zoom">
						<i class="fa-solid fa-search-plus"></i>확대
					</button>
					<button class="interface-button tool-button" data-tool="rotate">
						<i class="fa-solid fa-rotate"></i>회전
					</button>
					<button class="interface-button tool-button"
						data-tool="right_rotate">
						<i class="fa-solid fa-rotate-right"></i>오른쪽 회전
					</button>
					<button class="interface-button tool-button"
						data-tool="left_rotate">
						<i class="fa-solid fa-rotate-left"></i>왼쪽 회전
					</button>
					<button class="interface-button tool-button" data-tool="h_flip">
						<i class="fa-solid fa-arrows-alt-h"></i>수평뒤집기
					</button>
					<button class="interface-button tool-button" data-tool="v_flip">
						<i class="fa-solid fa-arrows-alt-v"></i>수직대칭이동
					</button>
					<button class="interface-button tool-button"
						data-tool="interpolation">
						<i class="fa-solid fa-border-all"></i>보간법
					</button>
				</div>


				<button class="interface-button" data-tool="annotation">
					<i class="fa-solid fa-tag"></i> <span class="tools_naming">주석</span>
					<i class="fa-solid fa-caret-down"></i>
				</button>

				<!-- 주석 드롭 다운 메뉴 -->
				<div class="toolModalChildren annotationModal">
					<button class="interface-button tool-button" data-tool="angle">
						<i class="fa-solid fa-angle-left"></i> 각도
					</button>
					<button class="interface-button tool-button"
						data-tool="arrowAnnotate">
						<i class="fa-solid fa-arrow-right-long"></i>화살표
					</button>
					<button class="interface-button tool-button" data-tool="probe">
						<i class="fa-solid fa-location-dot"></i>Probe
					</button>
					<button class="interface-button tool-button" data-tool="length">
						<i class="fa-solid fa-ruler"></i>길이
					</button>
					<button class="interface-button tool-button"
						data-tool="rectangleRoi">
						<i class="fa-regular fa-square"></i>사각형 그리기
					</button>
					<button class="interface-button tool-button"
						data-tool="ellipticalRoi">
						<i class="fa-regular fa-circle"></i>원 그리기
					</button>
					<button class="interface-button tool-button" data-tool="freeHand">
						<i class="fa-solid fa-pencil"></i>자율그리기
					</button>
					<button class="interface-button tool-button"
						data-tool="bidirectional">
						<i class="fa-solid fa-border-all"></i>bidirectional
					</button>
					<button class="interface-button tool-button" data-tool="cobbAngle">
						<i class="fa-solid fa-ruler-combined"></i>콥 각도
					</button>
					<button class="interface-button tool-button" data-tool="TextMarker">
						<i class="fa-regular fa-comment"></i>텍스트 마커
					</button>
					<button class="interface-button tool-button" data-tool="eraser">
						<i class="fa-solid fa-eraser"></i>선택 삭제
					</button>
				</div>

				<button class="interface-button" data-tool="refresh">
					<i class="fas fa-undo"></i> <span class="tools_naming">재설정</span> <i
						class="fa-solid fa-caret-down"></i>
				</button>
				<!-- 재설정 도구 -->
				<div class="toolModalChildren refreshModal">
					<button class="interface-button tool-button"
						data-tool="canvasReset">
						<i class="fa-solid fa-toolbox"></i>캔버스 재설정
					</button>
					<button class="interface-button tool-button" data-tool="toolClear">
						<i class="fa-solid fa-tag"></i>툴 재설정
					</button>
					<button class="interface-button tool-button" data-tool="allClear">
						<i class="fa-solid fa-trash"></i>전부 삭제
					</button>
				</div>

				<button class="interface-button" data-tool="img_layout">
					<i class="fas fa-th"></i> <span class="tools_naming">이미지
						레이아웃</span> <i class="fa-solid fa-caret-down"></i>
				</button>
				<button class="interface-button tool-button"
					data-tool="saveAnnotation">
					<i class="fas fa-save"></i> 주석저장 DICOM
				</button>
			</div>
		</nav>

		<main class="main-content">
			<aside class="left-panel">
				<div class="dashboard">
					<button class="action-button tool-button dashboard-Button">
						<i class="fa-solid fa-list"></i><span>진료대기 목록</span>
					</button>
				</div>
				<div class="separator"></div>
				<div class="action-buttons">
					<button class="action-button tool-button dcmDownLoad">
						<i class="fas fa-download"></i> <span>DICOM 다운로드</span>
					</button>
					<button class="action-button tool-button imageDownLoad">
						<i class="fas fa-image"></i> <span>JPG 다운로드</span>
					</button>
					<button class="action-button tool-button dcmDelete">
						<i class="fas fa-trash"></i> <span>삭제하기</span>
					</button>
				</div>
			</aside>

			<div class="center-panel">
				<div class="wadoBox">
					<div class="parentDiv" data-value="0">
						<!-- playClipModal 추가 -->
						<div class="playClipModal custom-playClipModal">
							<div class="MuiBox-root">
								<button class="tool-button play-button" data-tool="start_button">
									<i class="fa-solid fa-play"></i>
								</button>
								<div class="fpsbutton">
									<button class="speedbutton">
										<i class="fa-solid fa-angle-left"></i>
									</button>
									<p class="fpswords"></p>
									<button class="speedbutton">
										<i class="fa-solid fa-angle-right"></i>
									</button>
								</div>
								<button class="tool-button play-button" data-tool="stop_button">
									<i class="fa-solid fa-stop"></i>
								</button>
							</div>
						</div>

						<div class="topLeft XLarge"></div>
						<div class="bottomLeft XLarge">
							<span class="block"></span>
						</div>
						<div class="bottomRight XLarge">
							<span class="block wwwc"></span>
						</div>
						<div id="dicomImage" class="image-placeholder"></div>
					</div>
				</div>
			</div>

			<aside class="right-panel" style="user-select:none;"></aside>
		</main>

		<footer class="footer">
			<!-- <p>Zoom: 172% | W: 360 L: 60 | Lossless / Uncompressed</p> -->
			<p class="copyright">Icons by fontawesome</p>
		</footer>
	</div>
	<input type="text" id="pid" value="${pid}" hidden />
	
<script>
//cornerstone 관련 설정
console.log("Setting external libraries");
cornerstoneWADOImageLoader.external.cornerstone = cornerstone;
cornerstoneWebImageLoader.external.cornerstone = cornerstone;
cornerstoneTools.external.cornerstone = cornerstone;
cornerstoneTools.external.Hammer = Hammer;
cornerstoneWADOImageLoader.external.dicomParser = dicomParser;

// 이미지 로더 등록
console.log("Configuring image loader");
cornerstoneWADOImageLoader.configure({});

let viewerPath = $('#contextPath').text();

const element = document.getElementById('dicomImage');
const playButton = document.querySelector('.playClipModal .fa-play').parentElement;
const stopButton = document.querySelector('.playClipModal .fa-stop').parentElement;
const pid = document.getElementById('pid').value; 
const fileUrl = viewerPath  + '/dicom?pid='+ pid;
const customCursor = 'url(/img/cross.cur) 8 8, auto'; // 전역 변수로 설정


console.log("pid: ", pid);  // 이 로그로 pid 값 확인


const toolButton = document.querySelector('.interface-button i.fa-toolbox').parentElement;
const toolModal = toolButton.nextElementSibling;

const imageScrollLoopButton = document.querySelector('[data-tool="scrollLoop"]');
const imageLayoutButton = document.querySelector('[data-tool="img_layout"]');

const toolsButton = document.querySelector('[data-tool="tools"]');

const playClipButton = document.querySelector('[data-tool="playClip"]');
const playClipModal = document.querySelector('.playClipModal');

const annotationButton = document.querySelector('[data-tool="annotation"]');
const annotationModal = document.querySelector('.annotationModal');

const refreshButton = document.querySelector('[data-tool="refresh"]');
const refreshModal = document.querySelector('.refreshModal');

let isPlayClipActive = false;
let isWindowLevelActive = false;
let isSingleLayout = true;
let currentImageIndex = 0;
let currentViewport = null; // 현재 뷰포트를 저장하기 위한 변수
let isScrollLoopActive = false; // 스크롤 루프 기능 활성화 상태 저장 변수
let stopClipPlaybackGlobal;  // 전역 변수로 함수 참조를 저장할 변수
let isZoomActive = false;
let originalImageSize = null;
let activeImageElement = null;
let isPlaying = false; // 클립 재생 상태
let isLayout = false;
let playInterval; // 클립 재생을 위한 인터벌
let fps = 20; // 초기 FPS 값

let imageIds = [];  // 전역 변수로 이동
let fileDataListGlobal = [];
let sopInstanceUIDs = [];
let currentFileNames  = []; // dcm 파일 이름
let currentImageName = ''; // 현재 표시 중인 이미지의 파일 이름
let currentPname = ''; // 환자 이름
let currentModality = ''; // 촬영 장비 이름

let initialWindowWidth = null;
let initialWindowCenter = null;


//Cornerstone 요소 활성화
console.log("Enabling cornerstone element");
// cornerstone 도구 초기화
cornerstoneTools.init();
cornerstone.enable(element); // 요소를 활성화합니다.

// 스크롤 설정 추가
let stackScrollOptions = {
        configuration: {
            invert: true, // 휠 스크롤 방향을 반대로 설정
            loop: isScrollLoopActive, // isScrollLoopActive 값을 반영
        }
    };
    
// 텍스트 주석 설정 추가
const configuration = {
		  markers: ['F5', 'F4', 'F3', 'F2', 'F1'],
		  current: 'F5',
		  color: '#FF0000',
		  ascending: true,
		  loop: true,
		};
// 선택 삭제 설정 추가
const eraserConfiguration = {
	    highlight: true,
	    cursor: 'pointer', // 'not-allowed' 대신 'pointer'로 설정할 수도 있음
	    renderDashed: true, // 하이라이트 시 점선 렌더링
};



// 도구 버튼 클릭시 드롭다운 표시 이벤트
toolButton.addEventListener('click', function (e) {
    e.stopPropagation(); // 이벤트 버블링 방지

    // toolModal 위치 조정 (버튼 클릭 시에만 위치 설정)
    const buttonRect = toolButton.getBoundingClientRect();
    toolModal.style.top = buttonRect.bottom+'px';
    toolModal.style.left = buttonRect.left+'px';

    // 메뉴 표시/숨김 토글
    if (toolModal.style.display === 'none' || !toolModal.style.display) {
        toolModal.classList.add('custom-width'); // 너비 조절을 위한 클래스 추가
        toolModal.style.display = 'grid';
        toolButton.classList.add('custom-active'); // 버튼 활성화 효과
    } else {
        hideToolMenu();
    }
});

// 진료대기 목록 버튼 이벤트
$('.dashboard-Button').click(function() {
    // 서버로 GET 요청 보내기
    window.location.href = '/doctorUI';
});

// 파일 다운로드 및 삭제 버튼 이벤트
$(".dcmDownLoad").click(function () {
	const titleMessage = currentFileNames.length > 1 
    ? '모든 DICOM 파일을 다운로드하시겠습니까?' 
    : 'DICOM 파일을 다운로드하시겠습니까?';
	
    Swal.fire({
        title: titleMessage,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            // 전역 변수를 직접 사용
            const xhr = new XMLHttpRequest();
            xhr.open('GET', '/downloadDICOM?fileNames=' + encodeURIComponent(currentFileNames.join(',')) + '&pname=' + encodeURIComponent(currentPname) 
            		+ '&modality=' + encodeURIComponent(currentModality), true);
            xhr.responseType = 'blob';  // Blob 타입의 응답을 받음
            xhr.onload = function () {
                if (xhr.status === 200) {
                    const blob = xhr.response;
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = currentFileNames.length > 1 ? currentPname + '_' + currentModality + '_DICOM.zip' : currentFileNames[0];
                    document.body.appendChild(a);
                    a.click();
                    a.remove();
                    window.URL.revokeObjectURL(url);

                    Swal.fire('다운로드가 완료되었습니다!', '', 'success');
                } else {
                    Swal.fire('다운로드에 실패했습니다!', '오류가 발생했습니다: ' + xhr.statusText, 'error');
                }
            };
            xhr.onerror = function () {
                Swal.fire('다운로드에 실패했습니다!', '오류가 발생했습니다: ' + xhr.statusText, 'error');
            };
            xhr.send();
        }
    });
});



// canvas를 활용한 jpg 다운로드
$(".imageDownLoad").click(function () {
	const titleMessage = currentFileNames.length > 1 
    ? '모든 이미지 파일을 다운로드하시겠습니까?' 
    : '이미지 파일을 다운로드하시겠습니까?';
    Swal.fire({
        title: titleMessage,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    }).then(async (result) => {
        if (result.isConfirmed) {
            // Cornerstone 요소가 활성화되었는지 확인
            let enabledElement = cornerstone.getEnabledElement(element);

            // 요소가 활성화되지 않은 경우 활성화
            if (!enabledElement) {
                cornerstone.enable(element);
            }

            // 렌더링된 이미지를 담을 배열
            let images = [];

            // imageIds와 currentFileNames 배열을 사용하여 이미지를 다운로드
            for (let i = 0; i < imageIds.length; i++) {
                try {
                    const image = await cornerstone.loadImage(imageIds[i]);

                    // 이미지를 캔버스로 변환
                    const canvas = document.createElement('canvas');
                    canvas.width = image.width;
                    canvas.height = image.height;
                    const context = canvas.getContext('2d');

                    // Cornerstone에서 canvas로 이미지를 렌더링
                    cornerstone.renderToCanvas(canvas, image);

                    // 캔버스를 이미지로 변환
                    const imageData = canvas.toDataURL("image/jpeg");
                    images.push({
                        imageData: imageData,
                        fileName: currentFileNames[i].replace(".dcm", ".jpg")
                    });
                } catch (error) {
                    console.error(`Error loading image at index ${i}:`, error);
                }
            }

            // 이미지가 여러 개이면 ZIP으로 다운로드
            if (images.length > 1) {
                const zip = new JSZip();
                images.forEach((img) => {
                    zip.file(img.fileName, img.imageData.split(',')[1], {base64: true});
                });
                zip.generateAsync({type: "blob"}).then(function(content) {
                    const a = document.createElement('a');
                    a.href = URL.createObjectURL(content);
                    a.download = currentPname + "_"+ currentModality + "_images.zip";
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    Swal.fire('다운로드가 완료되었습니다!', '', 'success');
                });
            } else if (images.length === 1) {
                // 이미지가 하나이면 바로 다운로드
                const a = document.createElement('a');
                a.href = images[0].imageData;
                a.download = images[0].fileName;
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                Swal.fire('다운로드가 완료되었습니다!', '', 'success');
            } else {
                Swal.fire('다운로드 실패!', '이미지를 찾을 수 없습니다.', 'error');
            }
        }
    });
});


// 삭제 이벤트
$(".dcmDelete").click(function () {
    Swal.fire({
        title: '정말로 삭제 하시겠습니까?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            // AJAX 요청으로 파일 삭제
            $.ajax({
                type: "POST",
                url: "/deleteDICOM",
                data: {
                    fileName: currentImageName // 현재 표시 중인 이미지 파일 이름을 전송
                },
                success: function(response) {
                    // 삭제 성공 시 알림
                    Swal.fire(
                        '삭제가 완료되었습니다!',
                        '',
                        'success'
                    ).then(() => {
                        // 페이지 리로드 또는 원하는 행동 수행
                        location.reload(); // 삭제 후 페이지를 새로고침
                    });
                },
                error: function(xhr, status, error) {
                    // 삭제 실패 시 알림
                    Swal.fire(
                        '삭제 실패!',
                        '오류가 발생했습니다: ' + xhr.responseText,
                        'error'
                    );
                }
            });
        }
    });
});




//주석 버튼 클릭 시 드롭다운 메뉴 표시/숨기기
annotationButton.addEventListener('click', function (e) {
    e.stopPropagation(); // 이벤트 버블링 방지

    const buttonRect = annotationButton.getBoundingClientRect();
    annotationModal.style.top = buttonRect.bottom+'px';
    annotationModal.style.left = buttonRect.left+'px';

    // 메뉴 표시/숨김 토글
    if (annotationModal.style.display === 'none' || !annotationModal.style.display) {
        annotationModal.classList.add('custom-width'); // 너비 조절을 위한 클래스 추가
        annotationModal.style.display = 'grid';
        annotationButton.classList.add('custom-active'); // 버튼 활성화 효과
    } else {
    	hideAnnotationMenu();
    }
});

//imageLayoutButton 클릭 시 layoutModal 생성 및 표시
imageLayoutButton.addEventListener('click', function (e) {
    e.stopPropagation(); // 이벤트 버블링 방지

    // layoutModal이 없으면 생성
    let layoutModal = document.querySelector('.layoutModal');
    if (!layoutModal) {
        layoutModal = document.createElement('div');
        layoutModal.classList.add('toolModalChildren', 'layoutModal');

        const gridSize = 5;  // 그리드 크기 설정 (5x5)

        // 5x5 그리드 생성
        for (let row = 1; row <= gridSize; row++) {
            for (let col = 1; col <= gridSize; col++) {
                const gridItem = document.createElement('div');
                gridItem.classList.add('grid-item');
                gridItem.dataset.row = row;  // 행 번호 저장
                gridItem.dataset.col = col;  // 열 번호 저장

                layoutModal.appendChild(gridItem);

                // 각 그리드 아이템에 마우스 오버 이벤트 추가
                gridItem.addEventListener('mouseenter', function () {
                    highlightGridItems(row, col);
                });

                gridItem.addEventListener('mouseleave', function () {
                    removeHighlightGridItems();
                });

                // 클릭 시 레이아웃 업데이트
                gridItem.addEventListener('click', function () {
                	
                    // 도구 초기화 호출
                    initializeAllTools();

                    // 도구 비활성화 호출
                    disableAllTools();
                	
                    const rows = parseInt(gridItem.dataset.row);
                    const cols = parseInt(gridItem.dataset.col);
                    updateWadoBoxLayout(rows, cols);
                    if(rows === 1 && cols === 1){
                    	resetCenterPanel();
                    }
                    
                    hideLayoutMenu(); // 메뉴 숨기기
                });
            }
        }

        document.body.appendChild(layoutModal);

        // 마우스가 layoutModal 또는 imageLayoutButton을 벗어날 때 메뉴 숨기기
        layoutModal.addEventListener('mouseleave', function (e) {
            if (!imageLayoutButton.contains(e.relatedTarget)) {
                hideLayoutMenu();
            }
        });

        imageLayoutButton.addEventListener('mouseleave', function (e) {
            if (!layoutModal.contains(e.relatedTarget)) {
                hideLayoutMenu();
            }
        });
    }

    // 모달 위치를 imageLayoutButton 버튼 아래로 조정
    const buttonRect = imageLayoutButton.getBoundingClientRect();
    layoutModal.style.top = buttonRect.bottom+'px';
    layoutModal.style.left = buttonRect.left+'px';

    // 메뉴 표시/숨김 토글
    if (layoutModal.style.display === 'none' || !layoutModal.style.display) {
        layoutModal.classList.add('custom-width');
        layoutModal.style.display = 'grid';
        imageLayoutButton.classList.add('custom-active');
    } else {
        hideLayoutMenu();
    }
});

// 그리드 항목 하이라이트 함수
function highlightGridItems(maxRow, maxCol) {
    const gridItems = document.querySelectorAll('.grid-item');
    gridItems.forEach(item => {
        const row = parseInt(item.dataset.row);
        const col = parseInt(item.dataset.col);

        // 현재 항목이 마우스 오버된 항목보다 위 또는 동일한 행/열에 있는지 확인
        if (row <= maxRow && col <= maxCol) {
            item.classList.add('highlight');
        }
    });
}

// 그리드 항목 하이라이트 제거 함수
function removeHighlightGridItems() {
    const highlightedItems = document.querySelectorAll('.grid-item.highlight');
    highlightedItems.forEach(item => {
        item.classList.remove('highlight');
    });
}

//레이아웃 업데이트 함수
function updateWadoBoxLayout(rows, cols) {
    isSingleLayout = (rows === 1 && cols === 1);
    const wadoBox = document.querySelector('.wadoBox');
    const centerPanel = document.querySelector('.center-panel');
    centerPanel.style.border = 'none';
    wadoBox.innerHTML = ''; // 기존 그리드 초기화

    wadoBox.style.gridTemplateColumns = 'repeat(' + cols + ', 1fr)';
    wadoBox.style.gridTemplateRows = 'repeat(' + rows + ', 1fr)';

    const fontSizeClass = getFontSizeClass(rows, cols);

    for (let i = 0; i < rows * cols; i++) {
        const parentDiv = document.createElement('div');
        parentDiv.classList.add('parentDiv', fontSizeClass);
        parentDiv.setAttribute('data-value', i);

        if (i === 0 && !(rows === 1 && cols === 1)) {
            parentDiv.classList.add('layout-active');
        }

        if (!(rows === 1 && cols === 1)) {
            imageScrollLoopButton.disabled = true;
            playClipButton.disabled = true;
            imageScrollLoopButton.classList.add('disabled');
            playClipButton.classList.add('disabled');
            
            parentDiv.addEventListener('click', function () {
                isLayout = true;
                document.querySelectorAll('.parentDiv').forEach(div => div.classList.remove('layout-active'));
                parentDiv.classList.add('layout-active');
                currentImageName = currentFileNames[i];
            });
        } else {
            isLayout = false;
            imageScrollLoopButton.disabled = false;
            playClipButton.disabled = false;
            imageScrollLoopButton.classList.remove('disabled');
            playClipButton.classList.remove('disabled');
        }

        createLayout(parentDiv, i);

        const dicomImageDiv = document.createElement('div');
        dicomImageDiv.classList.add('image-placeholder');
        parentDiv.appendChild(dicomImageDiv);
        wadoBox.appendChild(parentDiv);

        cornerstone.enable(dicomImageDiv);

        if (i < imageIds.length) {
            cornerstone.loadImage(imageIds[i]).then(function(image) {
                cornerstone.displayImage(dicomImageDiv, image);

                // 이미지 로드 후 도구 초기화
                initializeAllToolsForElement(dicomImageDiv);
                disableAllTools();

                // 레이아웃이 1x1이면 뷰포트 초기화
                if (isSingleLayout) {
                    resetViewportToDefault(dicomImageDiv, image);
                }

            }).catch(function(err) {
                console.error('Error loading image for index ' + i, err);
            });
        }

        if (isSingleLayout) {
            cornerstoneTools.addTool(cornerstoneTools.StackScrollMouseWheelTool);
            cornerstoneTools.setToolActive('StackScrollMouseWheel', {});
        } else {
            activateGridScrollWheel();
        }
    }
}



function resetViewportToDefault(activeElement, image) {
    const defaultViewport = cornerstone.getDefaultViewportForImage(activeElement, image);
    cornerstone.setViewport(activeElement, defaultViewport);
}



function activateGridScrollWheel() {
    const gridItems = document.querySelectorAll('.grid-item');
    
    gridItems.forEach(item => {
        item.addEventListener('wheel', function(event) {
            const dicomImageDiv = item.querySelector('.image-placeholder');
            if (dicomImageDiv) {
                const direction = event.deltaY > 0 ? 1 : -1;
                scrollImageInGrid(dicomImageDiv, direction);
            }
        });
    });
}

function scrollImageInGrid(element, direction) {
    const stackState = cornerstoneTools.getToolState(element, 'stack');
    if (stackState && stackState.data.length > 0) {
        const stackData = stackState.data[0];
        const imageCount = stackData.imageIds.length;
        
        // 현재 이미지 인덱스 업데이트
        stackData.currentImageIdIndex = (stackData.currentImageIdIndex + direction + imageCount) % imageCount;
        
        cornerstone.loadAndCacheImage(stackData.imageIds[stackData.currentImageIdIndex]).then(function(image) {
            cornerstone.displayImage(element, image);
        });
    }
}



//폰트 크기 매핑 테이블 생성
const fontSizeMapping = {
    large: [
        [1, 4], [1, 5], [4, 1], [5, 1],
        [2, 2], [2, 3], [2, 4], [3, 2], [4, 2]
    ],
    medium: [
        [2, 5], [5, 2], [3, 3], [3, 4], [3, 5],
        [4, 3], [5, 3]
    ],
    XLarge: [
        [1, 1], [1, 2], [1, 3],
        [2, 1], [3, 1]
    ]
};

//폰트 크기 클래스 반환 함수
function getFontSizeClass(rows, cols) {
    for (const [fontSize, conditions] of Object.entries(fontSizeMapping)) {
        if (conditions.some(([r, c]) => r === rows && c === cols)) {
            return fontSize;
        }
    }
    return 'small';  // 기본값은 small
}

//layout 요소 생성 함수
function createLayout(parentDiv, index) {
	
	
    // 필요한 경우 추가 정보 표시용 요소들 추가
    const topLeft = document.createElement('div');
    const bottomRight = document.createElement('div');
    
    topLeft.classList.add('topLeft');
    bottomRight.classList.add('bottomRight');

    const pnameElement = document.createElement('span');
    pnameElement.classList.add('block');
    pnameElement.textContent = '환자명: ' + fileDataListGlobal[index]["pname"];

    const pidElement = document.createElement('span');
    pidElement.classList.add('block');
    pidElement.textContent = '환자 코드: ' + fileDataListGlobal[index]["pid"];

    const birthDateElement = document.createElement('span');
    birthDateElement.classList.add('block');
    birthDateElement.textContent = '생년월일: ' + fileDataListGlobal[index]["pbirthdatetime"];

    const studyDateElement = document.createElement('span');
    studyDateElement.classList.add('block');
    studyDateElement.textContent = '검사일: ' + fileDataListGlobal[index]["studydate"];

    const studyTimeElement = document.createElement('span');
    studyTimeElement.classList.add('block');
    studyTimeElement.textContent = '시간: ' + fileDataListGlobal[index]["studytime"];

    const imageNumberElement = document.createElement('span');
    imageNumberElement.classList.add('block');
    imageNumberElement.textContent = 'Image: ' + (index + 1);

    const imageWWWCElement = document.createElement('span');
    imageWWWCElement.classList.add('block','wwwc');
    imageWWWCElement.innerHTML = "WW : " + Math.round(initialWindowWidth) + "<br>WC : " + Math.round(initialWindowCenter);
    
    
    // 요소 추가
    topLeft.appendChild(imageNumberElement);
    topLeft.appendChild(pidElement);
    topLeft.appendChild(pnameElement);
    topLeft.appendChild(birthDateElement);
    topLeft.appendChild(studyDateElement);
    topLeft.appendChild(studyTimeElement);
    
    bottomRight.appendChild(imageWWWCElement);

    parentDiv.appendChild(topLeft);
    parentDiv.appendChild(bottomRight);
}


// 리셋
function resetCenterPanel() {
    const centerPanel = document.querySelector('.center-panel');
    centerPanel.style.border = '4px solid #ff0000'; // 빨간 테두리 복원
}


// top-left content요소
function topLeftContent(){


}

// 레이아웃 메뉴 숨기기 함수
function hideLayoutMenu() {
    const layoutModal = document.querySelector('.layoutModal');
    if (layoutModal) {
        layoutModal.style.display = 'none';
        layoutModal.classList.remove('custom-width');
        imageLayoutButton.classList.remove('custom-active');
    }
}






//재설정 버튼 클릭 시 드롭다운 메뉴 표시/숨기기
refreshButton.addEventListener('click', function (e) {
    e.stopPropagation(); // 이벤트 버블링 방지

    const buttonRect = refreshButton.getBoundingClientRect();
    refreshModal.style.top = buttonRect.bottom+'px';
    refreshModal.style.left = buttonRect.left+'px';

    // 메뉴 표시/숨김 토글
    if (refreshModal.style.display === 'none' || !refreshModal.style.display) {
    	refreshModal.classList.add('custom-width'); // 너비 조절을 위한 클래스 추가
    	refreshModal.style.display = 'grid';
    	refreshButton.classList.add('custom-active'); // 버튼 활성화 효과
    } else {
    	hideRefreshMenu();
    }
});





// 도구 버튼 또는 드롭다운 메뉴에서 마우스가 벗어났을 때 메뉴 숨김
toolButton.addEventListener('mouseleave', function (e) {
    if (!toolModal.contains(e.relatedTarget)) {
        toolModal.style.display = 'none';
        toolButton.classList.remove('custom-active');
    }
});

toolModal.addEventListener('mouseleave', function (e) {
    if (!toolButton.contains(e.relatedTarget)) {
        toolModal.style.display = 'none';
        toolButton.classList.remove('custom-active');
    }
});

//주석 버튼 또는 드롭다운 메뉴에서 마우스가 벗어 났을 때 메뉴 숨김
annotationButton.addEventListener('mouseleave', function (e) {
    if (!annotationModal.contains(e.relatedTarget)) {
    	annotationModal.style.display = 'none';
        annotationButton.classList.remove('custom-active');
    }
});

annotationModal.addEventListener('mouseleave', function (e) {
    if (!annotationButton.contains(e.relatedTarget)) {
    	annotationModal.style.display = 'none';
        annotationButton.classList.remove('custom-active');
    }
});


// 재설정 버튼 또는 재설정 도구 메뉴에서 마우스가 벗어 났을 때 메뉴 숨김
refreshButton.addEventListener('mouseleave', function (e) {
    if (!refreshModal.contains(e.relatedTarget)) {
    	refreshModal.style.display = 'none';
    	refreshButton.classList.remove('custom-active');
    }
});

refreshModal.addEventListener('mouseleave', function (e) {
    if (!refreshButton.contains(e.relatedTarget)) {
    	refreshModal.style.display = 'none';
    	refreshButton.classList.remove('custom-active');
    }
});


// 모든 도구 활성화 설정 및 이벤트 핸들러 설정
document.querySelectorAll('.tool-button').forEach(button => {
    button.addEventListener('click', (event) => {
        const tool = event.currentTarget.getAttribute('data-tool');

        // 레이아웃이 분할된 경우와 분할되지 않은 경우를 구분
        const activeElement = isSingleLayout 
            ? element  // 1x1 상태일 때는 기본 element 사용
            : document.querySelector('.parentDiv.layout-active .image-placeholder');  // 기존 코드에서의 `element` 사용

        if (!activeElement) {
            console.error("No active element found.");
            return;
        }

        // 뷰포트 가져오기
        let viewport = cornerstone.getViewport(activeElement);

        
        switch(tool) {
            case 'defaultTool':
                setActiveButton(event.currentTarget);
                disableAllTools();
                document.querySelector('.center-panel').style.cursor = customCursor;
                break;

            case 'windowLevel':
                setActiveButton(event.currentTarget);
                disableAllTools();

                isWindowLevelActive = !isWindowLevelActive;
                
                document.querySelectorAll('.image-placeholder').forEach(imageDiv => {
                    imageDiv.addEventListener('mousedown', function(e) {
                        if (isWindowLevelActive) {
                        	windowLevelMouseDownHandler(e);
                        	activeImageElement = imageDiv;
                        }                                          
                    });
                });
                break;


            case 'invert':
                viewport.invert = !viewport.invert;
                cornerstone.setViewport(activeElement, viewport); // activeElement 사용
                break;

			case 'imageMove':
				activateNomalTool('Pan', event.currentTarget);

				// 이미지가 렌더링된 후 도구가 올바르게 활성화되었는지 확인
				element.addEventListener('cornerstoneimagerendered', () => {
				    currentViewport = cornerstone.getViewport(activeElement);
				});
			    break;

            case 'scrollLoop':
                // 스크롤 루프 기능 활성화/비활성화 토글
                isScrollLoopActive = !isScrollLoopActive;
				console.log("isScrollLoopActive",isScrollLoopActive);
                if (isScrollLoopActive) {
                    event.currentTarget.classList.add('active'); // 활성화된 상태로 표시
                } else {
                    event.currentTarget.classList.remove('active'); // 버튼 활성화 표시 해제
                }
                
                // stackScrollOptions 값을 업데이트합니다.
                stackScrollOptions.configuration.loop = isScrollLoopActive;

                // 기존 도구 제거
                cornerstoneTools.removeTool('StackScrollMouseWheel');
                
                // 업데이트된 옵션으로 도구 다시 추가
                cornerstoneTools.addTool(cornerstoneTools.StackScrollMouseWheelTool, stackScrollOptions);
                cornerstoneTools.setToolActive('StackScrollMouseWheel', {});
                break;
            case 'playClip':
            	playClip();
                break;
            case 'saveAnnotation':
            	saveAnnotation();
                break;
	        // 도구 관련 버튼 이벤트들
            case 'magnify':
            	activateNomalToolMenu('Magnify', event.currentTarget);
            	
                // 마우스 이벤트 추가
                element.addEventListener('mousedown', hideCursor);
                element.addEventListener('mouseup', showCursor);
            	break;
            	
            case 'zoom':
            	setActiveButton(toolsButton);
            	setActiveToolsButton(event.currentTarget);
            	disableAllTools();
                isZoomActive = true; // Zoom 기능 활성화
                element.addEventListener('mousedown', zoomMouseDownHandler); // 마우스 다운 이벤트 추가
            	hideToolMenu();
            	break;
            	
            case 'rotate':
            	activateNomalToolMenu('Rotate', event.currentTarget);
            	break;
            case 'left_rotate':
                viewport.rotation-=90;
                cornerstone.setViewport(activeElement, viewport);
                hideToolMenu();
            	break;
            case 'right_rotate':
                viewport.rotation+=90;
                cornerstone.setViewport(activeElement, viewport);
                hideToolMenu();
            	break;
            case 'h_flip':
            	viewport.hflip = !viewport.hflip;
                cornerstone.setViewport(activeElement, viewport);
                hideToolMenu();
            	break;
            case 'v_flip':
                viewport.vflip = !viewport.vflip;
                cornerstone.setViewport(activeElement, viewport);
                hideToolMenu();
            	break;
            case 'interpolation':
                viewport.pixelReplication = !viewport.pixelReplication;
                cornerstone.setViewport(activeElement, viewport);
                hideToolMenu();
            	break;
            case 'reference_line':
                setActiveToolsButton(event.currentTarget);
            	disableAllTools();
                cornerstoneTools.addTool(cornerstoneTools.ReferenceLinesTool);
                cornerstoneTools.setToolEnabled('ReferenceLines');          	
            	hideToolMenu();
            	break;
            // 주석 도구 이벤트
            case 'angle':
            	activateAnnotationTool('Angle', event.currentTarget);
            	break;
            case 'arrowAnnotate':
            	activateAnnotationTool('ArrowAnnotate', event.currentTarget);          	
            	break;
            case 'probe':
            	activateAnnotationTool('Probe', event.currentTarget);
            	break;
            case 'length':
            	activateAnnotationTool('Length', event.currentTarget);
            	break;
            case 'rectangleRoi':
            	activateAnnotationTool('RectangleRoi', event.currentTarget);
            	break;
            case 'ellipticalRoi':
            	activateAnnotationTool('EllipticalRoi', event.currentTarget);
            	break;
            case 'freeHand':
            	activateAnnotationTool('FreehandRoi', event.currentTarget);
            	break;
            case 'bidirectional':
            	activateAnnotationTool('Bidirectional', event.currentTarget);
            	break;
            case 'cobbAngle':
            	activateAnnotationTool('CobbAngle', event.currentTarget);
            	break;
            case 'TextMarker':
            	activateAnnotationTool('TextMarker', event.currentTarget);
            	break;
            case 'eraser':
            	activateAnnotationTool('Eraser', event.currentTarget);
            	break;
            case 'canvasReset':
            	resetCanvas(activeElement,viewport);
            	cornerstone.updateImage(activeElement);
                hideRefreshMenu();
                break;

            case 'toolClear':
                // 툴 재설정 기능 구현
                const toolStateManager = cornerstoneTools.globalImageIdSpecificToolStateManager;
                toolStateManager.clear(activeElement); // 주석 도구 상태 초기화
                
                cornerstone.setViewport(activeElement, viewport); // 도구로 이미지 변형 유지                
                cornerstone.updateImage(activeElement);
                
                hideRefreshMenu();
                break;

            case 'allClear':
                // 전부 삭제 기능 구현
                cornerstone.reset(activeElement); // 캔버스 재설정과 모든 변경 사항 초기화
                const fullToolStateManager = cornerstoneTools.globalImageIdSpecificToolStateManager;
                
                fullToolStateManager.clear(activeElement); // 주석 도구 상태 초기화
                
                if (originalImageSize && initialWindowWidth !== null && initialWindowCenter !== null) {
                    const containerWidth = element.clientWidth;
                    const containerHeight = element.clientHeight;
                    const scale = Math.min(containerWidth / originalImageSize.width, containerHeight / originalImageSize.height);

                    let viewport = cornerstone.getViewport(activeElement);
                    viewport.voi.windowWidth = initialWindowWidth;
                    viewport.voi.windowCenter = initialWindowCenter;
                    cornerstone.setViewport(activeElement, viewport);
                    cornerstone.updateImage(activeElement); // UI 업데이트 강제 적용
                    
                    
                    // activeElement의 부모 요소에서 .bottomRight .wwwc 요소 찾기
                    const parentElement = activeElement.parentElement;
                    const bottomRightElement = parentElement.querySelector('.bottomRight .wwwc');
                    
                    if (bottomRightElement) {
                        bottomRightElement.innerHTML = "WW : " + Math.round(viewport.voi.windowWidth) + "<br>WC : " + Math.round(viewport.voi.windowCenter);
                    }    
                }
                hideRefreshMenu();
                break;
        }
        
        if (tool !== 'magnify') {
            element.removeEventListener('mousedown', hideCursor);
            element.removeEventListener('mouseup', showCursor);
            element.style.cursor = customCursor; // 기본 커서로 복귀
        }
        
    });
});


// 기본 도구 활성화 설정
setActiveButton(document.querySelector('[data-tool="defaultTool"]'));
document.querySelector('.center-panel').style.cursor = customCursor;


// /dicom 엔드포인트 호출하여 DICOM 데이터 가져오기
fetch(fileUrl)
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json(); // 데이터를 JSON으로 받음
    })
    .then(fileDataList => {
        console.log("Fetched DICOM data:", fileDataList);
        if (!Array.isArray(fileDataList) || fileDataList.length === 0) {
            throw new Error('No DICOM files found');
        }

        // Base64 디코딩 후 Blob 생성 및 SOPInstanceUID 저장
        sopInstanceUIDs = fileDataList.map(fileData => fileData.sop_instance_uid); // SOPInstanceUID 저장
        fileDataListGlobal = fileDataList;
        imageIds = fileDataList.map((fileData, index) => {
            const byteCharacters = atob(fileData.file_data); // Base64 디코딩
            const byteNumbers = new Array(byteCharacters.length);
            for (let i = 0; i < byteCharacters.length; i++) {
                byteNumbers[i] = byteCharacters.charCodeAt(i);
            }
            const byteArray = new Uint8Array(byteNumbers);
            const fileBlobUrl = URL.createObjectURL(new Blob([byteArray]));
            return 'wadouri:' + fileBlobUrl;
        });

        currentFileNames = fileDataList.map(fileData => fileData.file_name);
        currentPname = fileDataList[0].pname;  // 첫 번째 파일의 pname을 사용
        currentModality = fileDataList[0].modality;

        const stack = {
            currentImageIdIndex: currentImageIndex,
            imageIds: imageIds,
        };

        function loadAndDisplayImage(index) {
            cornerstone.loadImage(imageIds[index]).then(function(image) {

                // 처음 이미지를 로드할 때 원본 크기를 기억합니다.
                if (!originalImageSize) {
                    originalImageSize = { width: image.columns, height: image.rows };
                }

                // 초기 윈도우 레벨 값을 저장
                if (initialWindowWidth === null && initialWindowCenter === null) {
                    initialWindowWidth = image.windowWidth;
                    initialWindowCenter = image.windowCenter;
                }

                if (currentViewport) {
                    cornerstone.displayImage(element, image);
                    cornerstone.setViewport(element, currentViewport);
                } else {
                    cornerstone.displayImage(element, image);
                    currentViewport = cornerstone.getViewport(element);
                }

                // 스택 상태 설정
                cornerstoneTools.addStackStateManager(element, ['stack']);
                cornerstoneTools.addToolState(element, 'stack', stack);

                // 도구 초기화 호출
                initializeAllTools();
                disableAllTools();             

                // 주석 복원 로직을 SOPInstanceUID 기반으로 이미지가 로드된 후에 호출
                const sopInstanceUID = sopInstanceUIDs[index]; // 현재 이미지의 SOPInstanceUID 가져오기
                const annotationData = fileDataList.find(fileData => fileData.sop_instance_uid === sopInstanceUID)?.annotations;

                if (annotationData) {
                    console.log("Restoring annotations for SOPInstanceUID:", sopInstanceUID);
                    const toolState = JSON.parse(annotationData);

                    // 주석 복원
                    cornerstoneTools.globalImageIdSpecificToolStateManager.restoreToolState(toolState);
                }

                // 이미지 렌더링 시마다 호출되는 이벤트 리스너 추가
                element.addEventListener('cornerstoneimagerendered', function() {
                    const stackState = cornerstoneTools.getToolState(element, 'stack');
                    if (stackState && stackState.data.length > 0) {
                        const stackData = stackState.data[0];
                        currentImageIndex = stackData.currentImageIdIndex; // 현재 이미지 인덱스를 가져옴
                        
                        if(!isLayout){
                            // 이미지 정보가 들어갈 부모 요소 선택
                            const topLeftElement = document.querySelector('.topLeft');
                            
                            // imageNumber 요소가 이미 존재하는지 확인
                            let imageNumberElement = document.querySelector('.imageNumber');
                            if (!imageNumberElement) {
                                // 존재하지 않으면 생성해서 추가
                                imageNumberElement = document.createElement('span');
                                imageNumberElement.className = 'block imageNumber';
                                topLeftElement.appendChild(imageNumberElement);
                            }

                            // imagePid 요소가 이미 존재하는지 확인
                            let imagePidElement = document.querySelector('.imagePid');
                            if(!imagePidElement){
                                imagePidElement = document.createElement('span');
                                imagePidElement.className = 'block imagePid';
                                topLeftElement.appendChild(imagePidElement);
                            }

                            // imagePname 요소가 이미 존재하는지 확인
                            let imagePnameElement = document.querySelector('.imagePname');
                            if (!imagePnameElement) {
                                // 존재하지 않으면 생성해서 추가
                                imagePnameElement = document.createElement('span');
                                imagePnameElement.className = 'block imagePname';
                                topLeftElement.appendChild(imagePnameElement);
                            }
                            
                            // imagePbirthdatetime 요소가 이미 존재하는지 확인
                            let imagePbirthdatetime = document.querySelector('.imagePbirthdatetime');
                            if(!imagePbirthdatetime){
                                // 존재하지 않으면 생성해서 추가
                                imagePbirthdatetime = document.createElement('span');
                                imagePbirthdatetime.className = 'block imagePbirthdatetime';
                                topLeftElement.appendChild(imagePbirthdatetime);
                            }
                            
                            // imageDate 요소가 이미 존재하는지 확인
                            let imageDateElement = document.querySelector('.imageDate');
                            if (!imageDateElement) {
                                // 존재하지 않으면 생성해서 추가
                                imageDateElement = document.createElement('span');
                                imageDateElement.className = 'block imageDate';
                                topLeftElement.appendChild(imageDateElement);
                            }
                            
                            // imageTime 요소가 이미 존재하는지 확인
                            let imageTimeElement = document.querySelector('.imageTime');
                            if (!imageTimeElement) {
                                // 존재하지 않으면 생성해서 추가
                                imageTimeElement = document.createElement('span');
                                imageTimeElement.className = 'block imageTime';
                                topLeftElement.appendChild(imageTimeElement);
                            }

                            // 요소에 값을 설정
                            imageNumberElement.textContent = "Images : "+(currentImageIndex + 1) + '/' + fileDataListGlobal.length;
                            imagePnameElement.textContent = "환자 이름 : "+fileDataListGlobal[0]["pname"];
                            imagePidElement.textContent = "환자 코드 : "+fileDataListGlobal[0]["pid"];
                            imagePbirthdatetime.textContent = "생년월일 : "+fileDataListGlobal[0]["pbirthdatetime"];
                            imageDateElement.textContent = "검사일 : "+fileDataListGlobal[0]["studydate"];
                            imageTimeElement.textContent = "시간 : "+fileDataListGlobal[0]["studytime"];
                        }
                        // 현재 이미지 파일 이름 업데이트
                        currentImageName = currentFileNames[currentImageIndex];
                    }
                });

                const viewport = cornerstone.getViewport(element);
                // 이미지 불러올떄 쓰는 window 값
                document.querySelector('.wwwc').innerHTML = "WW : " + Math.round(viewport.voi.windowWidth) + "<br>WC : " + Math.round(viewport.voi.windowCenter);
                resizeImage();
                
            }).catch(function(err) {
                console.error('Error loading image:', err);
            });
        }
        
        window.addEventListener('resize', resizeImage);
        
        function updateImageNumber() {
			topLeftContent();
        }

        function resizeImage() {
            console.log("Resizing image");

            // 현재 뷰포트가 있으면 복사하고, 없으면 새로운 뷰포트를 생성
              let updatedViewport = currentViewport ? {...currentViewport} : cornerstone.getDefaultViewportForImage(element, image);


              // 현재 뷰포트의 스케일을 조정 (원본 이미지 크기를 기준으로)
              if (originalImageSize) {
                  const containerWidth = element.clientWidth;
                  const containerHeight = element.clientHeight;
                  const scale = Math.min(containerWidth / originalImageSize.width, containerHeight / originalImageSize.height, 1);

                  // 기존의 뷰포트 값을 유지하면서 scale만 업데이트
                  updatedViewport.scale = scale;

                  // 뷰포트 설정 적용
                  cornerstone.setViewport(element, updatedViewport);
                  cornerstone.resize(element, true);

                  // 이미지를 다시 렌더링하여 뷰포트 업데이트
                  cornerstone.updateImage(element);
              } else {
                  console.error("Original image size is not set.");
              }
          }
          loadAndDisplayImage(currentImageIndex);

          // Cornerstone MouseWheelTools 설정
          const StackScrollMouseWheelTool = cornerstoneTools.StackScrollMouseWheelTool;

          cornerstoneTools.addTool(StackScrollMouseWheelTool, stackScrollOptions);
          cornerstoneTools.setToolActive('StackScrollMouseWheel', {});

          // 클립 재생 함수
          function startClipPlayback() {
              if (isPlaying) clearInterval(playInterval); // 기존 인터벌을 삭제하여 FPS 변경을 반영
              isPlaying = true;

              const stackState = cornerstoneTools.getToolState(element, 'stack');
              const stackData = stackState.data[0];

              playInterval = setInterval(() => {
                  currentImageIndex = (currentImageIndex + 1) % stackData.imageIds.length; // 스택에서 다음 이미지로 이동
                  stackData.currentImageIdIndex = currentImageIndex; // 스택 상태 업데이트

                  cornerstone.loadAndCacheImage(stackData.imageIds[currentImageIndex]).then(function(image) {
                      cornerstone.displayImage(element, image);
                      cornerstone.setViewport(element, currentViewport);
                  });
              }, 1000 / fps);
          }

          // 클립 정지 함수
          function stopClipPlayback() {
              clearInterval(playInterval);
              isPlaying = false;
          }

          // 전역 변수에 할당하여 외부에서 접근 가능하게 설정
          stopClipPlaybackGlobal = stopClipPlayback;

          // FPS 조정 버튼 클릭 이벤트
          document.querySelector('.fpsbutton').addEventListener('click', (event) => {
              if (event.target.closest('.speedbutton')) {
                  const button = event.target.closest('.speedbutton');
                  const direction = button.querySelector('i').classList.contains('fa-angle-left') ? 'decrease' : 'increase';

                  if (direction === 'decrease' && fps > 1) {
                      fps--;
                  } else if (direction === 'increase' && fps < 100) {
                      fps++;
                  }

                  document.querySelector('.fpswords').textContent = 'FPS :' + fps;

                  if (isPlaying) {
                      startClipPlayback(); // FPS 변경에 따라 클립 재생을 업데이트
                  }
              }
          });

          // 버튼 이벤트 설정
          playButton.addEventListener('click', function() {
              if (!playButton.classList.contains('active')) {
                  startClipPlayback();
                  playButton.classList.add('active');
                  stopButton.classList.remove('active');
              }
          });

          // stop 버튼 클릭 이벤트
          stopButton.addEventListener('click', function() {
              if (!stopButton.classList.contains('active')) {
                  stopClipPlayback();
                  stopButton.classList.add('active');
                  playButton.classList.remove('active');
              }
          });

      })
      .catch(error => {
          console.error('Error fetching DICOM data:', error);
      });




//커서 숨김 함수
function hideCursor() {
    element.style.cursor = 'none';
}

// 커서 표시 함수
function showCursor() {
    element.style.cursor = customCursor;
}


//메뉴 숨김 함수
function hideToolMenu(){
    toolModal.style.display = 'none';
    toolModal.classList.remove('custom-width'); // 숨길 때 클래스 제거
    toolButton.classList.remove('custom-active'); // 버튼 활성화 효과 제거
}

function hideAnnotationMenu(){
    annotationModal.style.display = 'none';
    annotationModal.classList.remove('custom-width'); // 숨길 때 클래스 제거
    annotationButton.classList.remove('custom-active'); // 버튼 활성화 효과 제거
}

function hideLayoutMenu() {
    const layoutModal = document.querySelector('.layoutModal');
    if (layoutModal) {
        layoutModal.style.display = 'none';
        layoutModal.classList.remove('custom-width');
        imageLayoutButton.classList.remove('custom-active');
    }
}

function hideRefreshMenu(){
    refreshModal.style.display = 'none';
    refreshModal.classList.remove('custom-width'); // 숨길 때 클래스 제거
    refreshButton.classList.remove('custom-active'); // 버튼 활성화 효과 제거
}



//도구 초기화 함수
function initializeAllTools() {
    const tools = [
        'Pan',
        'Magnify',
        'Rotate',
        'Angle',
        'ArrowAnnotate',
        'Probe',
        'Length',
        'RectangleRoi',
        'EllipticalRoi',
        'FreehandRoi',
        'Bidirectional',
        'CobbAngle',
        'Eraser',
        'Wwwc'
    ];

    document.querySelectorAll('.image-placeholder').forEach(imageDiv => {
        tools.forEach(tool => {
            // 각 도구를 이미지 요소에 대해 활성화
            cornerstoneTools.addTool(cornerstoneTools[tool + 'Tool']);
            cornerstoneTools.setToolActive(tool, { element: imageDiv });
        });
    });
}


//특정 요소에 대해 모든 도구를 초기화하는 함수
function initializeAllToolsForElement(element) {
    const tools = [
        'Pan',
        'Magnify',
        'Rotate',
        'Angle',
        'ArrowAnnotate',
        'Probe',
        'Length',
        'RectangleRoi',
        'EllipticalRoi',
        'FreehandRoi',
        'Bidirectional',
        'CobbAngle',
        'Eraser',
        'Wwwc'
    ];

    tools.forEach(tool => {
        // 해당 도구가 이미 추가되었는지 확인
        if (!cornerstoneTools.getToolForElement(element, tool)) {
            // 도구가 추가되지 않은 경우에만 추가
            cornerstoneTools.addTool(cornerstoneTools[tool + 'Tool'], { element: element });
            cornerstoneTools.setToolActive(tool, { mouseButtonMask: 1 });
        }
    });
}



//모든 도구 비활성화 함수
function disableAllTools() {    
    // 도구 상태를 제거하지 않습니다.
    const tools = [
        'Pan',
        'Magnify',
        'Rotate',
        'Angle',
        'ArrowAnnotate',
        'Probe',
        'Length',
        'RectangleRoi',
        'EllipticalRoi',
        'FreehandRoi',
        'Bidirectional',
        'CobbAngle',
        'TextMarker',
        'Eraser',
        'Wwwc'
    ];

    // 모든 .image-placeholder 요소에서 도구 비활성화 및 이벤트 리스너 제거
    document.querySelectorAll('.image-placeholder').forEach(imageDiv => {
        tools.forEach(tool => {
            cornerstoneTools.setToolDisabled(tool, { element: imageDiv });
        });
        if(isWindowLevelActive){
        	isWindowLevelActive = false;
        	imageDiv.removeEventListener('mousedown', windowLevelMouseDownHandler);
        }
    });
    

    // 주석 도구 상태 유지
    const annotationTools = [
        'Angle',
        'ArrowAnnotate',
        'Probe',
        'Length',
        'RectangleRoi',
        'EllipticalRoi',
        'FreehandRoi',
        'Bidirectional',
        'CobbAngle',
        'TextMarker',
        'Eraser'
    ];
    
    annotationTools.forEach(tool => {
        cornerstoneTools.setToolPassive(tool); // 도구를 passive 모드로 설정하여 상태를 유지
    });
    deactivateZoom();
}



// 활성 버튼 설정
function setActiveButton(button) {
    document.querySelectorAll('.interface-button').forEach(btn => {
        if (btn !== imageScrollLoopButton && btn !== playClipButton) {
            btn.classList.remove('active');
            btn.classList.remove('custom-active');
        }
    });
    button.classList.add('active');
    removeWindowLevelMouseListener();
}

// 도구 버튼 css 설정
function setActiveToolsButton(button) {
    document.querySelectorAll('.interface-button').forEach(btn => {
        if (btn !== imageScrollLoopButton && btn !== playClipButton) {
            btn.classList.remove('custom-active');
        }
    });
    button.classList.add('custom-active');
    removeWindowLevelMouseListener();
}

// 윈도우 레벨 마우스 리스너 제거 함수 (기존 코드)
function removeWindowLevelMouseListener() {
    document.querySelectorAll('.image-placeholder').forEach(imageDiv => {
        imageDiv.removeEventListener('mousedown', windowLevelMouseDownHandler);
    });
}
// 윈도우 레벨 마우스 핸들러 (기존 코드)
function windowLevelMouseDownHandler(e) {
    let lastX = e.pageX;
    let lastY = e.pageY;

    const targetElement = e.currentTarget; // 이벤트가 발생한 현재 타겟 요소
    
 	// 부모 요소를 가져옵니다.
    const parentElement = targetElement.parentElement;

    try {
        let viewport = cornerstone.getViewport(targetElement); // 뷰포트 가져오기 시도
    } catch (error) {
        console.error("Element not enabled for cornerstone:", error);
        return; // 요소가 활성화되지 않았으면 핸들러 종료
    }

    function mouseMoveHandler(e) {
        const deltaX = e.pageX - lastX;
        const deltaY = e.pageY - lastY;
        lastX = e.pageX;
        lastY = e.pageY;

        let viewport = cornerstone.getViewport(targetElement);
        viewport.voi.windowWidth += (deltaX / viewport.scale);
        viewport.voi.windowCenter += (deltaY / viewport.scale);
        cornerstone.setViewport(targetElement, viewport);

     // 부모 요소에서 .bottomRight .wwwc 클래스를 가진 요소를 찾습니다.
        const bottomRightElement = parentElement.querySelector('.bottomRight .wwwc');
     
        if (bottomRightElement) {
            bottomRightElement.innerHTML = "WW : " + Math.round(viewport.voi.windowWidth) + "<br>WC : " + Math.round(viewport.voi.windowCenter);
        }
    }

    function mouseUpHandler() {
        document.removeEventListener('mousemove', mouseMoveHandler);
        document.removeEventListener('mouseup', mouseUpHandler);
    }

    document.addEventListener('mousemove', mouseMoveHandler);
    document.addEventListener('mouseup', mouseUpHandler);
}


// 확대 이벤트 함수
function zoomMouseDownHandler(e) {
    const mouseButton = e.which;
    let lastY = e.pageY;
    
    function mouseMoveHandler(e) {
        const deltaY = e.pageY - lastY;
        lastY = e.pageY;
        
        if(mouseButton === 1){
        let viewport = cornerstone.getViewport(element);
        viewport.scale += (deltaY / 100);
        cornerstone.setViewport(element, viewport);
        }
    }

    function mouseUpHandler() {
        document.removeEventListener('mousemove', mouseMoveHandler);
        document.removeEventListener('mouseup', mouseUpHandler);
    }

    document.addEventListener('mousemove', mouseMoveHandler);
    document.addEventListener('mouseup', mouseUpHandler);
}

// Zoom 기능 비활성화 함수
function deactivateZoom() {
    if (isZoomActive) {
        element.removeEventListener('mousedown', zoomMouseDownHandler);
        isZoomActive = false;
    }
}

//주석 도구를 설정하고 활성화 하는 함수
function activateAnnotationTool(toolName, buttonElement) {
    setActiveButton(annotationButton);
    setActiveToolsButton(buttonElement);
    disableAllTools();
    
    console.log("toolName : ",toolName);
    console.log(toolName === 'TextMarker');
    
    if(toolName === 'TextMarker')
    	cornerstoneTools.addTool(cornerstoneTools[toolName + 'Tool'], { configuration });
    else
    	cornerstoneTools.addTool(cornerstoneTools[toolName + 'Tool']);
    
    cornerstoneTools.setToolActive(toolName, { mouseButtonMask: 1 });
    
    cornerstoneTools.toolColors.setToolColor('#00FFFF');
    cornerstoneTools.toolColors.setActiveColor('#00FF00');
    hideAnnotationMenu();
}

// 일반 도구를 설정하고 활성화 하는  함수
function activateNomalTool(toolName, buttonElement){
	setActiveButton(buttonElement);
	disableAllTools();
	
	cornerstoneTools.addTool(cornerstoneTools[toolName + 'Tool']);
	cornerstoneTools.setToolActive(toolName, { mouseButtonMask: 1 });
}

// 도구 메뉴에 기능들을 설정하고 활성화 하는 함수 
function activateNomalToolMenu(toolName, buttonElement){
	setActiveButton(toolsButton);
	setActiveToolsButton(buttonElement);
	disableAllTools();
	
	cornerstoneTools.setToolActive(toolName, { mouseButtonMask: 1 });
	hideToolMenu();
}


// 주석 저장 함수
function saveAnnotation() {
    Swal.fire({
        title: '저장 하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            // 주석 데이터 가져오기
            let toolState = cornerstoneTools.globalImageIdSpecificToolStateManager.saveToolState();

            // 각 imageId에 대응하는 SOPInstanceUID로 주석 데이터를 재구성
            let annotationData = {};
            let sopInstanceUID = "";  // 현재 보고 있는 이미지의 SOPInstanceUID를 저장할 변수

            for (let imageId in toolState) {
                sopInstanceUID = getSOPInstanceUIDFromImageId(imageId);  // 현재 이미지의 SOPInstanceUID 가져오기
                if (sopInstanceUID) {
                    annotationData[sopInstanceUID] = toolState[imageId];
                }
            }

            // 주석 데이터를 JSON 문자열로 변환합니다.
            const annotations = JSON.stringify(annotationData[sopInstanceUID]);  // 현재 보고 있는 파일의 주석만 저장

            // 서버로 주석 데이터를 전송합니다.
            fetch('/saveAnnotations', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ sopInstanceUID: sopInstanceUID, annotations: annotations })
            }).then(response => {
                if (response.ok) {
                    Swal.fire(
                        '저장이 완료되었습니다!',
                        '',
                        'success'
                    );
                } else {
                    Swal.fire(
                        '저장에 실패했습니다.',
                        '',
                        'error'
                    );
                }
            }).catch(error => {
                console.error('Error:', error);
                Swal.fire(
                    '저장 중 오류가 발생했습니다.',
                    '',
                    'error'
                );
            });
        }
    });
}




function getSOPInstanceUIDFromImageId(imageId) {
    // imageIds 배열에서 imageId의 위치(인덱스)를 찾습니다.
    const imageIndex = imageIds.indexOf(imageId);

    // 해당 인덱스가 존재하면 sopInstanceUIDs 배열에서 해당 인덱스의 값을 반환합니다.
    if (imageIndex !== -1) {
        return sopInstanceUIDs[imageIndex];
    }

    // 만약 imageId가 imageIds 배열에 없다면 null을 반환합니다.
    return null;
}



// 플레이 클립 이벤트 함수
function playClip(){
    isPlayClipActive = !isPlayClipActive;
    if (isPlayClipActive) {
        document.querySelector('.fpswords').textContent = 'FPS :'+ fps;
        playClipModal.style.display = 'block';
        event.currentTarget.classList.add('active'); // 버튼 활성화 표시
        playButton.classList.remove('active');
        stopButton.classList.add('active');
        imageScrollLoopButton.disabled = true; // 스크롤 루프 버튼 비활성화
        imageScrollLoopButton.classList.add('disabled');
        imageLayoutButton.disabled = true;
        imageLayoutButton.classList.add('disabled');
    } else {
        playClipModal.style.display = 'none';
        event.currentTarget.classList.remove('active'); // 버튼 활성화 표시 해제
        imageScrollLoopButton.disabled = false; // 스크롤 루프 버튼 활성화
        imageScrollLoopButton.classList.remove('disabled'); // 비활성화 상태 시각적 표시 해제
        imageLayoutButton.disabled = false;
        imageLayoutButton.classList.remove('disabled');
        
        // 클립 재생 멈추기
		if (typeof stopClipPlaybackGlobal !== 'undefined') {
			stopClipPlaybackGlobal();  // 전역 변수에 저장된 함수 호출
		}
    }
}



// 캔버스 재설정 함수
function resetCanvas(activeElement,viewport) {
    if (originalImageSize && initialWindowWidth !== null && initialWindowCenter !== null) {
        const containerWidth = activeElement.clientWidth;
        const containerHeight = activeElement.clientHeight;
        const scale = Math.min(containerWidth / originalImageSize.width, containerHeight / originalImageSize.height);

        viewport.scale = scale;
        viewport.rotation = 0;
        viewport.hflip = false;
        viewport.vflip = false;
        viewport.invert = false;
        viewport.voi.windowWidth = initialWindowWidth;
        viewport.voi.windowCenter = initialWindowCenter;
        viewport.translation = { x: 0, y: 0 };

        cornerstone.setViewport(activeElement, viewport);
		console.log("viewport : ",viewport);
        // activeElement의 부모 요소에서 .bottomRight .wwwc 요소 찾기
        const parentElement = activeElement.parentElement;
        const bottomRightElement = parentElement.querySelector('.bottomRight .wwwc');
        
        if (bottomRightElement) {
            bottomRightElement.innerHTML = "WW : " + Math.round(viewport.voi.windowWidth) + "<br>WC : " + Math.round(viewport.voi.windowCenter);
        }        
    } else {
        console.error("Original image size or initial window level is not set. Unable to reset canvas properly.");
    }
}

</script>

</body>
</html>