<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>나의 레시피</title>
    <style>
        .recipe_grid {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
        }
        .recipe_card {
            width: 200px;
            border: 1px solid #ddd;
            padding: 8px;
            border-radius: 8px;
            text-align: center;
        }
        .recipe_card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<a href="main">메인으로 이동</a>
<a href="profile">프로필로 이동</a>

    <div class="recipe_grid">
        <c:forEach var="recipe" items="${my_recipe}">
            <a href="recipe_content_view?rc_recipe_id=${recipe.rc_recipe_id}">
                <div class="recipe_card">
                    <c:set var="imageShown" value="false" scope="page" />
                    <c:forEach var="attach" items="${my_recipe_attach}">
                        <c:if test="${!imageShown && attach.rc_recipe_id == recipe.rc_recipe_id && not empty attach.fileName}">
                            <img src="/upload/${attach.uploadPath}/${attach.uuid}_${attach.fileName}" alt="${recipe.rc_name}" />
                            <c:set var="imageShown" value="true" scope="page" />
                        </c:if>
                    </c:forEach>
                    <p>
                        ${recipe.rc_recipe_id}. ${recipe.rc_name} <br/>
                        (${recipe.rc_created_at})
                    </p>
                </div>
            </a>
        </c:forEach>
    </div>
</body>
</html>
