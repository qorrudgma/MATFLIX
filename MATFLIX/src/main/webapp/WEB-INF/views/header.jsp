<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
							loadInitialNotifications();
						});
					</script>
					<!-- 알림 버튼 -->
					<div class="notification_container">
						<button type="button" id="notification_btn" data-count="<%= session.getAttribute("notification_count") != null ? session.getAttribute("notification_count") : "0" %>">
							<i class="far fa-bell"></i>
							<span class="notify_badge"></span>
						</button>
					</div>
					
					<!-- 프로필 정보 -->
					<div class="user_container">
						<div class="profile_image profile user-avatar">
<!--							<img onclick="location.href='${pageContext.request.contextPath}/profile'" alt="MATFLIX" src="${pageContext.request.contextPath}/image/MATFLIX.png">-->
							<%
							    String profileImagePath = user.getProfile_image_path();
							    if (profileImagePath != null && !profileImagePath.isEmpty()) {
							%>
							    <img onclick="location.href='<%= request.getContextPath() %>/profile'"
							         src="<%= request.getContextPath() + profileImagePath %>">
							<%
							    } else {
							%>
							    <i onclick="location.href='<%= request.getContextPath() %>/profile'"
							       class="fas fa-user"></i>
							<%
							    }
							%>
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
		<div id="notification_div"></div>

		<!-- 네비게이션 메뉴 (같은 헤더 안에 포함) -->
		<nav id="header_nav">
			<div class="nav_header_logo nav_action" onclick="location.href='${pageContext.request.contextPath}/main'"><h3>MATFLIX</h3></div>
