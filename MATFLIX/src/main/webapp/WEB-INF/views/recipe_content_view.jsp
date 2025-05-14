<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${dto.rc_name} - 레시피 상세</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 레시피 상세 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_content_view.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <style>
        li{
            list-style: none;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="recipe-container">
        <div class="recipe-header">
            <h1>${dto.rc_name}</h1>
            
            <% if(user != null) { %>
                <button type="button" id="favoriteToggleButton"
                        class="favorite-toggle-button"
                        data-recipe-id="${dto.rc_recipe_id}"
                        data-is-favorited="false">
                    <i class="fa-regular fa-star"></i> <span>즐겨찾기 추가</span>
                </button>
            <% } else { %>
                <p style="color: var(--light-text); font-size: 14px; margin-bottom: 15px;">
                    <a href="${pageContext.request.contextPath}/login" style="color: var(--primary-color);">로그인</a> 후 즐겨찾기 기능을 이용할 수 있습니다.
                </p>
            <% } %>
            
            <c:if test="${not empty img_list}">
                <img src="/upload/${img_list.uploadPath}/${img_list.uuid}_${img_list.fileName}"
                     alt="${dto.rc_name}" />
            </c:if>
            <c:if test="${empty img_list}">
                <img src="${pageContext.request.contextPath}/images/default-recipe.jpg" alt="${dto.rc_name}" />
            </c:if>
            
            <p><strong>작성자:</strong> ${mem_dto.mf_nickname}</p>
            <p><strong>등록일:</strong> ${dto.rc_created_at}</p>
            <p><strong>카테고리:</strong>
                <c:choose>
                    <c:when test="${dto.rc_category1_id == 1}">한식</c:when>
                    <c:when test="${dto.rc_category1_id == 2}">양식</c:when>
                    <c:when test="${dto.rc_category1_id == 3}">일식</c:when>
                    <c:when test="${dto.rc_category1_id == 4}">중식</c:when>
                    <c:when test="${dto.rc_category1_id == 5}">디저트</c:when>
                    <c:otherwise>기타</c:otherwise>
                </c:choose>
            </p>
            <p><strong>소요시간:</strong> ${dto.rc_cooking_time}분</p>
            <p><strong>난이도:</strong> ${dto.rc_difficulty}</p>
            <c:if test="${not empty dto.rc_tag}">
                <p><strong>태그:</strong> ${dto.rc_tag}</p>
            </c:if>
        </div>

        <div class="description">
            <p class="section-title">레시피 설명</p>
            <p>${dto.rc_description}</p>
        </div>

        <div class="ingredients">
            <p class="section-title">재료</p>
            <ul>
                <c:forEach var="ing" items="${ing_list}">
                    <li>
                        <span>${ing.rc_ingredient_name}</span>
                        <span>${ing.rc_ingredient_amount}</span>
                    </li>
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
                                <img src="/upload/${img.uploadPath}/${img.uuid}_${img.fileName}"
                                     alt="Step ${status.index + 1}" class="step-image" />
                            </c:if>
                        </c:forEach>
                    </li>
                </c:forEach>
            </ol>
        </div>

        <c:if test="${not empty dto.rc_tip}">
            <div class="tip">
                <p class="section-title">요리 팁</p>
                <p>${dto.rc_tip}</p>
            </div>
        </c:if>

        <div class="comment-section">
            <p class="section-title">댓글 작성</p>
            <div class="comment-input-area">
                <input type="hidden" id="rc_commentWriter" value="<%= writer %>">
                <input type="text" id="rc_commentContent" placeholder="맛있게 드셨나요? 여러분의 의견을 남겨주세요.">
                <div class="star-rating-container-comment">
                    <label for="user_star_scoreValue">별점:</label>
                    <div class="star-rating" id="commentStarRating" data-current-rating="0">
                        <span class="star" data-value="1">&#9733;</span>
                        <span class="star" data-value="2">&#9733;</span>
                        <span class="star" data-value="3">&#9733;</span>
                        <span class="star" data-value="4">&#9733;</span>
                        <span class="star" data-value="5">&#9733;</span>
                    </div>
                    <input type="hidden" id="user_star_scoreValue" name="user_star_score" value="0">
                    <span id="commentRatingText">(0점)</span>
                </div>
                <button onclick="commentWrite()">댓글 등록</button>
            </div>

            <p class="section-title">댓글 목록</p>
            <div id="comment-list">
                <c:forEach items="${commentList}" var="comment">
                    <div class="comment-item">
                        <div class="comment-writer">${comment.rc_commentWriter}</div>
                        <div class="comment-date">${comment.rc_commentCreatedTime}</div>
                        <div class="comment-content">${comment.rc_commentContent}</div>
                        <div class="comment-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= comment.user_star_score}">
                                        <span style="color: #ffc107;">★</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #ddd;">★</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span style="color: var(--light-text); font-size: 14px; margin-left: 5px;">(${comment.user_star_score}점)</span>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty commentList}">
                    <div class="comment-item" style="text-align: center; color: var(--light-text);">
                        작성된 댓글이 없습니다. 첫 댓글을 남겨보세요!
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />

<script>
    $(document).ready(function() {
        // 별점 기능
        $('.star-rating .star').on('click', function() {
            const ratingValue = $(this).data('value');
            $('#user_star_scoreValue').val(ratingValue);
            $('#commentRatingText').text('(' + ratingValue + '점)');
            
            // 별점 시각적 표시
            $('.star-rating .star').each(function(index) {
                if (index < ratingValue) {
                    $(this).html('<i class="fas fa-star"></i>');
                } else {
                    $(this).html('<i class="far fa-star"></i>');
                }
            });
            
            $('#commentStarRating').data('current-rating', ratingValue);
        });
        
        // 별점 호버 효과
        $('.star-rating .star').on('mouseover', function() {
            const ratingValue = $(this).data('value');
            
            $('.star-rating .star').each(function(index) {
                if (index < ratingValue) {
                    $(this).html('<i class="fas fa-star"></i>');
                } else {
                    $(this).html('<i class="far fa-star"></i>');
                }
            });
        }).on('mouseout', function() {
            const currentRating = $('#commentStarRating').data('current-rating');
            
            $('.star-rating .star').each(function(index) {
                if (index < currentRating) {
                    $(this).html('<i class="fas fa-star"></i>');
                } else {
                    $(this).html('<i class="far fa-star"></i>');
                }
            });
        });
        
        // 즐겨찾기 기능
        const favoriteButton = $('#favoriteToggleButton');
        const recipeId = favoriteButton.data('recipe-id');

        if (recipeId && favoriteButton.length > 0) {
            const ajaxHeaders = {
                'Content-Type': 'application/json'
            };
            checkFavoriteStatus(recipeId);

            // 버튼 클릭 이벤트 핸들러
            favoriteButton.on('click', function() {
                const isCurrentlyFavorited = $(this).data('is-favorited');
                if (isCurrentlyFavorited) {
                    removeRecipeFromFavorites(recipeId);
                } else {
                    addRecipeToFavorites(recipeId);
                }
            });

            // 서버에 현재 즐겨찾기 상태를 물어보는 함수
            function checkFavoriteStatus(currentRecipeId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/favorites/recipe/status',
                    type: 'GET',
                    data: { recipeId: currentRecipeId },
                    dataType: 'json',
                    success: function(response) {
                        if (response && typeof response.isFavorited !== 'undefined') {
                            updateFavoriteButtonUI(response.isFavorited, currentRecipeId);
                        } else {
                            updateFavoriteButtonUI(false, currentRecipeId);
                        }
                    },
                    error: function(xhr, status, error) {
                        updateFavoriteButtonUI(false, currentRecipeId);
                    }
                });
            }

            // 즐겨찾기 추가 함수
            function addRecipeToFavorites(currentRecipeId) {
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
                        alert('즐겨찾기 추가 중 오류가 발생했습니다.');
                    }
                });
            }

            // 즐겨찾기 삭제 함수
            function removeRecipeFromFavorites(currentRecipeId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/favorites/recipe/remove',
                    type: 'POST',
                    headers: ajaxHeaders,
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
                        alert('즐겨찾기 삭제 중 오류가 발생했습니다.');
                    }
                });
            }

            // 버튼 UI 업데이트 함수
            function updateFavoriteButtonUI(isFavorited, currentRecipeId) {
                const button = $('#favoriteToggleButton[data-recipe-id="' + currentRecipeId + '"]');
                button.data('is-favorited', isFavorited);

                if (isFavorited) {
                    button.html('<i class="fa-solid fa-star"></i> <span>즐겨찾기됨</span>');
                    button.addClass('favorited');
                } else {
                    button.html('<i class="fa-regular fa-star"></i> <span>즐겨찾기 추가</span>');
                    button.removeClass('favorited');
                }
            }
        }
    });
    
    // 댓글 작성 함수
    function commentWrite() {
        const writer = $("#rc_commentWriter").val();
        const content = $("#rc_commentContent").val();
        const boardNo = "${rc_board.rc_boardNo}";
        const rating = $("#user_star_scoreValue").val();

        if (!content.trim()) {
            alert("댓글 내용을 입력해주세요.");
            $("#rc_commentContent").focus();
            return;
        }
        
        if (rating == 0) {
            alert("별점을 선택해주세요.");
            return;
        }

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
                window.location.reload();
            },
            error: function (xhr, status, error) {
                console.error("댓글 작성 실패:", error);
                alert("댓글 작성에 실패했습니다.");
            }
        });
    }
</script>
</body>
</html>
