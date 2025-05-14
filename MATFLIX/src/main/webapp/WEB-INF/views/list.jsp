<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>MATFLIX - 게시판</title>
   <!-- 공통 CSS -->
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
   <!-- 게시판 CSS -->
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/list.css">
   <!-- 폰트어썸 아이콘 -->
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
   <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
   <jsp:include page="header.jsp" />
   
   <div class="content">
       <h2>레시피 커뮤니티</h2>
       <p>맛플릭스 회원들과 함께 레시피와 요리 경험을 공유해보세요!</p>
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

          <input type="text" name="keyword" value="${pageMaker.cri.keyword}" placeholder="검색어를 입력하세요">
          <input type="hidden" name="pageNum" value="1">
          <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
          <button>검색</button>
       </form>
       <table>
          <tr>
             <th>번호</th>
             <th>이름</th>
             <th>제목</th>
             <th>날짜</th>
             <th>조회수</th>
          </tr>
          <c:forEach var="dto" items="${list}">
             <tr>
                <td>${dto.boardNo}</td>
                <td>${dto.boardName}</td>
                <td>
                   <a class="move_link" href="${dto.boardNo}">${dto.boardTitle}</a>
                </td>
                <td>${dto.boardDate}</td>
                <td>${dto.boardHit}</td>
             </tr>
          </c:forEach>
          <tr>
             <td colspan="5" class="write-btn-cell">
                <% if(user != null){ %>
                    <a href="write_view" class="write-btn">글작성</a>
                <% }else{ %>
                    <a href="#" id="write_a" class="write-btn">글작성</a>
                <% } %>
             </td>
          </tr>
       </table>



       <div class="div_page">
          <ul>
             <c:if test="${pageMaker.prev}">
               <a href="${pageMaker.startPage -1}">
                	<li class="paginate_button">
                      이전
				     </li>
				  </a>
             </c:if>

             <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
               	<a href="${num}">
                	<li class="paginate_button ${pageMaker.cri.pageNum==num ? 'active' :''}">
                      ${num}
               		</li>
               	</a>
             </c:forEach>

             <c:if test="${pageMaker.next}">
                <a href="${pageMaker.endPage +1}">
    	           <li class="paginate_button">
                      다음
	               </li>
                </a>
             </c:if>
          </ul>
       </div>

       <form id="actionForm" action="list" method="get">
          <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
          <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
          <input type="hidden" name="type" value="${pageMaker.cri.type}">
          <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
       </form>
   </div>
   
   <jsp:include page="footer.jsp" />

<script>
   // 변수
   <% if (user != null) { %>
      var sessionUserNo = <%= user.getMf_no() %>;
   <% } else { %>
      var sessionUserNo = null;
   <% } %>

    $("#write_a").on("click", function(e){
        e.preventDefault();
        alert("로그인 후 이용 가능한 콘텐츠 입니다.");
    });
    
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
      actionForm.append("<input type='hidden' name='mf_no' value='" + sessionUserNo + "'>");
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
</body>
</html>