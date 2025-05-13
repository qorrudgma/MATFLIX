<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<style>
        .recipe_grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .recipe_card {
            width: 270px;
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            font-family: sans-serif;
        }
        .recipe_card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .recipe_card p {
            padding: 10px;
            margin: 0;
            font-size: 14px;
        }
        .div_page ul {
            display: flex;
            list-style: none;
        }
    </style>
<div>
    <a href="${pageContext.request.contextPath}/main">
      <button type="button">메인페이지</button> 
    </a>
    <!-- 프로필 섹션 -->
    <section class="profile_section">
        <div class="profile_header">
            
            <div class="profile_info_container">
                <div class="profile_info">
                </div>
                <div class="user_bio">안녕하세요! 맛있는 요리를 사랑하는 요리 초보입니다.</div>
                <div class="profile_stats">
                    <div class="stat_item">
                        <span class="stat_number">${follower_count}</span>
                        <span class="stat_label">팔로워</span>
                    </div>
                    <div class="stat_item">
                        <span class="stat_number">${follow_count}</span>
                        <span class="stat_label">팔로잉</span>
                    </div>
                    <div class="stat_item">
                        <span class="stat_number"></span>
                        <span class="stat_label">레시피</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 레시피 -->
        <h2>레시피</h2>
        <div class="recipe_grid">
            <c:forEach var="recipe" items="${recipe_list}">
                <c:set var="recipe_id" value="${recipe.rc_recipe_id}" />
                <a href="recipe_content_view?rc_recipe_id=${recipe.rc_recipe_id}">
                    <div class="recipe_card">
                        <c:set var="found_image" value="false" />
                        <c:forEach var="attach" items="${upload_list}">
                            <c:if test="${!found_image && attach.rc_recipe_id == recipe_id && attach.image}">
                                <img src="/upload/${attach.uploadPath}/${attach.uuid}_${attach.fileName}" alt="${recipe.rc_name}" />
                                <c:set var="found_image" value="true" />
                            </c:if>
                        </c:forEach>
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
                                (${recipe.star_score}점)
                            </div>
                        </c:if>
                    </div>
                </a>
            </c:forEach>
        </div>

        
        
        <!-- 게시글 리스트 -->
        <h2>게시글</h2>
        <div>
            <c:forEach var="board" items="${profile_board_list}">
                <a href="content_view?pageNum=1&amount=10&type=&keyword=&boardNo=${board.boardNo}">
                    <div>
                        제목: ${board.boardTitle}
                    </div>
                </a>
                <div>
                    추천수: ${board.recommend_count}
                </div>
                <div>
                    조회수: ${board.boardHit}
                </div>
                <div>
                    생성일: ${board.boardDate}
                </div>
            </c:forEach>
        </div>
    </section>
</div>