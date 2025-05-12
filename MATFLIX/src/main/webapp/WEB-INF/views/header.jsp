<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<header class="header">

		<div>
			<img src="${pageContext.request.contextPath}/resources/image/MATFLIX.png" width="60px" alt="MATFLIX로고">
		</div>

		<div class="header_logo">
			<h1>MATFLIX</h1>
		</div>

		<div class="social_links">
			<a href="https://www.instagram.com" target="_blank">
				<i class="fa-brands fa-instagram"></i>
			</a>
			<a href="https://www.youtube.com" target="_blank">
				<i class="fa-brands fa-youtube"></i>
			</a>
			<a href="https://section.blog.naver.com" target="_blank">
				<i class="fa-solid fa-blog"></i>
			</a>
			<a href="https://section.cafe.naver.com" target="_blank">
				<i class="fa-solid fa-mug-saucer"></i>
			</a>
		</div>

		<div class="header_search">
			<form action="search.jsp" method="get">
				<input type="text" name="query" placeholder="레시피 검색...">
				<button type="submit">검색</button>
			</form>
		</div>

		<% if(user != null){ %>
			<div class="header_actions">
				<div class="profile_image profile">
					<img onclick="my_page()" alt="MATFLIX" src="${pageContext.request.contextPath}">
				</div>
				<div>
					<div class="profile_info">
						<span><span id="profile_name"><%= user.getMf_nickname()%></span>님 환영합니다.</span>
					</div>
					<input type="button" value="로그아웃" id="log_out" onclick="location.href='${pageContext.request.contextPath}/log_out'">
				</div>
			</div>
		<% }else{ %>
			<div class="header_actions">
				<div class="user_actions">
					<!-- 로그인 버튼 클릭 시 login.jsp로 이동 -->
					<button class="btn_login" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button>
					<!-- 회원가입 버튼 클릭 시 recruit.jsp로 이동 -->
					<button class="btn_register" onclick="location.href='${pageContext.request.contextPath}/recruit'">회원가입</button>
				</div>
			</div>
		<% } %>
		<!-- 닫기 -->
		<button id="page_up">
			<i class="fas fa-chevron-up"></i>
		</button>
	</header>	

	<div id="header_nav">
		<div> 레시피 </div>
		<a href="${pageContext.request.contextPath}/user_rank"><div> 랭킹 </div></a>
		<div> 게시판 </div>
		<div> 공지사항 </div>
		<div> 더보기 </div>
	</div>
