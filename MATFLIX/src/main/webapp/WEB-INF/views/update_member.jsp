<%@page import="com.lgy.TeamProject.dto.TeamDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    TeamDTO user = (TeamDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<script type="text/javascript">
	function fn_submit() {
		const pw = document.getElementById("mf_pw").value;
		const pwChk = document.getElementById("mf_pw_chk").value;

		if (pw !== pwChk) {
			alert("비밀번호가 일치하지 않습니다.");
			return;
		}

		const form = document.getElementById("user_update");

		if (!form.checkValidity()) {
			form.reportValidity();
			return;
		}

		const formData = $("#user_update").serialize();

		$.ajax({
			type: "post",
			data: formData,
			url: "update_member_ok",
			success: function(data) {
				alert("수정이 정상적으로 처리되었습니다.");
				location.href = "my_page?mf_id=<%= user.getMf_id() %>";
			},
			error: function() {
				alert("오류 발생");
			}
		});
	}
</script>
<script>
	function checkPasswordMatch() {
		const pw = document.getElementById("mf_pw").value;
		const pwChk = document.getElementById("mf_pw_chk").value;
		const msg = document.getElementById("pw_match_msg");

		if (pwChk.length === 0) {
			msg.textContent = "";
			return;
		}

		if (pw === pwChk) {
			msg.textContent = "비밀번호가 일치합니다.";
			msg.style.color = "green";
		} else {
			msg.textContent = "비밀번호가 일치하지 않습니다.";
			msg.style.color = "red";
		}
	}
</script>
</head>
<body>
	<h2>회원정보 수정</h2>
	<form id="user_update" action="update_member_ok" method="post">
		<table>
			<tr>
				<td>이름:</td>
				<td>
					<input type="text" id="mf_name" name="mf_name" value="<%=user.getMf_name()%>"
						required maxlength="20"
						pattern="^[a-z가-힣]+$"
						title="소문자, 한글만 입력 가능합니다."
						oninvalid="this.setCustomValidity('올바른 이름 형식이 아닙니다. 소문자/한글만 입력하세요.')"
						oninput="this.setCustomValidity('')">
				</td>
			</tr>
			<tr>
				<td>비밀번호:</td>
				<td>
					<input type="password" id="mf_pw" name="mf_pw" required>
				</td>
			</tr>
			<tr>
				<td>비밀번호 확인:</td>
				<td>
					<input type="password" id="mf_pw_chk" name="mf_pw_chk" required
						oninput="checkPasswordMatch()">
					<div id="pw_match_msg"></div>
				</td>
			</tr>
			<tr>
				<td>이메일:</td>
				<td>
					<input type="email" name="mf_email" value="<%=user.getMf_email()%>" required
						placeholder="example@email.com"
						pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
						oninvalid="this.setCustomValidity('올바른 이메일 주소 형식으로 입력해주세요.')"
						oninput="this.setCustomValidity('')">
				</td>
			</tr>
			<tr>
				<td>전화번호:</td>
				<td>
					<input type="tel" name="mf_phone" value="<%=user.getMf_phone()%>" required
						placeholder="010-0000-0000"
						pattern="^010-\d{4}-\d{4}$"
						oninvalid="this.setCustomValidity('010-0000-0000 형식으로 입력해주세요.')"
						oninput="this.setCustomValidity('')">
				</td>
			</tr>
			<tr>
				<td>생년월일:</td>
				<td>
					<input type="date" name="mf_birth" value="<%=user.getMf_birth()%>" required>
				</td>
			</tr>
			<tr>
				<td>성별:</td>
				<td>
					<select name="mf_gender" required>
						<option value="m" <%= "m".equals(user.getMf_gender()) ? "selected" : "" %>>남성</option>
						<option value="f" <%= "f".equals(user.getMf_gender()) ? "selected" : "" %>>여성</option>
					</select>
				</td>
			</tr>
		</table>

		<br>
		<input type="button" onclick="fn_submit()" value="수정">
		<button type="button" onclick="location.href='my_page?mf_id=<%= user.getMf_id() %>'">취소</button>
	</form>
</body>
</html>
