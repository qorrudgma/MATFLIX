<%@page import="com.lgy.TeamProject.dto.TeamDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%  TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<script type="text/javascript">
function checkPassword() {
	const formData = $("#user_pw_check").serialize();

	$.ajax({
		type: "POST",
		url: "${pageContext.request.contextPath}/member_check_ok",  // Spring Boot 컨트롤러 경로로 수정
		data: formData,
		success: function(response) {
			if (response === "available") {
				alert("비밀번호 확인 완료.");
				location.href = "${pageContext.request.contextPath}/mem_update?mf_id=" + $("input[name='mf_id']").val();  // URL 수정
			} else {
				alert("비밀번호가 일치하지 않습니다.");
			}
		},
		error: function() {
			alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
		}
	});
}
</script>
</head>
<body>
	<form id="user_pw_check">
		비밀번호 입력 :
		<input type="password" name="mf_pw">
		<input type="hidden" name="mf_id" value="${user.mf_id}">  <!-- EL 표현식으로 수정 -->
		<button type="button" onclick="checkPassword()">입력</button>
	</form>
</body>
</html>
