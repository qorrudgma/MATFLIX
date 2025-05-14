<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<% request.setAttribute("user", user); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 글쓰기</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 글쓰기 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/write_view.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script type="text/javascript">
        function fn_submit() {
            var formData = $("#frm").serialize();
            
            $.ajax({
                 type:"post"
                ,data:formData
                ,url:"write"
                ,success: function(data) {
                    alert("저장완료");
                    location.href="list";
                }
                ,error: function() {
                    alert("오류발생");
                }
            });
        }
    </script>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="content">
        <h2>새 글 작성</h2>
        <p>맛플릭스 커뮤니티에 새 글을 작성해보세요!</p>
        
        <table>
            <form id="frm" method="post" action="write">
                <input type="hidden" name="mf_no" value="${user.mf_no}">
                <tr>
                    <td>이름</td>
                    <td>
                        <input type="text" name="boardName" value="${user.mf_nickname}" size="50" readonly>
                    </td>
                </tr>
                <tr>
                    <td>제목</td>
                    <td>
                        <input type="text" name="boardTitle" size="50" placeholder="제목을 입력하세요">
                    </td>
                </tr>
                <tr>
                    <td>내용</td>
                    <td>
                        <textarea rows="10" name="boardContent" placeholder="내용을 입력하세요"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="button-row">
                        <button type="submit">등록</button>
                        <a href="list">목록보기</a>
                    </td>
                </tr>
            </form>
        </table>
    </div>
    
    <jsp:include page="footer.jsp" />
    
</body>
</html>