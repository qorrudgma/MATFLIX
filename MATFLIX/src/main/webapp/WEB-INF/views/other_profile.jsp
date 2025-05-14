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
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <jsp:include page="header.jsp"/>
    
    <div class="content">
        <a href="${pageContext.request.contextPath}/main" class="back-button">
            <i class="fas fa-arrow-left"></i> 메인페이지로 돌아가기
        </a>
        
        <!-- 프로필 섹션 -->
        <section class="profile_section">
            <div class="profile_header">
                <div class="profile_info_container">
                    <div class="profile_avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    
                    <h1 class="profile_name">
                        <c:forEach var="profile" items="${user_rank_list}" varStatus="rank">
                            <c:if test="${profile.mf_no == param.mf_no}">
                                ${profile.mf_nickname}님
                            </c:if>
                        </c:forEach>
                    </h1>
                    
                    <div class="user_bio">안녕하세요! 맛있는 요리를 사랑하는 요리 초보입니다.</div>
                    
                    <div class="profile_stats">
                        <div class="stat_item">
                            <span class="stat_number">${follow_count}</span>
                            <span class="stat_label">팔로워</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${follower_count}</span>
                            <span class="stat_label">팔로잉</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${recipe_list.size()}</span>
                            <span class="stat_label">레시피</span>
                        </div>
                    </div>
                    
                    <button class="follow-button" id="followBtn">팔로우</button>
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
                    <h2 class="section_title">
                        <i class="fas fa-utensils"></i> 레시피
                    </h2>
                    
                    <div class="recipe_grid">
                        <c:forEach var="recipe" items="${recipe_list}">
                            <c:set var="recipe_id" value="${recipe.rc_recipe_id}" />
                            <a href="recipe_content_view?rc_recipe_id=${recipe.rc_recipe_id}" class="recipe_card">
                                <c:set var="found_image" value="false" />
                                <c:forEach var="attach" items="${upload_list}">
                                    <c:if test="${!found_image && attach.rc_recipe_id == recipe_id && attach.image}">
                                        <img src="/upload/${attach.uploadPath}/${attach.uuid}_${attach.fileName}" alt="${recipe.rc_name}" />
                                        <c:set var="found_image" value="true" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!found_image}">
                                    <img src="${pageContext.request.contextPath}/images/default-recipe.jpg" alt="${recipe.rc_name}" />
                                </c:if>
                                
                                <div class="recipe_info">
                                    <div class="recipe_title">${recipe.rc_name}</div>
                                    
                                    <!-- 평균 별점 표시 -->
                                    <c:if test="${not empty recipe.star_score}">
                                        <div class="star-display">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= recipe.star_score}">
                                                        &#9733; <!-- filled star -->
                                                    </c:when>
                                                    <c:when test="${i - 1 < recipe.star_score && recipe.star_score < i}">
                                                        &#9733; <!-- half star로 대체할 수도 있음 -->
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="empty">&#9733;</span> <!-- empty star -->
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <span style="color: var(--light-text);">(${recipe.star_score}점)</span>
                                        </div>
                                    </c:if>
                                </div>
                            </a>
                        </c:forEach>
                        
                        <c:if test="${empty recipe_list}">
                            <div class="empty-state">
                                <i class="fas fa-utensils"></i>
                                <p>아직 등록된 레시피가 없습니다.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- 게시글 탭 -->
                <div class="tab_content" id="posts_content">
                    <h2 class="section_title">
                        <i class="fas fa-clipboard"></i> 게시글
                    </h2>
                    
                    <div class="board_list">
                        <c:forEach var="board" items="${profile_board_list}">
                            <a href="content_view?pageNum=1&amount=10&type=&keyword=&boardNo=${board.boardNo}" class="board_card">
                                <div class="board_title">${board.boardTitle}</div>
                                <div class="board_stats">
                                    <div class="board_stat">
                                        <i class="fas fa-thumbs-up"></i>
                                        <span>추천수: ${board.recommend_count}</span>
                                    </div>
                                    <div class="board_stat">
                                        <i class="fas fa-eye"></i>
                                        <span>조회수: ${board.boardHit}</span>
                                    </div>
                                    <div class="board_stat">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span>작성일: ${board.boardDate}</span>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                        
                        <c:if test="${empty profile_board_list}">
                            <div class="empty-state">
                                <i class="fas fa-clipboard"></i>
                                <p>아직 작성한 게시글이 없습니다.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <jsp:include page="footer.jsp"/>
    
    <script>
        // 탭 전환 기능
        $(document).ready(function() {
            $('.profile_tab').click(function() {
                const tabId = $(this).data('tab');
                
                // 탭 활성화
                $('.profile_tab').removeClass('active');
                $(this).addClass('active');
                
                // 콘텐츠 전환
                $('.tab_content').removeClass('active');
                $('#' + tabId + '_content').addClass('active');
            });
            
            // 팔로우 버튼 토글
            $('#followBtn').click(function() {
                $(this).toggleClass('following');
                if ($(this).hasClass('following')) {
                    $(this).text('팔로우 취소');
                    // 여기에 팔로우 API 호출 추가
                } else {
                    $(this).text('팔로우');
                    // 여기에 언팔로우 API 호출 추가
                }
            });
            
            // 이미 팔로우 중인지 확인하는 로직 추가 필요
        });
    </script>
</body>
</html>
