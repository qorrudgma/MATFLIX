<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
   <meta charset="UTF-8">
   <title>Insert title here</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/list.css">
</head>
<style>
   .div_page ul {
      display: flex;
      list-style: none;
   }
</style>

<body>
   <table width="700" border="1">
      <tr>
         <td>번호</td>
         <td>이름(닉네임이 나오게 수정하기)</td>
         <td>제목</td>
         <td>날짜</td>
         <td>히트</td>
      </tr>
      <c:forEach var="dto" items="${list}">
         <tr>
            <td>${dto.boardNo}</td>
            <td>${dto.boardName}</td>
            <td>
               <%-- ${dto.boardTitle} --%>
                  <a class="move_link" href="${dto.boardNo}">${dto.boardTitle}</a>
            </td>
            <td>${dto.boardDate}</td>
            <td>${dto.boardHit}</td>
         </tr>
      </c:forEach>
      <tr>
         <td colspan="5">
            <a href="write_view">글작성</a>
         </td>
      </tr>
   </table>

   <form method="get" id="searchForm">
      <select name="type">
         <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected':''}"/>>전체 목록조회</option>
         <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected':''}"/>>제목</option>
         <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected':''}"/>>내용</option>
         <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected':''}"/>>작성자</option>
         <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected':''}"/>>제목 + 내용</option>
         <option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected':''}"/>>제목 + 작성자</option>
         <option value="CW" <c:out value="${pageMaker.cri.type eq 'TCW' ? 'selected':''}"/>>내용 + 작성자</option>
      </select>

      <input type="text" name="keyword" value="${pageMaker.cri.keyword}">
      <input type="hidden" name="pageNum" value="1">
      <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
      <button>입력</button>
   </form>

<!--   <h3>${pageMaker}</h3>-->
   <div class="div_page">
      <ul>
         <c:if test="${pageMaker.prev}">
            <li class="paginate_button">
               <a href="${pageMaker.startPage -1}">
                  [Previous]
               </a>
            </li>
         </c:if>

         <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
            <li class="paginate_button" ${pageMaker.cri.pageNum==num ? "style='color: red;'" :""}>
               <a href="${num}">
                  [${num}]
               </a>&nbsp;&nbsp;&nbsp;&nbsp;
            </li>
         </c:forEach>

         <c:if test="${pageMaker.next}">
            <li class="paginate_button">
               <a href="${pageMaker.endPage +1}">
                  [Next]
               </a>
            </li>
         </c:if>
      </ul>
   </div>

   <form id="actionForm" action="list" method="get">
      <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
      <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
      <input type="hidden" name="type" value="${pageMaker.cri.type}">
      <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
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
      actionForm.find("input[name='pageNum']").val($(this).attr("href"));

      //버그 처리(게시글 클릭후 뒤로가기 누른후 다른 페이지 클릭할때 content_view가 작동되는것을 해결)
      actionForm.attr("action", "list").submit();
   }); // end of paginate_button click

   // 게시글 처리
   $(".move_link").on("click", function (e) {
      e.preventDefault();
      console.log("move_link click~~!!!");
      console.log("@# href =>" + $(this).attr("href"));
      var targetBno = $(this).attr("href");

      var bno= actionForm.find("input[name='boardNo']").val();
      if (bno != "") {
         actionForm.find("input[name='boardNo']").remove();
      }
      actionForm.append("<input type='hidden' name='boardNo' value='" + targetBno + "'>");
      actionForm.attr("action","content_view").submit();
      
   }); // end of move_link click

   var searchForm = $("#searchForm");

   $("#searchForm button").on("click", function () {
      // 키워드 입력 받을 조건
      if (searchForm.find("option:selected").val() != ""&& !searchForm.find("input[name='keyword']").val()) {
         alert("키워드를 입력하세요.");
         return false;
      }

      searchForm.attr("action", "list").submit();
   }); // end of searchForm click

   // type 콤보박스 변경
   $("#searchForm select").on("change", function () {
      if (searchForm.find("option:selected").val() == "") {
         // 키워드를 널값으로 변경
         searchForm.find("input[name='keyword']").val("");
      }
   }); // end of searchForm click 2
</script>