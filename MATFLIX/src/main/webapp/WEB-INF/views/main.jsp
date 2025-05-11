<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Recipe Main</title>
    <meta charset="UTF-8" />
    <style>
        .category-section {
            margin-bottom: 30px;
        }
        .category-title {
            font-size: 24px;
            font-weight: bold;
            margin: 20px 0;
        }
        .image-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .image-grid img {
            width: 200px;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="header.jsp" />
	
    <!-- 알림 -->
	<jsp:include page="notification.jsp" />

	<!-- 게시글 -->
	<a href="list">게시글</a>

	<!-- 프로필 -->
	<form id="user_profile" class="profile" action="profile" method="post">
		<div class="form_profile">
	    	<input type="submit" class="mypage_btn" value="mypage">
		</div>
	</form>
<!--<a href="profile"><div>마이페이지로 이동</div></a>-->
<a href="recipe_board"><div>요리게시판으로 이동</div></a>
<div class="category-section">
    <div class="category-title">한식 (Korean Food)</div>
    <div class="image-grid">
        <c:forEach var="img" items="${korean_food_list}">
            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}"><img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Korean food image" /></a>
        </c:forEach>
    </div>
</div>

<div class="category-section">
    <div class="category-title">양식 (American Food)</div>
    <div class="image-grid">
        <c:forEach var="img" items="${american_food_list}">
            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}"><img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="American food image" /></a>
        </c:forEach>
    </div>
</div>

<div class="category-section">
    <div class="category-title">일식 (Japanese Food)</div>
    <div class="image-grid">
        <c:forEach var="img" items="${japanese_food_list}">
            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}"><img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Japanese food image" /></a>
        </c:forEach>
    </div>
</div>

<div class="category-section">
    <div class="category-title">중식 (Chinese Food)</div>
    <div class="image-grid">
        <c:forEach var="img" items="${chinese_food_list}">
            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}"><img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Chinese food image" /></a>
        </c:forEach>
    </div>
</div>

<div class="category-section">
    <div class="category-title">디저트 (Dessert)</div>
    <div class="image-grid">
        <c:forEach var="img" items="${dessert_list}">
            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}"><img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Dessert image" /></a>
        </c:forEach>
    </div>
</div>

</body>
</html>