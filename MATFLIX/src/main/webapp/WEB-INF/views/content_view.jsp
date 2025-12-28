<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% 
    TeamDTO user = (TeamDTO) session.getAttribute("user");
    request.setAttribute("user", user); 
%>
<%@ page import="java.util.List" %>
<% 
    List<Integer> user_follow_list = (List<Integer>) session.getAttribute("user_follow_list");
    request.setAttribute("user_follow_list", user_follow_list);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 게시글 보기</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 게시글 보기 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/content_view.css">
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
        
        <div class="content-header">
            <h2>게시글 보기</h2>
            <p>맛플릭스 커뮤니티의 게시글입니다</p>
        </div>
        
        <div class="post-container">
            <form method="post" action="modify" class="post-form">
                <input type="hidden" name="boardNo" value="${pageMaker.boardNo}">
                <input type="hidden" name="pageNum" value="${pageMaker.pageNum}">
                <input type="hidden" name="amount" value="${pageMaker.amount}">
                
                <div class="post-header">
                    <div class="post-info">
                        <div class="post-number">
                            <span class="label">번호</span>
                            <span class="value">${content_view.boardNo}</span>
                        </div>
                        <div class="post-views">
                            <span class="label">작성자</span>
                            <span class="value">${content_view.boardName}</span>
                        </div>
                    </div>
                    
                    <div class="post-author">
                        <span class="label">조회수</span>
                        <div class="author-info">
                            <span class="value">${content_view.boardHit}</span>
							
							<c:if test="${user != null && user.mf_no != content_view.mf_no}">
								<button type="button" id="follow_btn" class="follow-btn">
                                    <i class="fas fa-user-plus"></i> 팔로우
                                </button>
							</c:if>
                            <!-- 팔로우 버튼 
                            <c:if test="${user != null && user.mf_no != content_view.mf_no}">
                                <c:set var="isFollowing" value="false"/>
                                <c:forEach var="id" items="${sessionScope.user_follow_list}">
                                    <c:if test="${id == content_view.mf_no}">
                                        <c:set var="isFollowing" value="true"/>
                                    </c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${isFollowing}">
                                        <button type="button" id="delete_follow_btn" class="follow-btn following">
                                            <i class="fas fa-user-minus"></i> 팔로우 취소
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" id="follow_btn" class="follow-btn">
                                            <i class="fas fa-user-plus"></i> 팔로우
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
						 프론트에서 확인하지말고 서버에서 확인하기 -->
                        </div>
                    </div>
                </div>
                
                <div class="post-content">
                    <div class="post-title">
                        <span class="label">제목</span>
                        <c:choose>
                            <c:when test="${user.mf_no == content_view.mf_no}">
                                <input type="text" name="boardTitle" value="${content_view.boardTitle}" class="editable">
                            </c:when>
                            <c:otherwise>
                                <input type="text" name="boardTitle" value="${content_view.boardTitle}" readonly class="readonly">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="post-body">
                        <span class="label">내용</span>
                        <c:choose>
                            <c:when test="${user.mf_no == content_view.mf_no}">
                                <textarea name="boardContent" class="editable">${content_view.boardContent}</textarea>
                            </c:when>
                            <c:otherwise>
                                <textarea name="boardContent" readonly class="readonly">${content_view.boardContent}</textarea>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="post-likes">
                        <span class="label">추천 수</span>
                        <span class="value">${total_recommend}</span>
                        <span class="value">${content_view.recommend_count}</span>
                    </div>
                </div>
                
                <div class="post-actions">
                    <c:if test="${content_view.mf_no == user.mf_no}">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-edit"></i> 수정
                        </button>
                    </c:if>
                    <button type="submit" formaction="list" class="btn-secondary">
                        <i class="fas fa-list"></i> 목록보기
                    </button>
                    <c:if test="${content_view.mf_no == user.mf_no}">
                        <button type="submit" formaction="delete" class="btn-danger">
                            <i class="fas fa-trash-alt"></i> 삭제
                        </button>
                    </c:if>
                    <c:if test="${user != null && user.mf_no != content_view.mf_no}">
                        <button id="recommend" type="button" class="btn-like ${recommend == 1 ? 'active' : ''}">
                            <i class="fas fa-heart"></i>
                            <c:choose>
                                <c:when test="${recommend != 1}">
                                    추천
                                </c:when>
                                <c:otherwise>
                                    추천 취소
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </c:if>
                </div>
            </form>
        </div>


        <!-- 댓글 섹션 - 새로운 디자인 -->
        <div class="comment-section">
            <h3>댓글</h3>
            
            <!-- 댓글 목록 -->
            <div id="comment-list" class="comments-list">
                <c:forEach items="${commentList}" var="comment" begin="0" end="4">
                    <div class="comment-item">
                        <div class="comment-profile">
                            <div class="comment-avatar">
                                <i class="fas fa-user"></i>
                            </div>
                        </div>
                        <div class="comment-content">
                            <div class="comment-header">
                                <span class="comment-author">
                                    ${comment.commentWriter}
                                    <c:if test="${comment.userNo == content_view.mf_no}">
                                        <span class="author-tag">작성자</span>
                                    </c:if>
									<span class="comment-date">(${comment.commentTime})</span>
                                </span>
                            </div>
                            <div class="comment-text">${comment.commentContent}</div>
                            <div class="comment-footer">
                                <span class="comment-like"><i class="far fa-heart"></i></span>
                            </div>
                        </div>
                        <c:if test="${comment.userNo == user.mf_no}">
                            <div class="comment-actions">
                                <button class="comment-menu">
                                    <i class="fas fa-ellipsis-h"></i>
                                </button>
                                <div class="comment-dropdown">
                                    <div class="dropdown-item delete" onclick="deleteComment('${comment.commentNo}')">
                                        <i class="fas fa-trash-alt"></i> 삭제
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
            
            <!-- 더보기/접기 버튼 -->
            <div class="comments-actions">
                <c:if test="${count > 5}">
                    <button onclick="loadMoreComments()" class="btn-load-more">더보기</button>
                </c:if>
                <button onclick="hideComments()" class="btn-hide-more" style="display: none;">접기</button>
            </div>
            
            <!-- 댓글 작성 폼 -->
            <div class="comment-form">
                <div class="form-group">
                    <label for="commentWriter">작성자</label>
					<c:choose>
						<c:when test="${user != null}">
                    		<input type="text" id="commentWriter" value="${user.mf_nickname}" readonly>
						</c:when>
						<c:otherwise>
                    		<input type="text" id="commentWriter" value="로그인 후 이용 가능합니다." readonly>
						</c:otherwise>
					</c:choose>
                </div>
                <div class="form-group">
                    <label for="commentContent">내용</label>
                    <input type="text" id="commentContent" placeholder="댓글을 입력하세요">
                </div>
                <button type="button" onclick="commentWrite()" class="btn-comment">댓글작성</button>
            </div>
        </div>
        
        <!-- 이미지 확대 보기 -->
        <div class="bigPicture">
            <div class="bigPic"></div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />

