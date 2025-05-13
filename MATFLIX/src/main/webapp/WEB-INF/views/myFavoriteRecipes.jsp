<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 즐겨찾는 레시피</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; color: #333; }
        .container { max-width: 800px; margin: auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #5cb85c; }
        .favorite-list { list-style-type: none; padding: 0; }
        .favorite-item { border: 1px solid #ddd; margin-bottom: 10px; padding: 15px; border-radius: 5px; background-color: #f9f9f9; display: flex; justify-content: space-between; align-items: center; }
        .favorite-item h3 { margin: 0 0 10px 0; }
        .favorite-item p { margin: 5px 0; font-size: 0.9em; color: #555; }
        .favorite-item .actions button {
            background-color: #d9534f; color: white; border: none; padding: 8px 12px;
            border-radius: 4px; cursor: pointer; font-size: 0.9em;
        }
        .favorite-item .actions button:hover { background-color: #c9302c; }
        .no-favorites { text-align: center; color: #777; padding: 20px; }
        .recipe-link { color: #337ab7; text-decoration: none; font-weight: bold;}
        .recipe-link:hover { text-decoration: underline; }
        .timestamp { font-size: 0.8em; color: #888; }
    </style>
</head>
<body>
<div class="container">
    <jsp:include page="header.jsp" />
    <h1>나의 즐겨찾는 레시피</h1>

    <c:if test="${not empty errorMessage}">
        <p style="color: red; text-align: center;">${errorMessage}</p>
    </c:if>

    <ul class="favorite-list">
        <c:choose>
            <c:when test="${not empty favorites && fn:length(favorites) > 0}">
                <c:forEach var="fav" items="${favorites}">
                    <li class="favorite-item" id="favorite-item-${fav.recipeId}">
                        <div>
							<h3>
                                <a href="${pageContext.request.contextPath}/recipe_content_view?rc_recipe_id=${fav.recipeId}" class="recipe-link">
							        레시피 ID: ${fav.recipeId}
							    </a>
							</h3>

                            <c:if test="${not empty fav.createdAt}">
                                <p class="timestamp">
                                    즐겨찾기 추가일:
                                    <fmt:formatDate value="${fav.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </p>
                            </c:if>
                        </div>
                        <div class="actions">
                            <button onclick="removeFavorite(${fav.recipeId})">삭제</button>
                        </div>
                    </li>	
                </c:forEach>
            </c:when>
            <c:otherwise>
                <li class="no-favorites">즐겨찾기한 레시피가 없습니다.</li>
            </c:otherwise>
        </c:choose>
    </ul>
</div>

<script>
    async function removeFavorite(recipeId) {
        if (!confirm('이 레시피를 즐겨찾기에서 삭제하시겠습니까?')) {
            return;
        }

        try {
            const response = await fetch('/favorites/recipe/remove', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ recipeId: recipeId })
            });

            const result = await response.json();

            if (response.ok && result.success) {
                alert(result.message || '즐겨찾기에서 삭제되었습니다.');
                const itemToRemove = document.getElementById('favorite-item-' + recipeId);
                if (itemToRemove) {
                    itemToRemove.remove();
                }

                // 남은 항목이 없다면 메시지 출력
                if (document.querySelectorAll('.favorite-item').length === 0) {
                    const list = document.querySelector('.favorite-list');
                    list.innerHTML = '<li class="no-favorites">즐겨찾기한 레시피가 없습니다.</li>';
                }

            } else {
                alert(result.message || '즐겨찾기 삭제에 실패했습니다.');
            }
        } catch (error) {
            console.error('Error removing favorite:', error);
            alert('즐겨찾기 삭제 중 오류가 발생했습니다.');
        }
    }
</script>
</body>
</html>
