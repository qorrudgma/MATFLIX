<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>닉네임 변경</title>
</head>
<body>
    <h2>닉네임 변경</h2>
    <form action="${pageContext.request.contextPath}/nickname" method="post">
        <input type="hidden" name="mf_id" value="${mf_id}">
        <label for="mf_nickname">새 닉네임:</label>
        <input type="text" id="mf_nickname" name="mf_nickname" required>
        <input type="submit" value="변경">
    </form>
</body>
</html>
