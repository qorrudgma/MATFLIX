<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ page import="com.boot.dto.TeamDTO" %>
	<%
		TeamDTO user = (TeamDTO) session.getAttribute("user");
	%>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Insert title here</title>
			<style>
				.uploadResult {
					width: 100%;
					background-color: gray;
				}

				.uploadResult ul {
					display: flex;
					flex-flow: row;
				}

				.uploadResult ul li {
					list-style: none;
					padding: 10px;
				}

				.uploadResult ul li img {
					width: 100px;
				}
			</style>
			<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
		</head>

		<body>
			<jsp:include page="header.jsp" />
			<table width="500" border="1">
				<form id="actionForm" method="post" action="notice_modify">
					<input type="hidden" name="notice_boardNo" value="${pageMaker.notice_boardNo}">
					<input type="hidden" name="notice_pageNum" value="${pageMaker.notice_pageNum}">
					<input type="hidden" name="notice_amount" value="${pageMaker.notice_amount}">
					<tr>
						<td>번호</td>
						<td>
							${content_view.notice_boardNo}
						</td>
					</tr>
					<tr>
						<td>히트</td>
						<td>
							${content_view.notice_boardHit}
						</td>
					</tr>
					<tr>
						<td>이름</td>
						<td>
							<%-- ${content_view.notice_boardName} --%>
							<c:if test="${user != null && user.mf_role == 'ADMIN'}">
								<input type="text" name="notice_boardName" value="${content_view.notice_boardName}">
							</c:if>
							<c:if test="${user != null && user.mf_role == 'USER'}">
								${content_view.notice_boardName}
							</c:if>
						</td>
					</tr>
					<tr>
						<td>제목</td>
						<td>
							<%-- ${content_view.notice_boardTitle} --%>
							<c:if test="${user != null && user.mf_role == 'ADMIN'}">
								<input type="text" name="notice_boardTitle" value="${content_view.notice_boardTitle}">
							</c:if>
							<c:if test="${user != null && user.mf_role == 'USER'}">
								${content_view.notice_boardTitle}
							</c:if>
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td>
							<%-- ${content_view.notice_boardContent} --%>
							<c:if test="${user != null && user.mf_role == 'ADMIN'}">
								<input type="text" name="notice_boardContent" value="${content_view.notice_boardContent}">
							</c:if>
							<c:if test="${user != null && user.mf_role == 'USER'}">
								${content_view.notice_boardContent}
							</c:if>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<c:if test="${user != null && user.mf_role == 'ADMIN'}">
								<input type="submit" value="수정">
							</c:if>
							&nbsp;&nbsp;<input type="submit" value="목록보기" formaction="notice_list">
							<c:if test="${user != null && user.mf_role == 'ADMIN'}">
								&nbsp;&nbsp;<input type="submit" value="삭제" formaction="notice_delete">
							</c:if>
						</td>
					</tr>
				</form>
			</table>
		</body>

		</html>