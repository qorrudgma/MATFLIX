<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<html>
<head>
    <title>${dto.rc_name} - 레시피 상세</title>
    <style>
        .recipe-container { max-width: 800px; margin: 0 auto; font-family: sans-serif; }
        .recipe-header img { max-width: 100%; border-radius: 10px; }
        .section-title { font-weight: bold; font-size: 1.2em; margin-top: 20px; border-bottom: 1px solid #ccc; }
        .ingredients, .steps { margin-top: 10px; }
        .step img { max-width: 100%; margin-top: 10px; }
    </style>
</head>
<body>
<div class="recipe-container">

    <!-- 대표 이미지 -->
    <div class="recipe-header">
        <h1>${dto.rc_name}</h1>
        <c:if test="${img_list != null}">
            <img src="/upload/${img_list.uploadPath}/${img_list.uuid}_${img_list.fileName}" alt="${dto.rc_name}" />
        </c:if>
        <p>등록일: ${dto.rc_created_at}</p>
        <p>카테고리: ${dto.rc_category1_id} / ${dto.rc_category2_id}</p>
        <p>소요시간: ${dto.rc_cooking_time}분</p>
        <p>난이도: ${dto.rc_difficulty}</p>
        <p>태그: ${dto.rc_tag}</p>
    </div>

    <div class="description">
        <p class="section-title">레시피 설명</p>
        <p>${dto.rc_description}</p>
    </div>

    <!-- 재료 리스트 -->
    <div class="ingredients">
        <p class="section-title">재료</p>
        <ul>
            <c:forEach var="ing" items="${ing_list}">
                <li>${ing.rc_ingredient_name} - ${ing.rc_ingredient_amount}</li>
            </c:forEach>
        </ul>
    </div>

    <!-- 요리 순서 + 이미지: course_list + course_img_list 조합 -->
    <div class="steps">
        <p class="section-title">요리 순서</p>
        <c:forEach var="step" items="${course_list}" varStatus="status">
            <div class="step">
                <p><strong>Step ${status.index + 1}:</strong> ${step.rc_course_description}</p>
                <c:forEach var="img" items="${course_img_list}">
                    <c:if test="${img.rc_recipe_id == dto.rc_recipe_id && img.image && img.fileName.contains('_step' + (status.index + 1))}">
                        <img src="/upload/${img.uploadPath}/${img.uuid}_${img.fileName}" alt="Step ${status.index + 1}" />
                    </c:if>
                </c:forEach>
            </div>
        </c:forEach>
    </div>

    <!-- 팁 -->
    <div class="tip">
        <p class="section-title">요리 팁</p>
        <p>${dto.rc_tip}</p>
    </div>

    <div>
        <input type="text" id="rc_commentWriter" placeholder="작성자">
        <input type="text" id="rc_commentContent" placeholder="내용">
        <button onclick="commentWrite()">댓글작성</button>
    </div>

    <div id="comment-list">
        <table>
            <tr>
                <th>댓글번호</th>
                <th>작성자</th>
                <th>내용</th>
                <th>작성시간</th>
            </tr>
            <c:forEach items="${commentList}" var="comment">
                <tr>
                    <td>${comment.rc_commentNo}</td>
                    <td>${comment.rc_commentWriter}</td>
                    <td>${comment.rc_commentContent}</td>
                    <td>${comment.rc_commentCreatedTime}</td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>
</body>
<script>
const commentWrite = () => {
    const writer = document.getElementById("rc_commentWriter").value;
    const content = document.getElementById("rc_commentContent").value;
    const no = "${rc_board.rc_boardNo}";

    $.ajax({
        type: "post"
        , data: {
            rc_commentWriter: writer
            , rc_commentContent: content
            , rc_boardNo: no
        }
        , url: "/rc_comment/save"
        , success: function (commentList) {
            alert("댓글이 작성되었습니다.");
            console.log("작성 성공");
            console.log(commentList);

            let output = "<table>";
            output += "<tr><th>댓글번호</th>";
            output += "<th>작성자</th>";
            output += "<th>내용</th>";
            output += "<th>작성시간</th></tr>";
            for (let i in commentList) {
                output += "<tr>";
                output += "<td>" + commentList[i].rc_commentNo + "</td>";
                output += "<td>" + commentList[i].rc_commentWriter + "</td>";
                output += "<td>" + commentList[i].rc_commentContent + "</td>";
                output += "<td>" + commentList[i].rc_commentCreatedTime + "</td>";
                output += "</tr>";
            }
            output += "</table>";
            console.log("@# output=>" + output);

            document.getElementById("comment-list").innerHTML = output;
        }
        , error: function () {
            console.log("실패");
        }
    });//end of ajax
}//end of script
</script>

</html>