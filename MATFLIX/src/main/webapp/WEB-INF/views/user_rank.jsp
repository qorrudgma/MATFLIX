<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>사용자 랭킹</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 사용자 랭킹 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_rank.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="header.jsp"/>
    
    <div class="content">
        <h1 class="page-title">사용자 랭킹</h1>
        <p class="page-description">MATFLIX에서 가장 활발한 사용자들을 만나보세요!</p>
        
        <div class="user-rank-list">
            <c:forEach var="user" items="${user_rank_list}" varStatus="rank">
				<a href="other_profile?mf_no=${user.mf_no}" class="user-nickname">
	                <div class="user-rank-card">
	                    <!-- 랭킹 배지 -->
	                    <div class="rank-badge ${rank.count <= 3 ? 'rank-' : 'rank-other'}${rank.count <= 3 ? rank.count : ''}">
	                        ${rank.count}위
	                    </div>
	                    
	                    <!-- 사용자 아바타 -->
	                    <div class="user-avatar">
	                        <i class="fas fa-user"></i>
	                    </div>
	                    
	                    <!-- 사용자 정보 -->
	                    <div class="user-info">
	                            ${user.mf_nickname}님
	                        <div class="user-details">
	                            <div class="user-detail-item">
	                                <i class="fas fa-envelope"></i>
	                                <span>${user.mf_email}</span>
	                            </div>
	                            
	                            <div class="user-detail-item">
	                                <i class="fas fa-venus-mars"></i>
	                                <span>${user.mf_gender}</span>
	                            </div>
	                            
	                            <div class="user-detail-item">
	                                <i class="fas fa-calendar-alt"></i>
	                                <span>가입일: ${user.mf_regdate}</span>
	                            </div>
	                        </div>
	                    </div>
	                </div>
				</a>
            </c:forEach>
        </div>
    </div>
    
    <jsp:include page="footer.jsp"/>
</body>
</html>
