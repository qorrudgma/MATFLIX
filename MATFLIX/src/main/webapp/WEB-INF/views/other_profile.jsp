<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
    <title>사용자 프로필</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 프로필 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/other_profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <jsp:include page="header.jsp"/>
    
    <div class="content">
        <!-- 프로필 섹션 -->
        <section class="profile_section">
            <div class="profile_header">
                <div class="profile_info_container">
                    <div class="profile_image_large" id="profile_image_preview">
						<c:choose>
						    <c:when test="${not empty profile.profile_image_path}">
								<img src="${pageContext.request.contextPath}${profile.profile_image_path}">
							</c:when>
							<c:otherwise>
								<i class="fas fa-user"></i>
							</c:otherwise>
						</c:choose>
                    </div>
                    
                    <h1 class="profile_name">${profile.mf_nickname}</h1>
                    
                    <div class="user_bio">안녕하세요! 맛있는 요리를 사랑하는 요리 초보입니다.</div>
                    
                    <div class="profile_stats">
                        <div class="stat_item">
                            <span class="stat_number">${profile.follower_count}</span>
                            <span class="stat_label">팔로워</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${profile.following_count}</span>
                            <span class="stat_label">팔로잉</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${profile.recipe_count}</span>
                            <span class="stat_label">레시피</span>
                        </div>
                    </div>
					<c:if test="${not empty user and profile.mf_no != user.mf_no}">
						<c:choose>
							<c:when test="${follow}">
								<button type="button" id="follow_btn" class="follow-btn delete_follow">
			                        <i class="fas fa-user-minus"></i> 팔로우 취소
			                    </button>
							</c:when>
							<c:otherwise>
								<button type="button" id="follow_btn" class="follow-btn add_follow">
			                        <i class="fas fa-user-plus"></i> 팔로우
			                    </button>
							</c:otherwise>
						</c:choose>
					</c:if>
