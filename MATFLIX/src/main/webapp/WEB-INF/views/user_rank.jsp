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
        <!-- 장식 요소 추가 -->
        <div class="decoration-element one"></div>
        <div class="decoration-element two"></div>
        <div class="decoration-element three"></div>
        
        <h1 class="page-title">사용자 랭킹</h1>
        <p class="page-description">MATFLIX에서 가장 활발한 사용자들을 만나보세요!</p>
        
		<!-- ================= TOP 3 PODIUM ================= -->
		<c:if test="${user_rank_list.size() >= 3}">
		<div class="top3-podium">

		    <!-- 2위 -->
		    <c:set var="second" value="${user_rank_list[1]}" />
		    <div class="podium second" onclick="location.href='${pageContext.request.contextPath}/other_profile?mf_no=${second.mf_no}'">
				<input type="hidden" value="${second.mf_no}">
		        <span class="rank-label">2위</span>
		        <div class="avatar">
					<c:choose>
					    <c:when test="${not empty second.profile_image_path}">
							<img src="${pageContext.request.contextPath}${second.profile_image_path}">
						</c:when>
						<c:otherwise>
							<i class="fas fa-user"></i>
						</c:otherwise>
					</c:choose>
		        </div>
		        <div class="nickname">${second.mf_nickname}</div>
		        <div class="score">팔로워 ${second.follower_count}명&nbsp;&nbsp;&nbsp;평균 별점 ${second.avg_recipe_star == 0.0 ? '-' : second.avg_recipe_star}</div>
		    </div>

		    <!-- 1위 -->
		    <c:set var="first" value="${user_rank_list[0]}" />
		    <div class="podium first" onclick="location.href='${pageContext.request.contextPath}/other_profile?mf_no=${first.mf_no}'">
				<input type="hidden" value="${first.mf_no}">
		        <span class="rank-label">1위</span>
		        <div class="avatar big">
					<c:choose>
					    <c:when test="${not empty first.profile_image_path}">
							<img src="${pageContext.request.contextPath}${first.profile_image_path}">
						</c:when>
						<c:otherwise>
							<i class="fas fa-user"></i>
						</c:otherwise>
					</c:choose>
		        </div>
		        <div class="nickname">${first.mf_nickname}</div>
		        <div class="score">팔로워 ${first.follower_count}명&nbsp;&nbsp;&nbsp;평균 별점 ${first.avg_recipe_star == 0.0 ? '-' : first.avg_recipe_star}</div>
		    </div>

		    <!-- 3위 -->
		    <c:set var="third" value="${user_rank_list[2]}" />
		    <div class="podium third" onclick="location.href='${pageContext.request.contextPath}/other_profile?mf_no=${third.mf_no}'">
				<input type="hidden" value="${third.mf_no}">
		        <span class="rank-label">3위</span>
		        <div class="avatar">
					<c:choose>
					    <c:when test="${not empty third.profile_image_path}">
							<img src="${pageContext.request.contextPath}${third.profile_image_path}">
						</c:when>
						<c:otherwise>
							<i class="fas fa-user"></i>
						</c:otherwise>
					</c:choose>
		        </div>
		        <div class="nickname">${third.mf_nickname}</div>
		        <div class="score">팔로워 ${third.follower_count}명&nbsp;&nbsp;&nbsp;평균 별점 ${third.avg_recipe_star == 0.0 ? '-' : third.avg_recipe_star}</div>
		    </div>

		</div>
		</c:if>

	    <!-- ================= 4등부터 ================= -->
	    <div class="user-rank-list">
	        <c:forEach begin="3" var="user" items="${user_rank_list}" varStatus="status">
	            <div class="user-rank-card" onclick="location.href='${pageContext.request.contextPath}/other_profile?mf_no=${user.mf_no}'">
					<input type="hidden" value="${user.mf_no}">
	                <span class="rank-badge rank-other">
	                    ${status.index + 1}위
	                </span>
	                <div class="user-avatar">
	                    <i class="fas fa-user"></i>
	                </div>
	                <div class="user-info">
	                    <a class="user-nickname">${user.mf_nickname}</a>
	                    <div class="user-details">
							<div class="user-detail-item">
							    팔로워 ${user.follower_count}명
							</div>
							<div class="user-detail-item">
							    평균 별점 ${user.avg_recipe_star == 0.0 ? '-' : user.avg_recipe_star}
							</div>
	                    </div>
	                </div>
	            </div>
	        </c:forEach>
	    </div>
    </div>
    
    <jsp:include page="footer.jsp"/>
    
    <script>
        // 랭킹 카드 호버 효과
        $(".user-rank-card, .podium").hover(
            function() {
                $(this).css("transform", "translateY(-3px)");
                $(this).css("box-shadow", "0 5px 15px rgba(0, 0, 0, 0.15)");
            },
            function() {
                $(this).css("transform", "");
                $(this).css("box-shadow", "");
            }
        );
    </script>
</body>
</html>
