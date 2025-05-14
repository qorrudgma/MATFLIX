<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 레시피 목록</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 레시피 목록 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_board.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="content">
        <!-- 장식 요소 추가 -->
        <div class="decoration-element one"></div>
        <div class="decoration-element two"></div>
        <div class="decoration-element three"></div>
        
        <h2>레시피 목록</h2>
        <p>다양한 레시피를 찾아보고 나만의 요리를 시작해보세요!</p>
        
        <!-- 검색창 -->
        <form method="get" id="searchForm">
            <select name="rc_type">
                <option value="" <c:out value="${pageMaker.cri.rc_type == null ? 'selected':''}"/>>전체</option>
                <option value="T" <c:out value="${pageMaker.cri.rc_type eq 'T' ? 'selected':''}"/>>제목</option>
                <option value="C" <c:out value="${pageMaker.cri.rc_type eq 'C' ? 'selected':''}"/>>내용</option>
                <option value="TC" <c:out value="${pageMaker.cri.rc_type eq 'TC' ? 'selected':''}"/>>제목 or 내용</option>
            </select>

            <input type="text" name="rc_keyword" value="${pageMaker.cri.rc_keyword}" placeholder="검색어를 입력하세요">
            <input type="hidden" name="rc_pageNum" value="1">
            <input type="hidden" name="rc_amount" value="${pageMaker.cri.rc_amount}">
            <button><i class="fas fa-search"></i> 검색</button>
        </form>
        
        <!-- 레시피 그리드 -->
        <div class="recipe_grid">
            <c:forEach var="recipe" items="${recipe_list_all}" varStatus="status">
                <c:set var="recipe_id" value="${recipe.rc_recipe_id}" />
                <a href="recipe_content_view?rc_recipe_id=${recipe.rc_recipe_id}" class="recipe_card" style="--card-index: ${status.index}">
                    <div class="recipe_image_container">
                        <c:set var="found_image" value="false" />
                        <c:forEach var="attach" items="${file_list_all}">
                            <c:if test="${!found_image && attach.rc_recipe_id == recipe_id && attach.image}">
                                <img src="/upload/${attach.uploadPath}/${attach.uuid}_${attach.fileName}" alt="${recipe.rc_name}" />
                                <c:set var="found_image" value="true" />
                            </c:if>
                        </c:forEach>
                        <c:if test="${!found_image}">
                            <img src="${pageContext.request.contextPath}/images/default-recipe.jpg" alt="${recipe.rc_name}" />
                        </c:if>
                    </div>

                    <div class="recipe_content">
                        <p>${recipe.rc_name}</p>
                        
                        <div class="recipe_author">
                            <i class="fas fa-user"></i>
                            <c:forEach var="mem" items="${mem_list}">
                                <c:if test="${mem.mf_no == recipe.mf_no}">
                                    ${mem.mf_nickname}
                                </c:if>
                            </c:forEach>
                        </div>
                        
                        <!-- 평균 별점 표시 -->
                        <c:if test="${not empty recipe.star_score}">
                            <div class="star-display">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= recipe.star_score}">
                                            &#9733; <!-- filled star -->
                                        </c:when>
                                        <c:when test="${i - 1 < recipe.star_score && recipe.star_score < i}">
                                            &#9733; <!-- half star로 대체할 수도 있음 -->
                                        </c:when>
                                        <c:otherwise>
                                            <span class="empty">&#9733;</span> <!-- empty star -->
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span style="font-size: 14px; color: var(--light-text);">(${recipe.star_score}점)</span>
                            </div>
                        </c:if>
                    </div>
                </a>
            </c:forEach>
            
            <c:if test="${empty recipe_list_all}">
                <div style="grid-column: 1 / -1; text-align: center; padding: 50px 0;">
                    <i class="fas fa-utensils" style="font-size: 48px; color: #ddd; margin-bottom: 20px;"></i>
                    <p>등록된 레시피가 없습니다.</p>
                </div>
            </c:if>
        </div>

        <!-- 페이지네이션 -->
        <div class="div_page">
            <ul>
                <c:if test="${pageMaker.rc_prev}">
                    <li class="paginate_button">
                        <a href="${pageMaker.rc_startPage -1}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                </c:if>

                <c:forEach var="num" begin="${pageMaker.rc_startPage}" end="${pageMaker.rc_endPage}">
                    <li class="paginate_button" ${pageMaker.cri.rc_pageNum==num ? "style='color: red;'" :""}>
                        <a href="${num}">
                            ${num}
                        </a>
                    </li>
                </c:forEach>

                <c:if test="${pageMaker.rc_next}">
                    <li class="paginate_button">
                        <a href="${pageMaker.rc_endPage +1}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
        
        <!-- 레시피 등록 버튼 -->
        <button class="add_recipe_btn" onclick="location.href='insert_recipe'">
            <i class="fas fa-plus"></i>
        </button>
        
        <!-- 페이지 이동 폼 -->
        <form id="actionForm" action="recipe_board" method="get">
            <input type="hidden" name="rc_pageNum" value="${pageMaker.cri.rc_pageNum}">
            <input type="hidden" name="rc_amount" value="${pageMaker.cri.rc_amount}">
            <input type="hidden" name="rc_type" value="${pageMaker.cri.rc_type}">
            <input type="hidden" name="rc_keyword" value="${pageMaker.cri.rc_keyword}">
        </form>
    </div>
    
    <jsp:include page="footer.jsp" />

<script>
var actionForm = $("#actionForm");
    // 페이지번호 처리
    $(".paginate_button a").on("click", function (e) {
        e.preventDefault();
        console.log("click~!!!");
        console.log("@# href =>" + $(this).attr("href"));
        actionForm.find("input[name='rc_pageNum']").val($(this).attr("href"));
        actionForm.attr("action", "recipe_board").submit();
    });

    var searchForm = $("#searchForm");
    
    $("#searchForm button").on("click", function (e) {
        e.preventDefault();
        if (searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='rc_keyword']").val()) {
            alert("키워드를 입력하세요.");
            return false;
        }
        searchForm.attr("action", "recipe_board").submit();
    });

    // type 콤보박스 변경
    $("#searchForm select").on("change", function () {
        if (searchForm.find("option:selected").val() == "") {
            // 키워드를 널값으로 변경
            searchForm.find("input[name='rc_keyword']").val("");
        }
    });
    
    // 레시피 카드 호버 효과
    $(".recipe_card").hover(
        function() {
            $(this).css("transform", "translateY(-5px)");
            $(this).css("box-shadow", "0 10px 20px rgba(0, 0, 0, 0.1)");
        },
        function() {
            $(this).css("transform", "");
            $(this).css("box-shadow", "");
        }
    );
</script>
</body>
</html>