<!--                    <button class="follow-button" id="followBtn">팔로우</button>-->
                </div>
            </div>
            
            <div class="profile_content">
                <!-- 탭 메뉴 -->
                <div class="profile_tabs">
                    <div class="profile_tab active" data-tab="recipes">
                        <i class="fas fa-utensils"></i> 레시피
                    </div>
                    <div class="profile_tab" data-tab="posts">
                        <i class="fas fa-clipboard"></i> 게시글
                    </div>
                </div>
                
                <!-- 레시피 탭 -->
                <div class="tab_content active" id="recipes_content">
					<!-- 내 레시피 목록 -->
		            <div class="recipe_grid">
						<c:forEach var="r" items="${my_recipe}">
							<a class="recipe-card" href="recipe_content_view?recipe_id=${r.recipe_id}">
								<div class="recipe-image">
									<img src="${pageContext.request.contextPath}${r.image_path}" alt="${r.title}">
									<div class="recipe-category">한식</div>
								</div>
								<div class="recipe-info">
									<h3>${r.title}<span class="review_count"> [${r.review_count}]</span></h3>
									<span class="recipe_star">
									    <span class="star_fill">
											<c:choose>
											    <c:when test="${r.star == 0}">
													<span class ='no_star'>리뷰 없음</span>
											    </c:when>
											    <c:otherwise>
											        <c:forEach begin="1" end="${r.star}">★</c:forEach><c:forEach begin="${r.star + 1}" end="5">☆</c:forEach>
											    </c:otherwise>
											</c:choose>
									    </span>
									</span>
									<p><strong>${r.mf_nickname}</strong></p>
									<span class="recipe_time">${r.display_time}</span>
								</div>
							</a>
						</c:forEach>
		                
		                <c:if test="${empty my_recipe}">
		                    <div class="empty-state">
		                        <i class="fas fa-utensils"></i>
		                        <p>아직 등록한 레시피가 없습니다.</p>
		                        <a href="insert_recipe" class="add_recipe_btn">
		                            <i class="fas fa-plus"></i> 레시피 등록하기
		                        </a>
		                    </div>
		                </c:if>
		            </div>
                </div>
                
                <!-- 게시글 탭 -->
                <div class="tab_content" id="posts_content">
					<div class="board_list">
		            </div>
                </div>
            </div>
        </section>
    </div>
    
    <jsp:include page="footer.jsp"/>
    
    <script>
		var sessionUserNo = "${not empty user ? user.mf_no : '' }";
		var other_mf_no = "${profile.mf_no}";
		
        // 탭 전환 기능
        $(document).ready(function() {
			const mf_no = "${param.mf_no}";
            $('.profile_tab').click(function() {
                const tabId = $(this).data('tab');
                
                // 탭 활성화
                $('.profile_tab').removeClass('active');
                $(this).addClass('active');
                
                // 콘텐츠 전환
                $('.tab_content').removeClass('active');
                $('#' + tabId + '_content').addClass('active');
				
				if(tabId === "posts"){
	   				console.log("내 게시글 탭");
	   				$.ajax({
	   	               type: "post",
					   data: {mf_no : mf_no},
	   	               url: "/other_board_list",
	   	               success: function(other_board_list) {
	   						console.log(other_board_list);
	   					 	let html = "";
	   						if (other_board_list && other_board_list.length > 0) {
	   							other_board_list.forEach(function(board) {
	   								html += `<a href="content_view?pageNum=1&amount=10&type=&keyword=&boardNo=`+board.boardNo+`" class="board_card">
						                        <div class="board_title">
						                            <i class="fas fa-file-alt"></i> `+board.boardTitle+` <span id="profile_comment_count">[`+board.comment_count+`]</span>
						                        </div>
						                        <div class="board_stats">
						                            <div class="board_stat">
						                                <i class="fas fa-thumbs-up"></i>
						                                <span>추천수: `+board.recommend_count+`</span>
						                            </div>
						                            <div class="board_stat">
						                                <i class="fas fa-eye"></i>
						                                <span>조회수: `+board.boardHit+`</span>
						                            </div>
						                            <div class="board_stat">
						                                <i class="fas fa-calendar-alt"></i>
						                                <span>작성일: `+board.boardDate+`</span>
						                            </div>
						                        </div>
						                    </a>`;
	   							});
	   						}else {
		                       html += "<p class='empty'>게시글이 없습니다.</p>";
		                    }
		                    $(".board_list").html(html);
   						}
		            });
				}
        	});
			// 팔로우 추가 버튼
			$(document).on("click", ".add_follow", function (e) {
			    e.preventDefault();
				console.log("팔로우 추가 버튼 누름");

			    if (sessionUserNo == '') {
			        alert("로그인 후 이용 가능합니다.");
			        return;
			    }

			    $.ajax({
			         type: "POST"
			        ,data: {following_id: other_mf_no, follower_id:sessionUserNo, follower_email:""}
			        ,url: "/add_follow"
			        ,success: function (result) {
			            console.log("팔로우 성공");
			            $("#follow_btn").removeClass("add_follow")
			                .html('<i class="fas fa-user-minus"></i> 팔로우 취소')
			                .addClass("delete_follow");
			        }
			        ,error: function () {
			            console.log("팔로우 실패");
			        }
			    });
			});

			// 팔로우 삭제 버튼
			$(document).on("click", ".delete_follow", function (e) {
			    e.preventDefault();
				console.log("팔로우 취소 버튼 누름");

			    if (sessionUserNo == '') {
			        alert("로그인 후 이용 가능합니다.");
			        return;
			    }

			    $.ajax({
			         type: "POST"
			        ,data: {following_id: other_mf_no, follower_id:sessionUserNo}
			        ,url: "/delete_follow"
			        ,success: function (result) {
			            console.log("팔로우 삭제 성공");
			            $("#follow_btn").removeClass("delete_follow")
			                .html('<i class="fas fa-user-plus"></i> 팔로우')
			                .addClass("add_follow");
			        }
			        ,error: function () {
			            console.log("팔로우 실패");
			        }
			    });
			});
    });
    </script>
</body>
</html>
