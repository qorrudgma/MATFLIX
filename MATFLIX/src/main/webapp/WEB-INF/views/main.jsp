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
            
            <div class="banner-arrow prev" onclick="moveBanner(-1)">
                <i class="fas fa-chevron-left"></i>
            </div>
            <div class="banner-arrow next" onclick="moveBanner(1)">
                <i class="fas fa-chevron-right"></i>
            </div>
            
            <div class="banner-indicators" id="bannerIndicators">
            </div>
        </div>
        
        <!-- 한식 카테고리 섹션 -->
        <div class="category-section">
            <div class="category-header">
                <h2 class="category-title">
                    <i class="fas fa-utensils"></i>
                    한식 <span class="en-title">(Korean Food)</span>
                </h2>
                <div class="slider-controls">
                    <button class="slider-button prev-btn" onclick="slideRecipes('korean-slider', -1)">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="slider-button next-btn" onclick="slideRecipes('korean-slider', 1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/recipe_category?category=1" class="slider-button more-btn">
                        더보기 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
            
            <div class="recipe-slider" id="korean-slider">
                <c:forEach var="img" items="${korean_food_list}">
                    <c:forEach var="recipe" items="${korean_food_recipe_list}">
                        <c:if test="${img.rc_recipe_id == recipe.rc_recipe_id}">
                            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}" class="recipe-card">
                                <div class="recipe-image">
                                    <img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Korean food image" />
                                    <div class="recipe-category">한식</div>
                                </div>
                                <div class="recipe-info">
                                    <h3>${recipe.rc_name}</h3>
                                    <p><strong>난이도:</strong> ${recipe.rc_difficulty}</p>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </div>
        </div>
        
        <!-- 양식 카테고리 섹션 -->
        <div class="category-section">
            <div class="category-header">
                <h2 class="category-title">
                    <i class="fas fa-pizza-slice"></i>
                    양식 <span class="en-title">(American Food)</span>
                </h2>
                <div class="slider-controls">
                    <button class="slider-button prev-btn" onclick="slideRecipes('american-slider', -1)">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="slider-button next-btn" onclick="slideRecipes('american-slider', 1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/recipe_category?category=2" class="slider-button more-btn">
                        더보기 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
            
            <div class="recipe-slider" id="american-slider">
                <c:forEach var="img" items="${american_food_list}">
                    <c:forEach var="recipe" items="${american_food_recipe_list}">
                        <c:if test="${img.rc_recipe_id == recipe.rc_recipe_id}">
                            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}" class="recipe-card">
                                <div class="recipe-image">
                                    <img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="American food image" />
                                    <div class="recipe-category">양식</div>
                                </div>
                                <div class="recipe-info">
                                    <h3>${recipe.rc_name}</h3>
                                    <p><strong>난이도:</strong> ${recipe.rc_difficulty}</p>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </div>
        </div>
        
        <!-- 일식 카테고리 섹션 -->
        <div class="category-section">
            <div class="category-header">
                <h2 class="category-title">
                    <i class="fas fa-fish"></i>
                    일식 <span class="en-title">(Japanese Food)</span>
                </h2>
                <div class="slider-controls">
                    <button class="slider-button prev-btn" onclick="slideRecipes('japanese-slider', -1)">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="slider-button next-btn" onclick="slideRecipes('japanese-slider', 1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/recipe_category?category=3" class="slider-button more-btn">
                        더보기 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
            
            <div class="recipe-slider" id="japanese-slider">
                <c:forEach var="img" items="${japanese_food_list}">
                    <c:forEach var="recipe" items="${japanese_food_recipe_list}">
                        <c:if test="${img.rc_recipe_id == recipe.rc_recipe_id}">
                            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}" class="recipe-card">
                                <div class="recipe-image">
                                    <img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Japanese food image" />
                                    <div class="recipe-category">일식</div>
                                </div>
                                <div class="recipe-info">
                                    <h3>${recipe.rc_name}</h3>
                                    <p><strong>난이도:</strong> ${recipe.rc_difficulty}</p>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </div>
        </div>
        
        <!-- 중식 카테고리 섹션 -->
        <div class="category-section">
            <div class="category-header">
                <h2 class="category-title">
                    <i class="fas fa-drumstick-bite"></i>
                    중식 <span class="en-title">(Chinese Food)</span>
                </h2>
                <div class="slider-controls">
                    <button class="slider-button prev-btn" onclick="slideRecipes('chinese-slider', -1)">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="slider-button next-btn" onclick="slideRecipes('chinese-slider', 1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/recipe_category?category=4" class="slider-button more-btn">
                        더보기 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
            
            <div class="recipe-slider" id="chinese-slider">
                <c:forEach var="img" items="${chinese_food_list}">
                    <c:forEach var="recipe" items="${chinese_food_recipe_list}">
                        <c:if test="${img.rc_recipe_id == recipe.rc_recipe_id}">
                            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}" class="recipe-card">
                                <div class="recipe-image">
                                    <img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Chinese food image" />
                                    <div class="recipe-category">중식</div>
                                </div>
                                <div class="recipe-info">
                                    <h3>${recipe.rc_name}</h3>
                                    <p><strong>난이도:</strong> ${recipe.rc_difficulty}</p>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </div>
        </div>
        
        <!-- 디저트 카테고리 섹션 -->
        <div class="category-section">
            <div class="category-header">
                <h2 class="category-title">
                    <i class="fas fa-ice-cream"></i>
                    디저트 <span class="en-title">(Dessert)</span>
                </h2>
                <div class="slider-controls">
                    <button class="slider-button prev-btn" onclick="slideRecipes('dessert-slider', -1)">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="slider-button next-btn" onclick="slideRecipes('dessert-slider', 1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/recipe_category?category=5" class="slider-button more-btn">
                        더보기 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
            
            <div class="recipe-slider" id="dessert-slider">
                <c:forEach var="img" items="${dessert_list}">
                    <c:forEach var="recipe" items="${dessert_recipe_list}">
                        <c:if test="${img.rc_recipe_id == recipe.rc_recipe_id}">
                            <a href="recipe_content_view?rc_recipe_id=${img.rc_recipe_id}" class="recipe-card">
                                <div class="recipe-image">
                                    <img src="${pageContext.request.contextPath}/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Dessert image" />
                                    <div class="recipe-category">디저트</div>
                                </div>
                                <div class="recipe-info">
                                    <h3>${recipe.rc_name}</h3>
                                    <p><strong>난이도:</strong> ${recipe.rc_difficulty}</p>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
