<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<html>
<head>
    <title>user_rank_list</title>
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="header.jsp"/>
	<a href="${pageContext.request.contextPath}/main">
      <button type="button">메인페이지</button> 
    </a>
<!--	${user_rank_list}-->
	<c:forEach var="user" items="${user_rank_list}" varStatus="rank">
		<div>${rank.count}위</div>
		<div style="display: none;">${user.mf_no}</div>
		<a href="other_profile?mf_no=${user.mf_no}"><div>${user.mf_nickname}님</div></a>
		<div>이메일: ${user.mf_email}</div>
		<div>성별: ${user.mf_gender}</div>
		<div>가입일: ${user.mf_regdate}</div>
	</c:forEach>
	<script>
		 console.log(${user_rank_list});
	</script>
</body>
</html>