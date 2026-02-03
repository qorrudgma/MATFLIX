<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>MATFLIX - 레시피</title>

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_list.css">
	<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
	<jsp:include page="header.jsp" />

	<div class="content main-container">
		<h2 class="rc_title">레시피</h2>
		<p>카테고리별 레시피를 한 번에 둘러보세요!</p>

		<!-- KOREAN -->
		<section class="category-section" id="cat-korean">
			<div class="category-header">
				<h3 class="category-title"><i class="fas fa-bowl-food"></i> 한식 <span class="en-title">(Korean Food)</span></h3>
			</div>

			<div class="recipe-grid">
				<c:set var="hasKorean" value="false" />
				<c:forEach var="r" items="${recipe_list}">
					<c:if test="${r.category eq 'KOREAN'}">
						<c:set var="hasKorean" value="true" />
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
					</c:if>
				</c:forEach>

				<c:if test="${not hasKorean}">
					<div class="empty-box">한식 레시피가 아직 없어요.</div>
				</c:if>
			</div>
		</section>

		<!-- CHINESE -->
		<section class="category-section" id="cat-chinese">
			<div class="category-header">
				<h3 class="category-title"><i class="fas fa-pepper-hot"></i> 중식 <span class="en-title">(Chinese Food)</span></h3>
			</div>

			<div class="recipe-grid">
				<c:set var="hasChinese" value="false" />
				<c:forEach var="r" items="${recipe_list}">
					<c:if test="${r.category eq 'CHINESE'}">
						<c:set var="hasChinese" value="true" />
						<a class="recipe-card" href="recipe_content_view?recipe_id=${r.recipe_id}">
							<div class="recipe-image">
								<img src="${pageContext.request.contextPath}${r.image_path}" alt="${r.title}">
								<div class="recipe-category">중식</div>
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
					</c:if>
				</c:forEach>

				<c:if test="${not hasChinese}">
					<div class="empty-box">중식 레시피가 아직 없어요.</div>
				</c:if>
			</div>
		</section>

		<!-- JAPANESE -->
		<section class="category-section" id="cat-japanese">
			<div class="category-header">
				<h3 class="category-title"><i class="fas fa-fish"></i> 일식 <span class="en-title">(Japanese Food)</span></h3>
			</div>

			<div class="recipe-grid">
				<c:set var="hasJapanese" value="false" />
				<c:forEach var="r" items="${recipe_list}">
					<c:if test="${r.category eq 'JAPANESE'}">
						<c:set var="hasJapanese" value="true" />
						<a class="recipe-card" href="recipe_content_view?recipe_id=${r.recipe_id}">
							<div class="recipe-image">
								<img src="${pageContext.request.contextPath}${r.image_path}" alt="${r.title}">
								<div class="recipe-category">일식</div>
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
					</c:if>
				</c:forEach>

				<c:if test="${not hasJapanese}">
					<div class="empty-box">일식 레시피가 아직 없어요.</div>
				</c:if>
			</div>
		</section>

		<!-- WESTERN -->
		<section class="category-section" id="cat-western">
			<div class="category-header">
				<h3 class="category-title"><i class="fas fa-cheese"></i> 양식 <span class="en-title">(Western food)</span></h3>
			</div>

			<div class="recipe-grid">
				<c:set var="hasWestern" value="false" />
				<c:forEach var="r" items="${recipe_list}">
					<c:if test="${r.category eq 'WESTERN'}">
						<c:set var="hasWestern" value="true" />
						<a class="recipe-card" href="recipe_content_view?recipe_id=${r.recipe_id}">
							<div class="recipe-image">
								<img src="${pageContext.request.contextPath}${r.image_path}" alt="${r.title}">
								<div class="recipe-category">양식</div>
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
					</c:if>
				</c:forEach>

				<c:if test="${not hasWestern}">
					<div class="empty-box">양식 레시피가 아직 없어요.</div>
				</c:if>
			</div>
		</section>

		<!-- DESSERT -->
		<section class="category-section" id="cat-dessert">
			<div class="category-header">
				<h3 class="category-title"><i class="fas fa-ice-cream"></i> 디저트 <span class="en-title">DESSERT</span></h3>
			</div>

			<div class="recipe-grid">
				<c:set var="hasDessert" value="false" />
				<c:forEach var="r" items="${recipe_list}">
					<c:if test="${r.category eq 'DESSERT'}">
						<c:set var="hasDessert" value="true" />
						<a class="recipe-card" href="recipe_content_view?recipe_id=${r.recipe_id}">
							<div class="recipe-image">
								<img src="${pageContext.request.contextPath}${r.image_path}" alt="${r.title}">
								<div class="recipe-category">디저트</div>
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
					</c:if>
				</c:forEach>

				<c:if test="${not hasDessert}">
					<div class="empty-box">디저트 레시피가 아직 없어요.</div>
				</c:if>
			</div>
		</section>
	</div>
	
	<!-- 레시피 등록 버튼 -->
    <button class="add_recipe_btn" onclick="location.href='recipe_write_new'">
        <i class="fas fa-plus"></i>
    </button>

	<jsp:include page="footer.jsp" />
</body>
</html>
