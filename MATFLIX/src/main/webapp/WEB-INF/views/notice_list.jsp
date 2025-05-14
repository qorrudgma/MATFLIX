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
    <title>MATFLIX - 공지사항</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 헤더 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <!-- 공지사항 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
    <!-- 폰트어썸 아이콘 (선택사항) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<style>
    .div_page ul {
        display: flex;
        list-style: none;
    }
</style>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="notice-container">
        <!-- 장식 요소 -->
        <div class="notice-decoration notice-decoration-1"></div>
        <div class="notice-decoration notice-decoration-2"></div>
        <div class="notice-decoration notice-decoration-3"></div>
        
        <div class="notice-title">
            <h1>공지사항</h1>
        </div>
        
        <!-- 검색 폼 - 기존 코드 유지 -->
        <form method="get" id="searchForm">
            <select name="notice_type">
                <option value="" <c:out value="${pageMaker.notice_cri.notice_type == null ? 'selected':''}"/>>전체</option>
                <option value="T" <c:out value="${pageMaker.notice_cri.notice_type eq 'T' ? 'selected':''}"/>>제목</option>
                <option value="C" <c:out value="${pageMaker.notice_cri.notice_type eq 'C' ? 'selected':''}"/>>내용</option>
                <option value="W" <c:out value="${pageMaker.notice_cri.notice_type eq 'W' ? 'selected':''}"/>>작성자</option>
                <option value="TC" <c:out value="${pageMaker.notice_cri.notice_type eq 'TC' ? 'selected':''}"/>>제목 or 내용</option>
                <option value="TW" <c:out value="${pageMaker.notice_cri.notice_type eq 'TW' ? 'selected':''}"/>>제목 or 작성자</option>
                <option value="TCW" <c:out value="${pageMaker.notice_cri.notice_type eq 'TCW' ? 'selected':''}"/>>제목 or 내용 or 작성자</option>
            </select>
            <input type="text" name="notice_keyword" value="${pageMaker.notice_cri.notice_keyword}" placeholder="검색어를 입력하세요">
            <input type="hidden" name="notice_pageNum" value="1">
            <input type="hidden" name="notice_amount" value="${pageMaker.notice_cri.notice_amount}">
            <button>검색</button>
        </form>
        
        <!-- 공지사항 테이블 - 기존 코드에 클래스만 추가 -->
        <table width="500" border="1" class="notice-table">
            <tr>
                <th style="width: 60px;">번호</th>
                <th style="width: 100px;">이름</th>
                <th style="width: 50%;">제목</th>
                <th style="width: 120px;">날짜</th>
                <th style="width: 60px;">조회수</th>
            </tr>
            <c:forEach var="dto" items="${list}" varStatus="status">
                <tr style="--row-index: ${status.index}">
                    <td>${dto.notice_boardNo}</td>
                    <td>${dto.notice_boardName}</td>
                    <td><a class="move_link notice-link" href="${dto.notice_boardNo}">${dto.notice_boardTitle}</a></td>
                    <td>${dto.notice_boardDate}</td>
                    <td>${dto.notice_boardHit}</td>
                </tr>
            </c:forEach>
            <c:if test="${user != null && user.mf_role == 'ADMIN'}">
                <tr>
                    <td colspan="5" style="text-align: right;">
                        <a href="notice_write_view" class="notice-btn">📢 공지사항 작성</a>
                    </td>
                </tr>
            </c:if>
        </table>

        <!-- 페이지네이션 - 기존 코드 유지 -->
        <div class="div_page">
            <ul>
                <c:if test="${pageMaker.notice_prev}">
                    <li class="paginate_button">
                        <a href="${pageMaker.notice_startPage -1}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                </c:if>

                <c:forEach var="num" begin="${pageMaker.notice_startPage}" end="${pageMaker.notice_endPage}">
                    <li class="paginate_button" ${pageMaker.notice_cri.notice_pageNum==num ? "style='color: red;'" :""}>
                        <a href="${num}">
                            ${num}
                        </a>
                    </li>
                </c:forEach>

                <c:if test="${pageMaker.notice_next}">
                    <li class="paginate_button">
                        <a href="${pageMaker.notice_endPage +1}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>

        <!-- 액션 폼 - 기존 코드 유지 -->
        <form id="actionForm" action="notice_list" method="get">
            <input type="hidden" name="notice_pageNum" value="${pageMaker.notice_cri.notice_pageNum}">
            <input type="hidden" name="notice_amount" value="${pageMaker.notice_cri.notice_amount}">
            <input type="hidden" name="notice_type" value="${pageMaker.notice_cri.notice_type}">
            <input type="hidden" name="notice_keyword" value="${pageMaker.notice_cri.notice_keyword}">
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script>
        var actionForm = $("#actionForm");
        // 페이지번호 처리
        $(".paginate_button a").on("click", function (e) {
            e.preventDefault();
            console.log("click~!!!");
            console.log("@# href =>" + $(this).attr("href"));
            actionForm.find("input[name='notice_pageNum']").val($(this).attr("href"));
            actionForm.attr("action", "notice_list").submit();
        });

        // 게시글 처리
        $(".move_link").on("click", function (e) {
            e.preventDefault();
            console.log("move_link click~~!!!");
            console.log("@# href =>" + $(this).attr("href"));
            var targetBno = $(this).attr("href");

            //버그 처리
            var bno = actionForm.find("input[name='notice_boardNo']").val();
            if (bno != undefined) {
                actionForm.find("input[name='notice_boardNo']").remove();
            }
            
            actionForm.append("<input type='hidden' name='notice_boardNo' value='" + targetBno + "'>");
            actionForm.attr("action", "notice_content_view").submit();
        });

        var searchForm = $("#searchForm");
        
        $("#searchForm button").on("click", function () {
            // 키워드 입력 받을 조건
            if (searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='notice_keyword']").val()) {
                alert("키워드를 입력하세요.");
                return false;
            }

            searchForm.attr("action", "notice_list").submit();
        });

        // type 콤보박스 변경
        $("#searchForm select").on("change", function () {
            if (searchForm.find("option:selected").val() == "") {
                // 키워드를 널값으로 변경
                searchForm.find("input[name='notice_keyword']").val("");
            }
        });
    </script>
</body>
</html>