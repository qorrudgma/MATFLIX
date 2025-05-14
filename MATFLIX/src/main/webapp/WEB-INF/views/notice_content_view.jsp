<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<%
    TeamDTO user = (TeamDTO) session.getAttribute("user");
%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 공지사항 상세</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 헤더 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <!-- 공지사항 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
    <style>
        .uploadResult {
            width: 100%;
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
        }

        .uploadResult ul {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            padding: 0;
            margin: 0;
        }

        .uploadResult ul li {
            list-style: none;
            padding: 10px;
            background-color: white;
            border-radius: 4px;
            border: 1px solid #ddd;
        }

        .uploadResult ul li img {
            width: 100px;
            border-radius: 4px;
        }
    </style>
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="notice-container">
        <div class="notice-title">
            <h1>공지사항 상세</h1>
        </div>
        
        <div class="notice-detail">
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
                            <c:if test="${user != null && user.mf_role == 'ADMIN'}">
                                <textarea name="notice_boardContent" rows="10">${content_view.notice_boardContent}</textarea>
                            </c:if>
                            <c:if test="${user != null && user.mf_role == 'USER'}">
                                <div style="white-space: pre-wrap;">${content_view.notice_boardContent}</div>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <c:if test="${user != null && user.mf_role == 'ADMIN'}">
                                <input type="submit" value="수정" class="notice-btn">
                            </c:if>
                            &nbsp;&nbsp;<input type="submit" value="목록보기" formaction="notice_list" class="notice-btn notice-btn-secondary">
                            <c:if test="${user != null && user.mf_role == 'ADMIN'}">
                                &nbsp;&nbsp;<input type="submit" value="삭제" formaction="notice_delete" class="notice-btn" style="background-color: #e74c3c;">
                            </c:if>
                        </td>
                    </tr>
                </form>
            </table>
        </div>
    </div>
</body>
</html>