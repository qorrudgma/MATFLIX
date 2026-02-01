<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<html>
<head>
    <title>Recipe Main</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_list.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="main-container">
        <!-- 배너 슬라이더 -->
        <div class="banner-slider-container">
            <div class="banner-slider" id="bannerSlider">
                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/images/banner1.png" alt="배너 이미지">
                    <div class="banner-content">
                        <h3>맛있는 요리의 세계로 오신 것을 환영합니다</h3>
                        <p>다양한 레시피를 발견하고 나만의 요리 여정을 시작하세요</p>
                    </div>
                </div>
                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/images/banner2.png" alt="배너 이미지">
                    <div class="banner-content">
                        <h3>시원한 여름 별미 레시피</h3>
                        <p>더운 여름을 이겨낼 수 있는 시원한 요리 모음</p>
                    </div>
                </div>
                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/images/banner3.png" alt="배너 이미지">
                    <div class="banner-content">
                        <h3>건강한 식단 관리</h3>
                        <p>영양가 있는 건강식 레시피로 균형 잡힌 식단을 만들어보세요</p>
                    </div>
                </div>
            </div>
            
            <div class="banner-arrow prev" onclick="moveBanner(1)">
                <i class="fas fa-chevron-left"></i>
            </div>
            <div class="banner-arrow next" onclick="moveBanner(-1)">
                <i class="fas fa-chevron-right"></i>
            </div>
            
            <div class="banner-indicators" id="bannerIndicators">
            </div>
        </div>

		<!-- KOREAN -->
		<section class="category-section" id="cat-korean">
			<div class="category-header">
				<h3 class="category-title"><i class="fas fa-bowl-food"></i> 한식 <span class="en-title">(Korean Food)</span></h3>
			</div>

			<div class="recipe_slider_wrap">
			        <button class="slider_btn prev_btn"><i class="fas fa-chevron-left"></i></button>
			        <button class="slider_btn next_btn"><i class="fas fa-chevron-right"></i></button>
					
				<div class="recipe_slider">
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
			</div>
		</section>

		<!-- CHINESE -->
		<section class="category-section" id="cat-chinese">
			<div class="category-header">
		    	<h3 class="category-title"><i class="fas fa-bowl-food"></i> 중식 <span class="en-title">(Chinese Food)</span></h3>
		    </div>

		    <div class="recipe_slider_wrap">
			    <button class="slider_btn prev_btn"><i class="fas fa-chevron-left"></i></button>
			    <button class="slider_btn next_btn"><i class="fas fa-chevron-right"></i></button>
	
			    <div class="recipe_slider">
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
		  	</div>
		</section>


		<!-- JAPANESE -->
		<section class="category-section" id="cat-japanese">
			<div class="category-header">
		    	<h3 class="category-title"><i class="fas fa-bowl-food"></i> 일식 <span class="en-title">(Japanese Food)</span></h3>
		  	</div>

		  	<div class="recipe_slider_wrap">
		    	<button class="slider_btn prev_btn"><i class="fas fa-chevron-left"></i></button>
			    <button class="slider_btn next_btn"><i class="fas fa-chevron-right"></i></button>
	
			    <div class="recipe_slider">
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
		  	</div>
		</section>


		<!-- WESTERN -->
		<section class="category-section" id="cat-western">
		  	<div class="category-header">
		    	<h3 class="category-title"><i class="fas fa-bowl-food"></i> 양식 <span class="en-title">(Western Food)</span></h3>
		  	</div>

		  	<div class="recipe_slider_wrap">
			    <button class="slider_btn prev_btn"><i class="fas fa-chevron-left"></i></button>
			    <button class="slider_btn next_btn"><i class="fas fa-chevron-right"></i></button>
	
			    <div class="recipe_slider">
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
		  	</div>
		</section>

		<!-- DESSERT -->
		<section class="category-section" id="cat-dessert">
		  	<div class="category-header">
		    	<h3 class="category-title"><i class="fas fa-ice-cream"></i> 디저트 <span class="en-title">(Dessert)</span></h3>
		  	</div>

		  	<div class="recipe_slider_wrap">
			    <button class="slider_btn prev_btn"><i class="fas fa-chevron-left"></i></button>
			    <button class="slider_btn next_btn"><i class="fas fa-chevron-right"></i></button>

	    		<div class="recipe_slider">
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
		  	</div>
		</section>
    </div>
	
	<!-- 레시피 등록 버튼 -->
    <button class="add_recipe_btn" onclick="location.href='recipe_write_new'">
        <i class="fas fa-plus"></i>
    </button>
    
    <jsp:include page="footer.jsp" />
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
	<script>
		const korean_slider = document.querySelector('#cat-korean .recipe_slider');
	
		document.querySelector('#cat-korean .prev_btn')
		  .addEventListener('click', () => {
		    korean_slider.scrollBy({
		      left: -300,
		      behavior: 'smooth'
		    });
		  });
	
		document.querySelector('#cat-korean .next_btn')
		  .addEventListener('click', () => {
		    korean_slider.scrollBy({
		      left: 300,
		      behavior: 'smooth'
		    });
		  });
	</script>
</body>
</html>