<!--			<div><a href="recipe_board?rc_type=&rc_keyword=&rc_pageNum=1&rc_amount=12"><div>레시피</div></a></div>-->
			<div><a href="${pageContext.request.contextPath}/recipe_list"><div>레시피</div></a></div>
			<div><a href="${pageContext.request.contextPath}/user_rank"><div> 랭킹 </div></a></div>
			<div><a href="${pageContext.request.contextPath}/list"><div>게시판</div></a></div>
			<div><a href="${pageContext.request.contextPath}/notice_list"><div> 공지사항 </div></a></div>
			<% if(user != null){ %>
				<div><a href="${pageContext.request.contextPath}/follow_board_list"><div> 친구들 소식 </div></a></div>
			<% } %>
			<div> 더보기 </div>
			<div class="nav_header_actions nav_action">
				<% if(user != null){ %>
					<div class="user_container">
							<div class="nav_notification_container">
								<button type="button" id="nav_notification_btn" data-count="<%= session.getAttribute("notification_count") != null ? session.getAttribute("notification_count") : "0" %>">
									<i class="far fa-bell"></i>
									<span class="notify_badge"></span>
								</button>
							</div>
						<div class="user_info">
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
						<button class="btn_login" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button>
						<button class="btn_register" onclick="location.href='${pageContext.request.contextPath}/recruit'">회원가입</button>
					</div>
				<% } %>
			</div>
		</nav>
	</header>	

	<script>
		<% if (user != null) { %>
			var sessionUserNo = <%= user.getMf_no() %>;
			var sessionUserNickname = "<%= user.getMf_nickname() %>";
			//var notification_count = <%= session.getAttribute("notification_count") != null ? session.getAttribute("notification_count") : "0" %>;
			
			// 알림 카운트가 있으면 알림 배지 표시
			//if (notification_count > 0) {
			//	document.getElementById("notification_btn").style.setProperty('--notification-visibility', 'visible');
			//}
			
			console.log(sessionUserNickname);
			console.log(sessionUserNo);
		<% } else { %>
			var sessionUserNo = null;
		<% } %>

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
			$("#notification_btn").addClass("active");
			$("#nav_notification_btn").addClass("active");
		    console.log("알림 이벤트:", event.data);
		});
		
		eventSource.onerror = function(err){
			console.log("SSE 오류: ", err);
		}
	}
	
    // 초기 알림 로드
    function loadInitialNotifications() {
        //var followerId = parseInt(sessionUserNo, 10);
        
        $.ajax({
            type: "POST",
            url: "/notification_list_n",
            data: {receiver_id: sessionUserNo},
            dataType: "json",
            success: function(notification_list_n) {
				console.log(notification_list_n);
                // 읽지 않은 알림 개수 저장 및 표시
                notificationCount = notification_list_n.filter(item => item.is_read === 0).length;
				if(notificationCount>0){
					$("#notification_btn").addClass("active");
					$("#nav_notification_btn").addClass("active");
				}
                //updateNotificationBadge(notificationCount);
            },
            error: function(error) {
                console.log(error);
            }
        });
    }
	
	// 시간이 얼마나 지났는지
	function timeAgo(time){
		const now = new Date();
		const past = new Date(time);
		const diffSec = Math.floor((now - past) / 1000);
		//console.log("now => " + now);
		//console.log("past => " + past);
		//console.log("diffSec => " + diffSec);
		
		if (diffSec < 60) return "방금 전";
	    if (diffSec < 3600) return Math.floor(diffSec / 60) + "분 전";
	    if (diffSec < 86400) return Math.floor(diffSec / 3600) + "시간 전";
	    if (diffSec < 172800) return "어제";
		
	    return Math.floor(diffSec / 86400) + "일 전";
	}

    // 알림 목록 로드
    function loadNotifications() {
        //var followerId = parseInt(sessionUserNo, 10);
        
        $.ajax({
            type: "POST",
            url: "/notification_list_n",
            data: {receiver_id: sessionUserNo},
            dataType: "json",
            success: function(notification_list_n) {
                let notification_data = "";
                
                if (notification_list_n.length > 0) {
                    notification_data += `<div class='notification_header'><h3>알림 ` + notification_list_n.length + `개</h3>
												<button type='button' class='close-btn' aria-label='닫기'><i class='fa-solid fa-xmark'></i></button>
											</div>`;
                } else {
                    notification_data += `<div class='notification_header n_notif'><h3>새로운 알림이 없습니다</h3>
												<button type='button' class='close-btn' aria-label='닫기'><i class='fa-solid fa-xmark'></i></button>
											</div>`;
                }
				
                for (let i = 0; i < notification_list_n.length && i < 10; i++) {
                    // 기존 코드와 동일
                    if (notification_list_n[i].is_read == 1) {
                        notification_data += "<div id='notification_card' class='read_true'>";
                    } else {
                        notification_data += "<div id='notification_card'>";
                    }
					timeAgo(notification_list_n[i].created_at);
					console.log("시간: ", timeAgo(notification_list_n[i].created_at));

					notification_data += "<div>" + timeAgo(notification_list_n[i].created_at) + "</div>";
					if (notification_list_n[i].is_read == 0) {
						switch (notification_list_n[i].notif_type) {
							case "FOLLOW":
								notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 팔로우를 하였습니다.</div>";
								break;
	
							case "CREATE":
								if ("REVIEW" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 리뷰를 남겼습니다.</div>";
								}
								break;
	
							case "COMMENT":
								if ("BOARD" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 게시글에 댓글을 달았습니다.</div>";
								} else if ("RECIPE" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 레시피에 댓글을 달았습니다.</div>";
								} else if ("COMMENT" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 댓글에 답글을 달았습니다.</div>";
								}
								break;
	
							case "LIKE":
								if ("BOARD" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 게시글에 좋아요를 달았습니다.</div>";
								} else if ("RECIPE" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 레시피에 좋아요를 달았습니다.</div>";
								} else if ("COMMENT" === notification_list_n[i].target_type) {
									notification_data += "<div>'" + notification_list_n[i].mf_nickname + "'님이 댓글에 좋아요를 달았습니다.</div>";
								}
								break;
							}
						}
					notification_data += '<button type="button" class="move_board" data-board_no="' + notification_list_n[i].target_id + '" data-notifications_id="'+notification_list_n[i].notif_id+'">보러가기</button></div>';
                }
                
                document.getElementById("notification_div").innerHTML = notification_data;
            },
            error: function(error) {
                console.log(error);
            }
        });
    }

    // 기존 클릭 이벤트는 유지하되 약간 수정
    $(document).on("click", "#notification_btn, #nav_notification_btn", function(e) {
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
	
	// 스크롤 위치에 따른 변화
	let scroll = false;
	$(window).on("scroll", function () {
	    const scrollTop = $(this).scrollTop();

	    if (!scroll && scrollTop > 100) {
	        $(".header_container").addClass("nav_action");
	        $(".nav_header_logo").removeClass("nav_action");
	        $(".nav_header_actions").removeClass("nav_action");
			scroll = true;
	    } else if(scroll && scrollTop < 80) {
	        $(".header_container").removeClass("nav_action");
	        $(".nav_header_logo").addClass("nav_action");
	        $(".nav_header_actions").addClass("nav_action");
			scroll = false;
	    }
	});
	
	$(document).on("click", ".close-btn", function (e) {
		$("#notification_div").removeClass("active");
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