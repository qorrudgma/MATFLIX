<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.boot.dto.TeamDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <!-- 헤더 -->
    <div class="header">
        <h2>MATFLIX 관리자</h2>
        <div style="margin-left:auto;">환영합니다, <%= user != null ? user.getMf_nickname() : "관리자" %>님</div>
    </div>

    <!-- 대시보드 -->
    <div class="dashboard">
        <!-- 좌측 메뉴 -->
        <div class="sidebar">
            <button class="menu_btn active" data-target="user_list">로그인한 유저</button>
            <button class="menu_btn" data-target="recipe_list">레시피</button>
            <button class="menu_btn" data-target="board_list">게시글</button>
            <button class="menu_btn" data-target="statistics">통계</button>
        </div>

        <!-- 우측 컨텐츠 -->
		<div class="content" id="content_area">
			<section class="content_section active" id="user_area">
			    <h3>유저 목록</h3>
				<div class="search-container">
				        <form action="/admin/dashboard" method="get">
				            <select name="type">
				                <option value="mf_id" ${param.type == 'mf_id' ? 'selected' : ''}>아이디</option>
				                <option value="mf_name" ${param.type == 'mf_name' ? 'selected' : ''}>이름</option>
				                <option value="mf_nickname" ${param.type == 'mf_nickname' ? 'selected' : ''}>닉네임</option>
				            </select>
				            <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력하세요">
				            <button type="submit" class="btn-search">검색</button>
				            <c:if test="${not empty param.keyword}">
				                <a href="/admin/dashboard" class="btn-reset">초기화</a>
				            </c:if>
				        </form>
				    </div>
			    <table class="admin_table">
			        <thead>
			            <tr>
			                <th>번호</th>
			                <th>접속</th>
			                <th>아이디</th>
			                <th>이름</th>
			                <th>닉네임</th>
			                <th>가입일</th>
			                <th>마지막 로그인</th>
			                <th>상태</th>
			                <th>관리</th>
			            </tr>
			        </thead>
			        <tbody>
			            <c:forEach var="user" items="${user_list}">
			                <tr>
			                    <td>${user.mf_no}</td>
								<td class="status-container">
								    <c:if test="${user.online}">
								        <span class="status-dot" style="color:#2ecc71;">●</span>
								        <span class="online-text">온라인</span>
								    </c:if>
								    <c:if test="${!user.online}">
								        <span class="status-dot" style="color:#e74c3c;">●</span>
								        <span class="offline-text">오프라인</span>
								    </c:if>
								</td>
			                    <td>${user.mf_id}</td>
			                    <td>${user.mf_name}</td>
			                    <td>${user.mf_nickname}</td>
			                    <td>${user.display_time_created}</td>
			                    <td>${user.display_time_last_login}</td>
			                    <td>${user.status}</td>
								<td>
									<c:choose>
								        <c:when test="${user.status == 'ACTIVE'}">
								            <button class="btn-ban" onclick="banUser(${user.mf_no}, '${user.mf_id}', '${user.mf_nickname}')">
								                차단하기
								            </button>
								        </c:when>
								        <c:otherwise>
								            <button class="btn-recover" onclick="recoverUser(${user.mf_no}, '${user.mf_id}', '${user.mf_nickname}')">
								                차단해제하기
								            </button>
								        </c:otherwise>
								    </c:choose>
								</td>
			                </tr>
			            </c:forEach>
			        </tbody>
			    </table>
	
			    <!-- 페이지 버튼 -->
				<div class="pagination">
				    <c:if test="${has_prev}">
				        <a href="/admin/dashboard?page=${start_page - 1}">« 이전</a>
				    </c:if>
				    <c:forEach begin="${start_page}" end="${end_page}" var="p">
				        <a href="/admin/dashboard?page=${p}"
				           class="${p == page ? 'active_page' : ''}">
				            ${p}
				        </a>
				    </c:forEach>
				    <c:if test="${has_next}">
				        <a href="/admin/dashboard?page=${end_page + 1}">다음 »</a>
				    </c:if>
				</div>
			</div>
		</section>
		
		<section class="content_section" id="recipe_area" style="display:none;">
	        <h3>최근 등록된 레시피</h3>
	        <ul id="recipe_list_data"></ul>
	    </section>

	    <section class="content_section" id="board_area" style="display:none;">
	        <h3>최근 게시글</h3>
	        <ul id="board_list_data"></ul>
	    </section>
		
    </div>

    <script>
        $(document).ready(function(){
            $(".menu_btn").click(function(){
                // 버튼 active 상태
                $(".menu_btn").removeClass("active");
                $(this).addClass("active");
				$(".content_section").hide();
				let target = $(this).data("target");
				
                switch(target){
                    case "user_list":
						$("#user_area").show();
                        break;
                    case "recipe_list":
						$("#recipe_list_data").html("<li>김치찌개</li><li>된장찌개</li>");
		                $("#recipe_area").show();
                        break;
                    case "board_list":
						$("#board_list_data").html("<li>레시피 후기</li><li>질문 게시판</li>");
						$("#board_area").show();
                        break;
                    case "statistics":
					
                        break;
                }
            });
        });
		
		// 유저 차단 함수
	    function banUser(mf_no, mf_id, mf_nickname) {
	        const msg = `아이디 '`+mf_id+`'인 '`+mf_nickname+`' 유저를 즉시 차단하시겠습니까?`;
	        
	        if (!confirm(msg)) return;

	        $.ajax({
	            url: "/admin/user/update",
	            type: "POST",
	            data: { mf_no: mf_no, status: 'BANNED' },
	            success: function(res) {
	                if (res === "ok") {
	                    alert("'"+mf_nickname+"' 유저가 차단되었습니다.");
	                    location.reload();
	                } else {
	                    alert("차단 처리 실패");
	                }
	            }
	        });
	    }

	    // 유저 복구 함수
	    function recoverUser(mfNo, mf_id, mf_nickname) {
	        const msg = `아이디 '`+mf_id+`'인 '`+mf_nickname+`' 유저를 복구하시겠습니까?`;
	        
	        if (!confirm(msg)) return;

	        $.ajax({
	            url: "/admin/user/update",
	            type: "POST",
	            data: { mf_no: mfNo, status: 'ACTIVE' },
	            success: function(res) {
	                if (res === "ok") {
	                    alert("'"+mf_nickname+"' 유저가 다시 활성화되었습니다.");
	                    location.reload();
	                } else {
	                    alert("복구 처리 실패");
	                }
	            }
	        });
	    }
    </script>
</body>
</html>