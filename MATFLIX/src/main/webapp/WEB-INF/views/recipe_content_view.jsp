<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<%
    // 현재 로그인한 사용자의 닉네임을 세션에서 가져옵니다.
    TeamDTO user = (TeamDTO) session.getAttribute("user"); // user 세션 속성 사용
    String writer = "";
    if (user != null) {
        writer = user.getMf_nickname();
    } else {
        writer = "익명"; // 로그인하지 않은 경우 "익명"으로 표시
    }
%>

<html>
<head>
    <title>${dto.rc_name} - 레시피 상세</title>
    <style>
        /* 기존 스타일은 그대로 유지합니다. */
        .recipe-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            font-family: sans-serif;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .recipe-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .recipe-header h1 {
            font-size: 2em;
            color: #333;
            margin-bottom: 10px;
        }

        .recipe-header img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .recipe-header p {
            color: #777;
            margin-bottom: 5px;
            font-size: 0.9em;
        }

        .section-title {
            font-weight: bold;
            font-size: 1.1em;
            color: #333;
            margin-top: 25px;
            margin-bottom: 10px;
            border-bottom: 2px solid #eee;
            padding-bottom: 5px;
        }

        .ingredients ul {
            list-style: none;
            padding: 0;
            margin-top: 5px;
        }

        .ingredients li {
            padding: 8px 0;
            border-bottom: 1px dotted #ccc;
        }

        .ingredients li:last-child {
            border-bottom: none;
        }

        .steps ol {
            list-style-type: decimal;
            padding-left: 20px;
            margin-top: 5px;
        }

        .steps li {
            padding: 10px 0;
            border-bottom: 1px dotted #ccc;
        }

        .steps li:last-child {
            border-bottom: none;
        }

        .steps .step-image {
            max-width: 80%;
            height: auto;
            border-radius: 4px;
            margin-top: 10px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .tip p {
            margin-top: 10px;
            line-height: 1.6;
        }

        .comment-section {
            margin-top: 30px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        .comment-input-area {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            align-items: center;
        }

        .comment-input-area input[type="text"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            flex-grow: 1;
        }

        .star-rating-container-comment {
            display: flex;
            align-items: center;
        }

        .star-rating {
            display: inline-block;
            font-size: 1.2em;
            color: #ccc;
            margin-left: 5px;
        }

        .star-rating .star {
            cursor: pointer;
        }

        .star-rating .filled {
            color: gold;
        }

        .comment-input-area button {
            padding: 10px 15px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
        }

        .comment-input-area button:hover {
            background-color: #4cae4c;
        }

        #comment-list {
            margin-top: 10px;
        }

        #comment-list .comment-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
        }

        #comment-list .comment-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        #comment-list .comment-writer {
            font-weight: bold;
            margin-right: 10px;
        }

        #comment-list .comment-date {
            color: #888;
            font-size: 0.9em;
        }

        #comment-list .comment-content {
            margin-top: 10px;
            line-height: 1.5;
        }

        #comment-list .comment-stars {
            margin-top: 10px;
        }
		
		
		.favorite-toggle-button {
		        padding: 8px 15px;
		        font-size: 1em;
		        cursor: pointer;
		        border: 1px solid #ccc;
		        border-radius: 5px;
		        background-color: #f8f8f8;
		        color: #333;
		        margin-bottom: 15px; /* 다른 요소와의 간격 */
		        transition: background-color 0.2s, color 0.2s;
		    }
		    .favorite-toggle-button:hover {
		        background-color: #e9e9e9;
		    }
		    .favorite-toggle-button.favorited {
		        background-color: #FFD700; /* 금색 배경 */
		        color: #fff; /* 흰색 텍스트 */
		        border-color: #FFC107;
		    }
		    .favorite-toggle-button.favorited .fa-star { /* 아이콘 스타일 변경 */
		        font-weight: 900; /* Font Awesome Solid 스타일 */
		    }
		    .favorite-toggle-button .fa-star {
		        margin-right: 5px;
		    }
    </style>
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script>
        $(document).ready(function() {
            // 별점 기능
            $('.star-rating .star').on('click', function() {
                const ratingValue = $(this).data('value');
                $('#user_star_scoreValue').val(ratingValue);
                $('#commentRatingText').text('(' + ratingValue + '점)');
                $(this).prevAll('.star').addClass('filled');
                $(this).addClass('filled');
                $(this).nextAll('.star').removeClass('filled');
                $('#commentStarRating').data('current-rating', ratingValue);
            });

            $('.star-rating .star').on('mouseover', function() {
                const ratingValue = $(this).data('value');
                $(this).prevAll('.star').addClass('temp-filled');
                $(this).addClass('temp-filled');
                $(this).nextAll('.star').removeClass('temp-filled');
            }).on('mouseout', function() {
                const currentRating = $('#commentStarRating').data('current-rating');
                $('.star-rating .star').removeClass('temp-filled');
                $('.star-rating .star').slice(0, currentRating).addClass('filled');
            });
        });

        const commentWrite = () => {
            const writer = $("#rc_commentWriter").val();
            const content = $("#rc_commentContent").val();
            const boardNo = "${rc_board.rc_boardNo}";
            const rating = $("#user_star_scoreValue").val();

            if (!content.trim()) {
                alert("댓글 내용을 입력해주세요.");
                $("#rc_commentContent").focus();
                return;
            }

            console.log("전송되는 writer 값:", writer);

            $.ajax({
                type: "post",
                url: "/rc_comment/save",
                data: {
                    rc_commentWriter: writer,
                    rc_commentContent: content,
                    rc_boardNo: boardNo,
                    user_star_score: rating
                },
                dataType: "json",
                success: function (commentList) {
                    alert("댓글이 작성되었습니다.");
                    //$("#rc_commentContent").val("");  // 입력창 초기화 제거
                    //$('#user_star_scoreValue').val(0); // 별점 초기화 제거
                    //$('#commentRatingText').text('(0점)'); // 별점 텍스트 제거
                    //$('.star-rating .star').removeClass('filled'); // 별점 스타일 제거
                    window.location.reload(); // 페이지 새로고침
                    /*
                    let output = "";
                    for (let i = 0; i < commentList.length; i++) {
                        output += "<div class='comment-item'>";
                        output += "<span class='comment-date'>" + commentList[i].rc_commentCreatedTime + "</span><br>";
                        output += "<span class='comment-content'>" + commentList[i].rc_commentContent + "</span>";
                        output += "<div class='comment-stars'>";
                        for (let j = 1; j <= 5; j++) {
                            if (j <= commentList[i].user_star_score) {
                                output += "<span style='color: gold;'>★</span>";
                            } else {
                                output += "<span style='color: #ccc;'>★</span>";
                            }
                        }
                        output += "</div>";
                        output += "</div>";
                    }
                    $("#comment-list").html(output);
                    */
                },
                error: function (xhr, status, error) {
                    console.error("댓글 작성 실패:", error);
                    alert("댓글 작성에 실패했습니다.");
                }
            });
        };
		
		
		// --------------------------------	여기 추가됨(즐겨찾기)	----------------------------------------------
		
		$(document).ready(function() {
		    const favoriteButton = $('#favoriteToggleButton');
		    const recipeId = favoriteButton.data('recipe-id');

		    if (recipeId && favoriteButton.length > 0) {
		        const ajaxHeaders = {
		            'Content-Type': 'application/json'
		        };
		        checkFavoriteStatus(recipeId);

		        // --- 버튼 클릭 이벤트 핸들러 ---
		        favoriteButton.on('click', function() {
		            const isCurrentlyFavorited = $(this).data('is-favorited');
		            if (isCurrentlyFavorited) {
		                removeRecipeFromFavorites(recipeId);
		            } else {
		                addRecipeToFavorites(recipeId);
		            }
		        });

		        // --- 서버에 현재 즐겨찾기 상태를 물어보는 함수 ---
		        function checkFavoriteStatus(currentRecipeId) {
		            console.log("페이지 로드: 즐겨찾기 상태 확인 시작 (Recipe ID: " + currentRecipeId + ")");
		            $.ajax({
		                url: '${pageContext.request.contextPath}/favorites/recipe/status', // 서버의 상태 확인 API 경로
		                type: 'GET',
		                data: { recipeId: currentRecipeId },
		                dataType: 'json',
		                success: function(response) {
		                    console.log("서버 응답 (즐겨찾기 상태):", response);
		                    if (response && typeof response.isFavorited !== 'undefined') {
		                        updateFavoriteButtonUI(response.isFavorited, currentRecipeId);
		                    } else {
		                        console.warn('즐겨찾기 상태 확인 실패: 서버 응답 형식이 올바르지 않음', response);
		                        updateFavoriteButtonUI(false, currentRecipeId);
		                    }
		                },
		                error: function(xhr, status, error) {
		                    console.error('즐겨찾기 상태 확인 중 AJAX 오류:', status, error);
		                    updateFavoriteButtonUI(false, currentRecipeId);
		                }
		            });
		        }

		        // --- 즐겨찾기 추가 함수 ---
		        function addRecipeToFavorites(currentRecipeId) {
		            console.log("즐겨찾기 추가 시도 (Recipe ID: " + currentRecipeId + ")");
		            $.ajax({
		                url: '${pageContext.request.contextPath}/favorites/recipe/add',
		                type: 'POST',
		                headers: ajaxHeaders,
		                data: JSON.stringify({ recipeId: currentRecipeId }),
		                dataType: 'json',
		                success: function(response) {
		                    if (response.success) {
		                        alert(response.message || '즐겨찾기에 추가되었습니다.');
		                        updateFavoriteButtonUI(true, currentRecipeId);
		                    } else {
		                        alert(response.message || '즐겨찾기 추가에 실패했습니다.');
		                    }
		                },
		                error: function(xhr, status, error) {
		                    console.error('즐겨찾기 추가 중 AJAX 오류:', error);
		                    alert('즐겨찾기 추가 중 오류가 발생했습니다.');
		                }
		            });
		        }

		        // --- 즐겨찾기 삭제 함수 ---
		        function removeRecipeFromFavorites(currentRecipeId) {
		            console.log("즐겨찾기 삭제 시도 (Recipe ID: " + currentRecipeId + ")"); // 디버깅용
		            $.ajax({
		                url: '${pageContext.request.contextPath}/favorites/recipe/remove', // 서버의 삭제 API 경로
		                type: 'POST',
		                headers: ajaxHeaders, // POST 요청 시 CSRF 토큰 등이 필요할 수 있음
		                data: JSON.stringify({ recipeId: currentRecipeId }),
		                dataType: 'json',
		                success: function(response) {
		                    if (response.success) {
		                        alert(response.message || '즐겨찾기에서 삭제되었습니다.');
		                        updateFavoriteButtonUI(false, currentRecipeId);
		                    } else {
		                        alert(response.message || '즐겨찾기 삭제에 실패했습니다.');
		                    }
		                },
		                error: function(xhr, status, error) {
		                    console.error('즐겨찾기 삭제 중 AJAX 오류:', error);
		                    alert('즐겨찾기 삭제 중 오류가 발생했습니다.');
		                }
		            });
		        }

		        // --- 버튼 UI 업데이트 함수 ---
		        function updateFavoriteButtonUI(isFavorited, currentRecipeId) {
		            console.log("버튼 UI 업데이트: isFavorited = " + isFavorited + " (Recipe ID: " + currentRecipeId + ")"); // 디버깅용
		            const button = $('#favoriteToggleButton[data-recipe-id="' + currentRecipeId + '"]');
		            button.data('is-favorited', isFavorited); // data 속성 업데이트

		            if (isFavorited) {
		                button.html('<i class="fa-solid fa-star"></i> <span>즐겨찾기됨</span>'); // 아이콘과 텍스트 변경
		                button.addClass('favorited');    // CSS 클래스 변경
		            } else {
		                button.html('<i class="fa-regular fa-star"></i> <span>즐겨찾기 추가</span>');
		                button.removeClass('favorited');
		            }
		        }
		    } else {
		    }
		});
		</script>
		
    </script>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="recipe-container">
    <div class="recipe-header">
        <h1>${dto.rc_name}</h1>
		    <% if(user != null) { // 스크립틀릿으로 세션의 user 객체 확인 %>
		        <button type="button" id="favoriteToggleButton"
		                class="favorite-toggle-button"
		                data-recipe-id="${dto.rc_recipe_id}"
		                data-is-favorited="false">
		            <i class="fa-regular fa-star"></i> <span>즐겨찾기 추가</span>
		        </button>
		    <% } else { %>
		        <p style="color: #777; font-size: 0.9em;">
		            <a href="${pageContext.request.contextPath}/login">로그인</a> 후 즐겨찾기 기능을 이용할 수 있습니다.
		        </p>
		    <% } %>
        <c:if test="${not empty img_list}">
            <img src="/upload/${img_list.uploadPath}/${img_list.uuid}_${img_list.fileName}"
                 alt="${dto.rc_name}" />
        </c:if>
        <p>작성자: ${mem_dto.mf_nickname}</p> <p>등록일: ${dto.rc_created_at}</p>
        <p>카테고리: ${dto.rc_category1_id} / ${dto.rc_category2_id}</p>
        <p>소요시간: ${dto.rc_cooking_time}분</p>
        <p>난이도: ${dto.rc_difficulty}</p>
        <p>태그: ${dto.rc_tag}</p>
    </div>

    <div class="description">
        <p class="section-title">레시피 설명</p>
        <p>${dto.rc_description}</p>
    </div>

    <div class="ingredients">
        <p class="section-title">재료</p>
        <ul>
            <c:forEach var="ing" items="${ing_list}">
                <li>${ing.rc_ingredient_name} - ${ing.rc_ingredient_amount}</li>
            </c:forEach>
        </ul>
    </div>

    <div class="steps">
        <p class="section-title">요리 순서</p>
        <ol>
            <c:forEach var="step" items="${course_list}" varStatus="status">
                <li>
                    <p><strong>Step ${status.index + 1}:</strong> ${step.rc_course_description}</p>
                    <c:forEach var="img" items="${course_img_list}">
                        <c:if test="${img.rc_recipe_id == dto.rc_recipe_id && img.image && fn:contains(img.fileName, '_step' + (status.index + 1))}">
                            <img src="/upload/${img_list.uploadPath}/${img_list.uuid}_${img_list.fileName}"
                                 alt="Step ${status.index + 1}" class="step-image" />
                        </c:if>
                    </c:forEach>
                </li>
            </c:forEach>
        </ol>
    </div>

    <div class="tip">
        <p class="section-title">요리 팁</p>
        <p>${dto.rc_tip}</p>
    </div>

    <div class="comment-section">
        <p class="section-title">댓글 작성</p>
        <div class="comment-input-area">
            <input type="hidden" id="rc_commentWriter"  value="<%= writer %>"> <%-- hidden으로 변경 --%>
            <input type="text" id="rc_commentContent" placeholder="내용">
            <div class="star-rating-container-comment">
                <label for="user_star_scoreValue" style="margin-right: 5px;">별점:</label>
                <div class="star-rating" id="commentStarRating" data-current-rating="0">
                    <span class="star" data-value="1">&#9733;</span>
                    <span class="star" data-value="2">&#9733;</span>
                    <span class="star" data-value="3">&#9733;</span>
                    <span class="star" data-value="4">&#9733;</span>
                    <span class="star" data-value="5">&#9733;</span>
                </div>
                <input type="hidden" id="user_star_scoreValue" name="user_star_score" value="0">
                <span id="commentRatingText" style="margin-left: 8px; font-size: 1em;">(0점)</span>
            </div>
            <button onclick="commentWrite()">댓글작성</button>
        </div>

        <p class="section-title">댓글 목록</p>
        <div id="comment-list">
            <c:forEach items="${commentList}" var="comment">
                <div class="comment-item">
                    <span class="comment-date">${comment.rc_commentCreatedTime}</span><br>
					<span class="comment-writer"><%= writer %></span><br>
                    <span class="comment-content">${comment.rc_commentContent}</span>
                    <div class="comment-stars">
                        <%-- 별점을 별 모양으로 표시 --%>
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= comment.user_star_score}">
                                    <span style="color: gold;">★</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #ccc;">★</span>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty commentList}">
                <div class="comment-item" style="text-align: center;">작성된 댓글이 없습니다.</div>
            </c:if>
        </div>
    </div>
</div>
<script>
    // Existing commentWrite function remains the same
</script>
</body>
</html>
