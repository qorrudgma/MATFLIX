<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX</title>
	<link href="${pageContext.request.contextPath}/css/content_main.css" rel="stylesheet"><!-- 메인 css -->
    <link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet"><!-- 헤더 css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"><!-- 외부 css -->
</head>
<style>
    #header_nav{
        display: flex;
        width: 100%;
        height: 30px;
        background-color: aquamarine;
        padding: auto;
    }

    #content_view{
        width: 80%;
        margin: 0 auto;
        height: 200px;
        background-color: rgb(218, 218, 218);
    }

    #content_view{
        display: flex;
    }
</style>
<body>
    <jsp:include page="header.jsp" />
    <!-- 메인 -->
<!--    <div id="main_content">-->
<!--         <div id="content_view">-->
<!--            <c:forEach var="dto" items="${list}" begin="0" end="10">-->
<!--                <div id="content_view_one">-->
<!--                   <div>${dto.boardNo}</div>-->
<!--                   <div>${dto.boardName}</div>-->
<!--                   <div>-->
<!--                         <a class="move_link" href="${dto.boardNo}">${dto.boardTitle}</a>-->
<!--                   </div>-->
<!--                   <div>${dto.boardDate}</div>-->
<!--                   <div>${dto.boardHit}</div>-->
<!--                </div>-->
<!--             </c:forEach>-->
<!--         </div>-->
<!--    </div>-->
	<div class="main_content">
	    <!-- 배너 슬라이더 -->
	    <section class="banner_slider">
	        <div class="slider_container">
				<ul class="bxslider">
					<!-- forEach -->
					<li>
						<img class="food_img" alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
		                <div class="slider_caption">
		                	<div>
			                    <h2>20분 안에 완성하는 한끼</h2>
			                    <p>바쁜 일상 속 빠르게 만드는 맛있는 요리</p>
		                    </div>
		                    <div class="caption_div">
		                    	<a href="#">만들러 가기</a>
		                    </div>
		                </div>	
					</li>
					<!--  -->
				</ul>
			</div>
		</section>
		<form id="user_profile" class="profile" action="profile" method="post">
			<div class="form_profile">
		    	<input type="submit" class="mypage_btn" value="mypage">
			</div>
		</form>
	    
	    <!-- 한식 카테고리 -->
	    <section class="category_section_korean">
	        <div class="section_header">
	            <h2>한식</h2>
	            <a href="#" class="view_all">전체보기 <i class="fas fa-arrow_right"></i></a>
	        </div>
	        <div class="recipe_grid">
                <!-- forEach -->
	            <div class="recipe_card">
	                <div class="recipe_image">
	                    <img alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
	                    <div class="recipe_overlay">
	                        <a href="#" class="btn_view">레시피 보기</a>
	                    </div>
	                </div>
	                <div class="recipe_info">
	                    <h3><a href="#">얼큰한 김치찌개</a></h3>
	                    <p>묵은지로 만드는 깊은 맛의 김치찌개</p>
	                    <div class="recipe_meta">
	                        <div class="recipe_rating">
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star_half_alt"></i>
	                            <span>(리뷰한 인원)</span>
	                        </div>
	                        <div class="recipe_time">
	                            <i class="far fa-clock"></i> 30분
	                        </div>
	                    </div>
	                </div>
	            </div>
                <!--  -->
	        </div>
	    </section>

	    <!-- 양식 카테고리 -->
	    <section class="category_section_western">
	        <div class="section_header">
	            <h2>양식</h2>
	            <a href="#" class="view_all">전체보기 <i class="fas fa-arrow_right"></i></a>
	        </div>
	        <div class="recipe_grid">
                <!-- forEach -->
	            <div class="recipe_card">
	                <div class="recipe_image">
	                    <img alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
	                    <div class="recipe_overlay">
	                        <a href="#" class="btn_view">레시피 보기</a>
	                    </div>
	                </div>
	                <div class="recipe_info">
	                    <h3><a href="#">얼큰한 김치찌개</a></h3>
	                    <p>묵은지로 만드는 깊은 맛의 김치찌개</p>
	                    <div class="recipe_meta">
	                        <div class="recipe_rating">
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star_half_alt"></i>
	                            <span>(리뷰한 인원)</span>
	                        </div>
	                        <div class="recipe_time">
	                            <i class="far fa-clock"></i> 30분
	                        </div>
	                    </div>
	                </div>
	            </div>
                <!--  -->
	        </div>
	    </section>

	    <!-- 요리 기구 광고 -->
	    <section class="todays_menu">
	        <div class="todays_menu_container">
	            <div class="menu_image">
					<img alt="cooking_tool" src="${pageContext.request.contextPath}/resources/image/cooking_tool.png">
	            </div>
	            <div class="menu_info">
	                <span class="menu_label">요리에 맞는 기구를 고르세요!</span>
	                <h3>요리마다 사용되는 기구는 다릅니다</h3>
	                <p>사용되는 기구마다 요리의 퀄리티가 달라진다 등등 광고하는 얘기~~~</p>
	                <div>
	                	<a href="#">자세히 보기</a>
	                </div>
	            </div>
	        </div>
	    </section>
	    
	    <!-- 일식 카테고리 -->
	    <section class="category_section_japanese">
	        <div class="section_header">
	            <h2>일식</h2>
	            <a href="#" class="view_all">전체보기 <i class="fas fa-arrow_right"></i></a>
	        </div>
	        <div class="recipe_grid">
                <!-- forEach -->
	            <div class="recipe_card">
	                <div class="recipe_image">
	                    <img alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
	                    <div class="recipe_overlay">
	                        <a href="#" class="btn_view">레시피 보기</a>
	                    </div>
	                </div>
	                <div class="recipe_info">
	                    <h3><a href="#">얼큰한 김치찌개</a></h3>
	                    <p>묵은지로 만드는 깊은 맛의 김치찌개</p>
	                    <div class="recipe_meta">
	                        <div class="recipe_rating">
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star_half_alt"></i>
	                            <span>(리뷰한 인원)</span>
	                        </div>
	                        <div class="recipe_time">
	                            <i class="far fa-clock"></i> 30분
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <!--  -->
	        </div>
	    </section>
	    
	    <!-- 중식 카테고리 -->
	    <section class="category_section_chinese">
	        <div class="section_header">
	            <h2>중식</h2>
	            <a href="#" class="view_all">전체보기 <i class="fas fa-arrow_right"></i></a>
	        </div>
	        <div class="recipe_grid">
                <!-- forEach -->
	            <div class="recipe_card">
	                <div class="recipe_image">
	                    <img alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
	                    <div class="recipe_overlay">
	                        <a href="#" class="btn_view">레시피 보기</a>
	                    </div>
	                </div>
	                <div class="recipe_info">
	                    <h3><a href="#">얼큰한 김치찌개</a></h3>
	                    <p>묵은지로 만드는 깊은 맛의 김치찌개</p>
	                    <div class="recipe_meta">
	                        <div class="recipe_rating">
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star_half_alt"></i>
	                            <span>(리뷰한 인원)</span>
	                        </div>
	                        <div class="recipe_time">
	                            <i class="far fa-clock"></i> 30분
	                        </div>
	                    </div>
	                </div>
	            </div>
                <!--  -->
	        </div>
	    </section>
	    
	    <!-- 요리 재료 광고 -->
	    <section class="todays_menu">
	        <div class="todays_menu_container">
	            <div class="menu_image">
					<img alt="cooking_tool" src="${pageContext.request.contextPath}/resources/image/재료.png">
	            </div>
	            <div class="menu_info">
	                <span class="menu_label">신선한 재료가 더 맛있는 요리를 만든다!</span>
	                <h3>재료마다 어쩌구저쩌구</h3>
	                <p>요리재료들을 광고하는 곳~~~</p>
	                <div>
	                	<a href="#">자세히 보기</a>
	                </div>
	            </div>
	        </div>
	    </section>
	    
	    <!-- 디저트 카테고리 -->
	    <section class="category_section_dessert">
	        <div class="section_header">
	            <h2>디저트</h2>
	            <a href="#" class="view_all">전체보기 <i class="fas fa-arrow_right"></i></a>
	        </div>
	        <div class="recipe_grid">
                <!-- forEach -->
	            <div class="recipe_card">
	                <div class="recipe_image">
	                    <img alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
	                    <div class="recipe_overlay">
	                        <a href="#" class="btn_view">레시피 보기</a>
	                    </div>
	                </div>
	                <div class="recipe_info">
	                    <h3><a href="#">얼큰한 김치찌개</a></h3>
	                    <p>묵은지로 만드는 깊은 맛의 김치찌개</p>
	                    <div class="recipe_meta">
	                        <div class="recipe_rating">
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star"></i>
	                            <i class="fas fa-star_half_alt"></i>
	                            <span>(리뷰한 인원)</span>
	                        </div>
	                        <div class="recipe_time">
	                            <i class="far fa-clock"></i> 30분
	                        </div>
	                    </div>
	                </div>
	            </div>
                <!--  -->
	        </div>
	    </section>
	    
	    <!-- 추천하는 사용자들 -->
	    <section class="category_section">
	        <div class="section_header">
	            <h2>인기 요리사</h2>
	        </div>
	        <div class="recipe_grid">
                <!-- forEach -->
	            <div class="user_card">
	                <div class="user_image">
                        <img alt="MATFLIX" src="${pageContext.request.contextPath}/resources/image/MATFLIX.png">
	                </div>
	                <div class="recipe_info">
	                    <h3>닉네임</h3>
	                    <p>자기소개</p>
	                    <div class="recipe_meta">
	                        <div class="recipe_rating">
	                            <i class="fas fa-book"></i>
	                            <span>게시물수 : 54</span>
	                        </div>
	                        <div class="recipe_time">
	                             12
	                        </div>
	                    </div>
	                </div>
	            </div>
                <!--  -->
	        </div>
	    </section>
	</div>
</body>
</html>