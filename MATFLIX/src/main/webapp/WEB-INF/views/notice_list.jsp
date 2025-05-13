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
		</head>
		<style>
			.div_page ul {
				display: flex;
				list-style: none;
			}
		</style>
		<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f8f9fa;
        padding: 30px;
    }

    h1 {
        text-align: center;
        margin-bottom: 30px;
        color: #343a40;
    }

    a {
        text-decoration: none;
        color: #007bff;
    }

    a:hover {
        text-decoration: underline;
        color: #0056b3;
    }

    table {
        margin: 0 auto;
        width: 80%;
        border-collapse: collapse;
        background-color: white;
        box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
    }

    table th, table td {
        padding: 12px;
        text-align: center;
        border: 1px solid #dee2e6;
    }

    table tr:nth-child(1) {
        background-color: #343a40;
        color: white;
    }

    .div_page {
        text-align: center;
        margin-top: 20px;
    }

    .div_page ul {
        display: inline-flex;
        list-style: none;
        padding-left: 0;
    }

    .div_page li {
        margin: 0 5px;
    }

    .div_page a {
        padding: 6px 12px;
        background-color: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        color: #343a40;
    }

    .div_page a:hover {
        background-color: #007bff;
        color: white;
    }

    .paginate_button[style*='color: red;'] a {
        background-color: #007bff;
        color: white !important;
        font-weight: bold;
    }

    form#searchForm {
        text-align: center;
        margin-top: 30px;
    }

    form#searchForm select,
    form#searchForm input[type="text"],
    form#searchForm button {
        padding: 6px 10px;
        margin: 0 5px;
        font-size: 14px;
    }

    form#searchForm input[type="text"] {
        width: 200px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    form#searchForm button {
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    form#searchForm button:hover {
        background-color: #0056b3;
    }

    td[colspan="5"] {
        text-align: right;
        padding-right: 20px;
    }

    td[colspan="5"] a {
        font-weight: bold;
        color: #28a745;
        background-color: #e9f7ef;
        padding: 5px 10px;
        border-radius: 4px;
        border: 1px solid #28a745;
    }

    td[colspan="5"] a:hover {
        background-color: #28a745;
        color: white;
    }
</style>


		<body>
			<a href="main">메인으로</a>
			<h1>공지사항입니다.</h1>
			<table width="500" border="1">
				<tr>
					<th style="width: 60px;">번호</th>
					<th style="width: 100px;">이름</th>
					<th style="width: 50%;">제목</th>
					<th style="width: 120px;">날짜</th>
					<th style="width: 60px;">히트</th>
				</tr>
				<!-- 		조회결과 -->
				<!-- 		list : 모델객체에서 보낸 이름 -->
				<c:forEach var="dto" items="${list}">
					<tr>
						<td>${dto.notice_boardNo}</td>
						<td>${dto.notice_boardName}</td>
						<td><a class="move_link" href="${dto.notice_boardNo}">${dto.notice_boardTitle}</a></td>
						<td>${dto.notice_boardDate}</td>
						<td>${dto.notice_boardHit}</td>
					</tr>
				</c:forEach>
				<c:if test="${user != null && user.mf_role == 'ADMIN'}">
					<tr>
						<td colspan="5">
							<a href="notice_write_view">글작성</a>
						</td>
					</tr>
				</c:if>
			</table>

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

				<!-- Criteria 를 이용해서 키워드 값을 넘김 -->
				<input type="text" name="notice_keyword" value="${pageMaker.notice_cri.notice_keyword}">
				<!-- 전체검색중 4페이지에서 내용을 88 키워드로 검색시 안나올때 처리 -->
				<input type="hidden" name="notice_pageNum" value="1">
				<input type="hidden" name="notice_amount" value="${pageMaker.notice_cri.notice_amount}">
				<button>입력</button>
			</form>

			<div class="div_page">
				<ul>
					<c:if test="${pageMaker.notice_prev}">
						<li class="paginate_button">
							<a href="${pageMaker.notice_startPage -1}">
								[Previous]
							</a>
						</li>
					</c:if>

					<c:forEach var="num" begin="${pageMaker.notice_startPage}" end="${pageMaker.notice_endPage}">
						<li class="paginate_button" ${pageMaker.notice_cri.notice_pageNum==num ? "style='color: red;'" :""}>
							<a href="${num}">
								[${num}]
							</a>&nbsp;&nbsp;&nbsp;&nbsp;
						</li>
					</c:forEach>

					<c:if test="${pageMaker.notice_next}">
						<li class="paginate_button">
							<a href="${pageMaker.notice_endPage +1}">
								[Next]
							</a>
						</li>
					</c:if>
				</ul>
			</div>

			<form id="actionForm" action="notice_list" method="get">
				<input type="hidden" name="notice_pageNum" value="${pageMaker.notice_cri.notice_pageNum}">
				<input type="hidden" name="notice_amount" value="${pageMaker.notice_cri.notice_amount}">
				<!-- 페이징 검색시 페이지번호를 클릭할때 필요한 파라미터 -->
				<input type="hidden" name="notice_type" value="${pageMaker.notice_cri.notice_type}">
				<input type="hidden" name="notice_keyword" value="${pageMaker.notice_cri.notice_keyword}">
			</form>

		</body>

		</html>
		<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
		<script>
			var actionForm = $("#actionForm");
			// 페이지번호 처리
			$(".paginate_button a").on("click", function (e) {
				e.preventDefault();
				console.log("click~!!!");
				console.log("@# href =>" + $(this).attr("href"));
				actionForm.find("input[name='notice_pageNum']").val($(this).attr("href"));

				// actionForm.submit();

				//버그 처리(게시글 클릭후 뒤로가기 누른후 다른 페이지 클릭할때 content_view가 작동되는것을 해결)
				actionForm.attr("action", "notice_list").submit();
			}); // end of paginate_button click

			// 게시글 처리
			$(".move_link").on("click", function (e) {
				e.preventDefault();
				console.log("move_link click~~!!!");
				console.log("@# href =>" + $(this).attr("href"));
				var targetBno = $(this).attr("href");

				//버그 처리
				var bno= actionForm.find("input[name='notice_boardNo']").val();
				if (bno != "") {
					actionForm.find("input[name='notice_boardNo']").remove();
				}
				// "content_view?boardNo=${dto.boardNo}" 를 actionForm로 처리
				actionForm.append("<input type='hidden' name='notice_boardNo' value='" + targetBno + "'>");
				// 컨트롤러에 content_view 로 찾아감
				actionForm.attr("action","notice_content_view").submit();
				
			}); // end of move_link click

			var searchForm = $("#searchForm");
			
			$("#searchForm button").on("click", function () {
				// alert("검색");

				// 키워드 입력 받을 조건
				if (searchForm.find("option:selected").val() != ""&& !searchForm.find("input[name='notice_keyword']").val()) {
					alert("키워드를 입력하세요.");
					return false;
				}

				searchForm.attr("action", "notice_list").submit();
			}); // end of searchForm click

			// type 콤보박스 변경
			$("#searchForm select").on("change", function () {
				if (searchForm.find("option:selected").val() == "") {
					// 키워드를 널값으로 변경
					searchForm.find("input[name='notice_keyword']").val("");
				}
			}); // end of searchForm click 2
		</script>