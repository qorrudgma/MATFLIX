<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 헤더 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
	<header class="header">
		<div class="header_container">
			<!-- 로고 (중앙) -->
            <img src="${pageContext.request.contextPath}/image/main_logo.png" alt="MATFLIX로고">
			<div class="header_logo" onclick="location.href='${pageContext.request.contextPath}/main'">
				<h1>MATFLIX</h1>
			</div>

			<!-- 사용자 액션 (오른쪽) -->
			<div class="header_actions">
				<% if(user != null){ %>
					<script>						
						$(document).ready(function(){
							console.log("로그인하고 이제 see연결해볼거야");
							connectSSE();
							//loadInitialNotifications();
						});
					</script>
					<!-- 알림 버튼 -->
					<div class="notification_container">
						<button type="button" id="notification_btn" data-count="<%= session.getAttribute("notification_count") != null ? session.getAttribute("notification_count") : "0" %>">
							<i class="far fa-bell"></i>
						</button>
						<div id="notification_div"></div>
					</div>
					
					<!-- 프로필 정보 -->
					<div class="user_container">
						<div class="profile_image profile">
							<img onclick="my_page()" alt="MATFLIX" src="${pageContext.request.contextPath}/image/MATFLIX.png">
						</div>
						<div class="user_info">
							<div class="profile_info">
								<span><span id="profile_name"><%= user.getMf_nickname()%></span>님 환영합니다.</span>
							</div>
							<div class="user_buttons">
								<button type="button" id="log_out" onclick="location.href='${pageContext.request.contextPath}/log_out'">로그아웃</button>
								<form id="user_profile" class="profile" action="profile" method="post">
									<button type="submit" class="mypage_btn">마이페이지</button>
								</form>
							</div>
						</div>
					</div>
				<% }else{ %>
					<div class="user_actions">
						<!-- 로그인 버튼 클릭 시 login.jsp로 이동 -->
						<button class="btn_login" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button>
						<!-- 회원가입 버튼 클릭 시 recruit.jsp로 이동 -->
						<button class="btn_register" onclick="location.href='${pageContext.request.contextPath}/recruit'">회원가입</button>
					</div>
				<% } %>
			</div>
		</div>

		<!-- 네비게이션 메뉴 (같은 헤더 안에 포함) -->
		<nav id="header_nav">
			<div><a href="recipe_board?rc_type=&rc_keyword=&rc_pageNum=1&rc_amount=12"><div>레시피</div></a></div>
			<div><a href="${pageContext.request.contextPath}/user_rank"><div> 랭킹 </div></a></div>
			<div><a href="list"><div>게시판</div></a></div>
			<div><a href="${pageContext.request.contextPath}/notice_list"><div> 공지사항 </div></a></div>
			<div> 더보기 </div>
		</nav>
	</header>	

	<script>
		<% if (user != null) { %>
			var sessionUserNo = <%= user.getMf_no() %>;
			var notification_count = <%= session.getAttribute("notification_count") != null ? session.getAttribute("notification_count") : "0" %>;
			
			// 알림 카운트가 있으면 알림 배지 표시
			if (notification_count > 0) {
				document.getElementById("notification_btn").style.setProperty('--notification-visibility', 'visible');
			}
			
			console.log(sessionUserNo);
		<% } else { %>
			var sessionUserNo = null;
		<% } %>
    
    // 알림 버튼 클릭
    // $(document).on("click", "#notification_btn", function (e) {
    //     e.preventDefault();
    //     $("#notification_div").toggleClass("active");

    //     var followerId = parseInt(sessionUserNo, 10);
        
    //     $.ajax({
    //          type: "POST"
    //         ,url: "/notification_list"
    //         ,data: {follower_id: followerId}
    //         ,dataType: "json"
    //         ,success: function (notification_list) {
    //             console.log("notification_list 받아옴");

    //             let notification_data="";

    //             console.log(notification_count);
    //             if (notification_count != 0 && notification_count != null) {
    //                 notification_data += "<div class='notification_header'><h3>알림 " + notification_count + "개</h3></div>";
    //             } else {
    //                 notification_data += "<div class='notification_header'><h3>새로운 알림이 없습니다</h3></div>";
    //             }
                
    //             for (let i = 0; i < notification_list.length && i < 10; i++) {
    //                 if (notification_list[i].is_read == 1) {
    //                     notification_data += "<div id='notification_card' class='read_true'>";
    //                 } else {
    //                     notification_data += "<div id='notification_card'>";
    //                 }
    //                 notification_data += "<div>상태: " + (notification_list[i].is_read == 1 ? "읽음" : "안읽음") + "</div>";
    //                 notification_data += "<div>시간: " + notification_list[i].created_at + "</div>";
    //                 notification_data += "<div>작성자: " + notification_list[i].following_id + "</div>";
    //                 notification_data += "<div>게시글 번호: " + notification_list[i].boardNo + "</div>";
    //                 notification_data += "<div>유형: " + (notification_list[i].post_id ? "댓글" : "게시글") + "</div>";
    //                 notification_data += '<button type="button" class="move_board" data-board_no="'+notification_list[i].boardNo+'" data-notifications_id="'+notification_list[i].notifications_id+'">보러가기</button>';
    //                 notification_data += "</div>";
    //             }
    //             console.log(notification_data);
    //             document.getElementById("notification_div").innerHTML = notification_data;
    //             document.getElementById("notification_div").value = "";
    //         }
    //         ,error: function (error) {
    //             console.log(error);
    //         }
    //     });
    // });

    // 전역 변수
    let eventSource;
    let notificationCount = 0;

	// SSE
	function connectSSE() {
		console.log("connectSSE 잘 도착함");
		
		const eventSource = new EventSource("/sse/subscribe/" + sessionUserNo);
		
		eventSource.onmessage = function(event){
			console.log("SSE 메시지: ", event.data);
		}
		
		eventSource.addEventListener("alert", function(event) {
		    console.log("알림 이벤트:", event.data);
		    // 알림 표시 새로 바꾸기
		});
		
		eventSource.onerror = function(err){
			console.log("SSE 오류: ", err);
		}
	}
	
    // 초기 알림 로드
    function loadInitialNotifications() {
        var followerId = parseInt(sessionUserNo, 10);
        
        $.ajax({
            type: "POST",
            url: "/notification_list",
            data: {follower_id: followerId},
            dataType: "json",
            success: function(notification_list) {
                // 읽지 않은 알림 개수 저장 및 표시
                notificationCount = notification_list.filter(item => item.is_read === 0).length;
                updateNotificationBadge(notificationCount);
            },
            error: function(error) {
                console.log(error);
            }
        });
    }

    // 알림 배지 업데이트
    function updateNotificationBadge(count) {
        // 기존 배지 제거
        $("#notification_btn .notification-badge").remove();
        
        // 알림이 있으면 배지 추가
        if (count > 0) {
            $("#notification_btn").append('<span class="notification-badge">' + count + '</span>');
        }
    }

    // 브라우저 알림 표시
    function showBrowserNotification(message) {
        // 브라우저 알림 권한 확인
        if (Notification.permission === "granted") {
            new Notification("새 알림", {
                body: message,
                icon: "/path/to/notification-icon.png"
            });
        } else if (Notification.permission !== "denied") {
            // 권한 요청
            Notification.requestPermission().then(permission => {
                if (permission === "granted") {
                    new Notification("새 알림", {
                        body: message,
                        icon: "/path/to/notification-icon.png"
                    });
                }
            });
        }
    }

    // 알림 목록 로드 (기존 코드와 유사)
    function loadNotifications() {
        var followerId = parseInt(sessionUserNo, 10);
        
        $.ajax({
            type: "POST",
            url: "/notification_list",
            data: {follower_id: followerId},
            dataType: "json",
            success: function(notification_list) {
                // 기존 코드와 동일한 UI 업데이트 로직
                let notification_data = "";
                
                if (notification_list.length > 0) {
                    notification_data += "<div class='notification_header'><h3>알림 " + notification_list.length + "개</h3></div>";
                } else {
                    notification_data += "<div class='notification_header'><h3>새로운 알림이 없습니다</h3></div>";
                }
                
                for (let i = 0; i < notification_list.length && i < 10; i++) {
                    // 기존 코드와 동일
                    if (notification_list[i].is_read == 1) {
                        notification_data += "<div id='notification_card' class='read_true'>";
                    } else {
                        notification_data += "<div id='notification_card'>";
                    }
                    notification_data += "<div>상태: " + (notification_list[i].is_read == 1 ? "읽음" : "안읽음") + "</div>";
                    notification_data += "<div>시간: " + notification_list[i].created_at + "</div>";
                    notification_data += "<div>작성자: " + notification_list[i].following_id + "</div>";
                    notification_data += "<div>게시글 번호: " + notification_list[i].boardNo + "</div>";
                    notification_data += "<div>유형: " + (notification_list[i].post_id ? "댓글" : "게시글") + "</div>";
                    notification_data += '<button type="button" class="move_board" data-board_no="'+notification_list[i].boardNo+'" data-notifications_id="'+notification_list[i].notifications_id+'">보러가기</button>';
                    notification_data += "</div>";
                }
                
                document.getElementById("notification_div").innerHTML = notification_data;
                
                // 알림을 확인했으므로 카운트 리셋
                if ($("#notification_div").hasClass("active")) {
                    notificationCount = 0;
                    updateNotificationBadge(notificationCount);
                }
            },
            error: function(error) {
                console.log(error);
            }
        });
    }

    // 기존 클릭 이벤트는 유지하되 약간 수정
    $(document).on("click", "#notification_btn", function(e) {
        e.preventDefault();
        $("#notification_div").toggleClass("active");
        
        // 알림 패널을 열 때 최신 데이터로 업데이트
        if ($("#notification_div").hasClass("active")) {
            loadNotifications();
        }
    });

    $(window).on('beforeunload', function() {
        if (eventSource) {
            eventSource.close();
        }
    });

    //-----------------------------------------

    // 해당 게시글로 이동
    $(document).on("click", ".move_board", function (e) {
        e.preventDefault();

        console.log("게시글 가는 버튼 클릭 됨");
        var board_no = $(this).data("board_no");
        var notifications_id = $(this).data("notifications_id");
        var h_data = {boardNo: board_no}

        console.log(board_no);
        console.log(notifications_id);
        console.log("is_read_true ajax 시작");
        // 알림 읽음 처리
        $.ajax({
             type: "post"
            ,url: "/is_read_true"
            ,data: {notifications_id:notifications_id}
            ,success: function (params) {
                console.log("해당 알림 읽음 처리됨.");
                window.location.href = "content_view?pageNum=1&amount=10&type=&keyword=&boardNo="+board_no+"&mf_no="+sessionUserNo;
            }
            ,error: function (error) {
                console.log(error);
            }
        });
    });
	</script>
</body>
</html>