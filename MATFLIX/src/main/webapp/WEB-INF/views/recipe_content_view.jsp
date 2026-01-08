<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>${recipe.title}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_content_view.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="recipe_view_container">

    <!-- 대표 이미지 -->
    <section class="recipe_hero">
        <img src="${pageContext.request.contextPath}${recipe.image_path}" alt="${recipe.title}">
        <div class="hero_overlay">
            <span class="hero_category">${recipe.category}</span>
            <h1>${recipe.title}</h1>
            <p>${recipe.mf_nickname} · ${recipe.updated_at}</p>
            <p class="recommend">추천 · <span id="recommend_count">${recipe.recommend}</span></p>
        </div>
    </section>

    <!-- 레시피 소개 -->
    <section class="recipe_intro_section">
        <p>${recipe.intro}</p>
    </section>

    <!-- 재료 -->
    <section class="recipe_block">
        <h2>재료</h2>
        <ul class="ingredient_list">
            <c:forEach var="i" items="${ingredient_list}">
                <li>
                    <span>${i.ingredient_name}</span>
                    <span>${i.ingredient_amount}</span>
                </li>
            </c:forEach>
        </ul>
    </section>

    <!-- 조리 과정 -->
    <section class="recipe_block">
        <h2>조리 방법</h2>

        <c:forEach var="s" items="${step_list}">
            <div class="step_item">
                <div class="step_text">
                    <span class="step_no">STEP ${s.step_no}</span>
                    <p>${s.step_content}</p>
                </div>

                <!-- 같은 step_no 이미지 -->
                <div class="step_image">
                    <c:forEach var="img" items="${image_list}">
                        <c:if test="${img.step_no == s.step_no}">
						<img src="${pageContext.request.contextPath}${img.image_path}" alt="이미지">
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </section>

    <!-- 태그 -->
    <section class="recipe_tag_section">
        <c:forEach var="t" items="${tag_list}">
            <span class="recipe_tag">#${t.tag}</span>
        </c:forEach>
    </section>
	
	<!-- 사진 리뷰 -->
	<section class="photo_review_section">
	    <div class="photo_review_header">
	        <h2>사진 리뷰</h2>
	        <!-- 추천 버튼 -->
			<c:choose>
				<c:when test="${recommended != 1}">
			        <button class="photo_review_like_btn">
			            <i class="fas fa-thumbs-up"></i> 추천
			        </button>
				</c:when>
				<c:otherwise>
					<button class="photo_review_like_btn active">
					    <i class="fas fa-thumbs-up"></i> 추천 취소
					</button>
				</c:otherwise>
			</c:choose>
	    </div>

	    <div class="photo_review_list">
	        <!-- 나중에 리뷰 이미지로 교체 -->
	        <c:forEach var="img" items="${image_list}">
	            <c:if test="${img.image_type eq 'STEP'}">
	                <div class="photo_review_item">
	                    <img src="${pageContext.request.contextPath}${img.image_path}" alt="리뷰 사진">
	                </div>
	            </c:if>
	        </c:forEach>
	        <c:forEach var="img" items="${image_list}">
	            <c:if test="${img.image_type eq 'STEP'}">
	                <div class="photo_review_item">
	                    <img src="${pageContext.request.contextPath}${img.image_path}" alt="리뷰 사진">
	                </div>
	            </c:if>
	        </c:forEach>
	    </div>
	</section>

    <!-- 댓글 -->
    <section class="comment_section">
        <h2>댓글</h2>

        <!-- 댓글 입력 -->
        <div class="comment_input">
            <input type="text" id="input_recipe_comment" placeholder="맛평을 입력하세요...">
            <button type="button" onclick="commentWrite(0)" class="btn-comment">등록</button>
        </div>

        <!-- 댓글 리스트 (값은 네가 연결) -->
        <div class="comment_list">
        </div>
    </section>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
<script>
	// 변수
	var sessionUserNo = "${not empty user ? user.mf_no : '' }";
    var recipe_id = "${recipe.recipe_id}";
	var parentCommentNo = 0;
	
	document.addEventListener("DOMContentLoaded", function () {
	    const photoReview = document.querySelector(".photo_review_list");
	
	    if (!photoReview) return;
	
	    photoReview.addEventListener("wheel", function (e) {
	        e.preventDefault();
	
	        // 휠 움직임을 가로 스크롤로 전환
	        photoReview.scrollLeft += e.deltaY;
	    }, { passive: false });
	});
	
	// 추천 버튼
    $(document).on("click", ".photo_review_like_btn", function (e) {
        e.preventDefault();

        if (sessionUserNo == '') {
            alert("로그인 후 이용 가능합니다.");
            return;
        }

        $.ajax({
             type: "POST"
            ,data: {recipe_id: recipe_id}
            ,url: "/recipe_recommend"
            ,success: function (result) {
				console.log(result);
				$("#recommend_count").text(result.count);
                if(result.status === "recommended") {
					console.log("recommended");
                    $(".photo_review_like_btn").html('<i class="fas fa-heart"></i> 추천 취소').addClass("active");
                } else {
					console.log("cancel");
                    $(".photo_review_like_btn").html('<i class="fas fa-heart"></i> 추천').removeClass("active");
                }
            }
            ,error: function () {
                console.log("추천 실패");
            }
        });
    });
	
	// 댓글 작성
    function commentWrite(parentCommentNo) {
        console.log("유저 넘 => " + sessionUserNo);
    	let content = document.getElementById("input_recipe_comment").value;

		// 로그인 체크
	    if (sessionUserNo == '') {
	        alert("로그인 후 이용 가능합니다.");
	        return;
	    }
		// 빈칸 작성 확인
        if (!content.trim()) {
            alert("댓글 내용을 입력해주세요.");
            return;
        }

        $.ajax({
            type: "post",
            data: {
                recipe_id: recipe_id,
                comment_content: content,
				parentCommentNo: parentCommentNo
            },
            url: "/recipe/comment",
            success: function(recipeCommentList) {
                console.log("작성 성공");
                document.getElementById("input_recipe_comment").value = "";
				// 답글 모드에서 일반 댓글 모드로 돌아감
				parentCommentNo = 0;
                // 댓글 목록 새로고침
                //loadComments();
            },
            error: function() {
                console.log("실패");
            }
        });
    }
</script>