<script>
    // 변수
    <% if (user != null) { %>
        var sessionUserNo = <%= user.getMf_no() %>;
        var sessionUserEmail = "<%= user.getMf_email() %>";
    <% } else { %>
        var sessionUserNo = null;
    <% } %>
    var no = "${content_view.boardNo}";
    var w_user = "${content_view.mf_no}";
    var endNo = 5; // 초기에 표시할 댓글 수
    var comment_count = ${count}; // 전체 댓글 수
    
    // 페이지 로드 시 애니메이션 효과
    $(document).ready(function() {
		// 팔로우 상태
		$.ajax({
			type: "get",
			url: "/follow_unfollow",
			data: {follower_id: sessionUserNo, following_id: w_user},
			success: function(res){
				if(res){
					$("#follow_btn").html('<i class="fas fa-user-minus"></i> 팔로우 취소').addClass("delete_follow");
					console.log("팔로우 취소");
				} else {
					$("#follow_btn").html('<i class="fas fa-user-plus"></i> 팔로우').addClass("add_follow");			
					console.log("팔로우");
				}
			}
		});
        // 게시글 내용에 이미지가 있으면 클릭 시 확대 보기 기능 추가
        $(".post-body img").on("click", function() {
            var imgSrc = $(this).attr("src");
            $(".bigPic").html("<img src='" + imgSrc + "'>");
            $(".bigPicture").css("display", "flex").hide().fadeIn();
        });
        
        // 확대 보기 닫기
        $(".bigPicture").on("click", function() {
            $(this).fadeOut();
        });
        
        // 댓글 메뉴 토글
        $(document).on("click", ".comment-menu", function(e) {
            e.stopPropagation();
            $(this).next(".comment-dropdown").toggleClass("active");
        });
        
        // 다른 곳 클릭 시 드롭다운 닫기
        $(document).on("click", function() {
            $(".comment-dropdown").removeClass("active");
        });
    });
	    
    // 팔로우 추가 버튼
    $(document).on("click", ".add_follow", function (e) {
        e.preventDefault();

        if (sessionUserNo == null) {
            alert("로그인 후 이용 가능합니다.");
            return;
        }

        $.ajax({
             type: "POST"
            ,data: {following_id: w_user, follower_id:sessionUserNo, follower_email:sessionUserEmail}
            ,url: "/add_follow"
            ,success: function (result) {
                console.log("팔로우 성공");
                $("#follow_btn").removeClass("add_follow")
                    .html('<i class="fas fa-user-minus"></i> 팔로우 취소')
                    .addClass("delete_follow");
            }
            ,error: function () {
                console.log("팔로우 성공");
            }
        });
    });
    // 팔로우 삭제 버튼
    $(document).on("click", ".delete_follow", function (e) {
        e.preventDefault();

        if (sessionUserNo == null) {
            alert("로그인 후 이용 가능합니다.");
            return;
        }

        $.ajax({
             type: "POST"
            ,data: {following_id: w_user, follower_id:sessionUserNo}
            ,url: "/delete_follow"
            ,success: function (result) {
                console.log("팔로우 삭제 성공");
                $("#follow_btn").removeClass("delete_follow")
                    .html('<i class="fas fa-user-plus"></i> 팔로우')
                    .addClass("add_follow");
            }
            ,error: function () {
                console.log("팔로우 실패");
            }
        });
    });

    // 추천 버튼
    $(document).on("click", "#recommend", function (e) {
        e.preventDefault();

        if (sessionUserNo == null) {
            alert("로그인 후 이용 가능합니다.");
            return;
        }

        $.ajax({
             type: "POST"
            ,data: {boardNo: no, board_mf_no: w_user}
            ,url: "/recommend"
            ,success: function (result) {
                console.log(result);
                if(result == "recommend") {
                    $("#recommend").html('<i class="fas fa-heart"></i> 추천 취소');
                    $("#recommend").addClass("active");
                    // 추천 수 업데이트
                    var currentLikes = parseInt($(".post-likes .value").text());
                    $(".post-likes .value").text(currentLikes + 1);
                } else {
                    $("#recommend").html('<i class="fas fa-heart"></i> 추천');
                    $("#recommend").removeClass("active");
                    // 추천 수 업데이트
                    var currentLikes = parseInt($(".post-likes .value").text());
                    $(".post-likes .value").text(currentLikes - 1);
                }
            }
            ,error: function () {
                console.log("추천 실패");
            }
        });
    });

    // 댓글 관련 함수들
    function commentWrite() {
        console.log("유저 넘 => " + sessionUserNo);
        const writer = document.getElementById("commentWriter").value;
        const content = document.getElementById("commentContent").value;

        if (!content.trim()) {
            alert("댓글 내용을 입력해주세요.");
            return;
        }

        $.ajax({
            type: "post",
            data: {
                commentWriter: writer,
                commentContent: content,
                boardNo: no,
                userNo: sessionUserNo
            },
            url: "/comment/save",
            success: function(commentList) {
                console.log("작성 성공");
                document.getElementById("commentContent").value = "";
                // 댓글 작성 후 댓글 수 업데이트
                comment_count++;
                // 댓글 목록 새로고침
                loadComments();
            },
            error: function() {
                console.log("실패");
            }
        });
    }

    // 댓글 삭제 기능
    function deleteComment(commentNo) {
        $.ajax({
            type: "post",
            url: "/comment/delete",
            data: { commentNo: commentNo },
            success: function(response) {
                console.log("댓글 삭제 성공");
                // 댓글 삭제 후 댓글 수 업데이트
                comment_count--;
                loadComments();
            },
            error: function() {
                console.log("댓글 삭제 실패");
            }
        });
    }

    // 댓글 목록 로드
    function loadComments() {
        $.ajax({
            type: "get",
            url: "/comment/list",
            data: { boardNo: no },
            success: function(commentList) {
                renderCommentList(commentList);
            },
            error: function() {
                console.log("댓글 목록 불러오기 실패");
            }
        });
    }

    // 댓글 목록 렌더링
    function renderCommentList(commentList) {
        let output = "";
        
        // 표시할 댓글 수 계산 (endNo가 전체 댓글 수보다 크면 전체 댓글 수로 제한)
        const displayCount = Math.min(endNo, commentList.length);
        
        for (let i = 0; i < displayCount; i++) {
            const comment = commentList[i];
            
            output += `<div class="comment-item">
                         <div class="comment-profile">
                             <div class="comment-avatar">
                                 <i class="fas fa-user"></i>
                             </div>
                         </div>
                         <div class="comment-content">
                             <div class="comment-header">
                                 <span class="comment-author">`
                                    +commentList[i].commentWriter;
               if(commentList[i].userNo == w_user){
                     output += `<span class='author-tag'>작성자</span>`;
               }
                         output += `<span class="comment-date">(`+commentList[i].commentTime+`)</span></span>
                             </div>
                             <div class="comment-text">`+commentList[i].commentContent+`</div>
                             <div class="comment-footer">
                                 <span class="comment-like"><i class="far fa-heart"></i></span>
                             </div>
                         </div>`;
                
            if (commentList[i].userNo == sessionUserNo) {
                 output += `<div class="comment-actions">
                              <div class="dropdown-item delete" onclick="deleteComment(`+commentList[i].commentNo+`)">
                                  <i class="fas fa-trash-alt"></i> 삭제
                              </div>
                     </div>`;
            }
            
            output += `</div>`;
        }
        
        document.getElementById("comment-list").innerHTML = output;
        
        // 더보기/접기 버튼 표시 여부 설정
        if (displayCount < commentList.length) {
            $(".btn-load-more").show();
        } else {
            $(".btn-load-more").hide();
        }
        
        if (endNo > 5) {
            $(".btn-hide-more").show();
        } else {
            $(".btn-hide-more").hide();
        }
    }

    // 댓글 더보기 버튼
    function loadMoreComments() {
        endNo += 5; // 5개씩 더 표시
        loadComments();
    }

    // 댓글 접기 버튼
    function hideComments() {
        endNo = 5; // 기본 표시 개수로 되돌림
        loadComments();
    }
    
    // 페이지 로드 시 댓글 목록 초기화
    $(document).ready(function() {
        // 초기 댓글 목록 로드
        if (comment_count > 0) {
            loadComments();
        }
    });
</script>
</body>
</html>
