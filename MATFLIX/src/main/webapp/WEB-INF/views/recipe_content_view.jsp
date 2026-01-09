<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>${recipe.title}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_content_view.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="recipe_view_container">

    <!-- 대표 이미지 -->
    <section class="recipe_hero">
        <img src="${pageContext.request.contextPath}${recipe.image_path}" alt="${recipe.title}">
        <div class="hero_overlay">
            <span class="hero_category">${recipe.category}</span>
            <h1>${recipe.title}</h1>
            <p>${recipe.mf_nickname} · ${recipe.updated_at}</p>
            <p class="recommend">추천 · <span id="recommend_count">${recipe.recommend}</span></p>
        </div>
    </section>

    <!-- 레시피 소개 -->
    <section class="recipe_intro_section">
        <p>${recipe.intro}</p>
    </section>

    <!-- 재료 -->
    <section class="recipe_block">
        <h2>재료</h2>
        <ul class="ingredient_list">
            <c:forEach var="i" items="${ingredient_list}">
                <li>
                    <span>${i.ingredient_name}</span>
                    <span>${i.ingredient_amount}</span>
                </li>
            </c:forEach>
        </ul>
    </section>

    <!-- 조리 과정 -->
    <section class="recipe_block">
        <h2>조리 방법</h2>

        <c:forEach var="s" items="${step_list}">
            <div class="step_item">
                <div class="step_text">
                    <span class="step_no">STEP ${s.step_no}</span>
                    <p>${s.step_content}</p>
                </div>

                <!-- 같은 step_no 이미지 -->
                <div class="step_image">
                    <c:forEach var="img" items="${image_list}">
                        <c:if test="${img.step_no == s.step_no}">
						<img src="${pageContext.request.contextPath}${img.image_path}" alt="이미지">
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </section>

    <!-- 태그 -->
    <section class="recipe_tag_section">
        <c:forEach var="t" items="${tag_list}">
            <span class="recipe_tag">#${t.tag}</span>
        </c:forEach>
    </section>
	
	<!-- 사진 리뷰 -->
	<section class="photo_review_section">
	    <div class="photo_review_header">
	        <h2>사진 리뷰</h2>
	        <!-- 추천 버튼 -->
			<c:choose>
				<c:when test="${recommended != 1}">
			        <button class="photo_review_like_btn">
			            <i class="fas fa-thumbs-up"></i> 추천
			        </button>
				</c:when>
				<c:otherwise>
					<button class="photo_review_like_btn active">
					    <i class="fas fa-thumbs-up"></i> 추천 취소
					</button>
				</c:otherwise>
			</c:choose>
	    </div>

	    <div class="photo_review_list">
	        <!-- 나중에 리뷰 이미지로 교체 -->
	        <c:forEach var="img" items="${image_list}">
	            <c:if test="${img.image_type eq 'STEP'}">
	                <div class="photo_review_item">
	                    <img src="${pageContext.request.contextPath}${img.image_path}" alt="리뷰 사진">
	                </div>
	            </c:if>
	        </c:forEach>
	        <c:forEach var="img" items="${image_list}">
	            <c:if test="${img.image_type eq 'STEP'}">
	                <div class="photo_review_item">
	                    <img src="${pageContext.request.contextPath}${img.image_path}" alt="리뷰 사진">
	                </div>
	            </c:if>
	        </c:forEach>
	    </div>
	</section>

    <!-- 댓글 -->
    <section class="comment_section">
        <h2>댓글</h2>

        <!-- 댓글 입력 -->
        <div class="comment_input">
            <input type="text" id="input_recipe_comment" placeholder="맛평을 입력하세요...">
            <button type="button" onclick="commentWrite(0)" class="btn-comment">등록</button>
        </div>

        <!-- 댓글 리스트 (값은 네가 연결) -->
        <div id="comment_list" class="comment_list">
        </div>
    </section>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
<script>
	// 변수
	var sessionUserNo = "${not empty user ? user.mf_no : '' }";
    var recipe_id = "${recipe.recipe_id}";
	var parentCommentNo = 0;
	
	document.addEventListener("DOMContentLoaded", function () {
	    const photoReview = document.querySelector(".photo_review_list");
	
	    if (!photoReview) return;
	
	    photoReview.addEventListener("wheel", function (e) {
	        e.preventDefault();
	
	        // 휠 움직임을 가로 스크롤로 전환
	        photoReview.scrollLeft += e.deltaY;
	    }, { passive: false });
	});
	
	// 추천 버튼
    $(document).on("click", ".photo_review_like_btn", function (e) {
        e.preventDefault();

        if (sessionUserNo == '') {
            alert("로그인 후 이용 가능합니다.");
            return;
        }

        $.ajax({
             type: "POST"
            ,data: {recipe_id: recipe_id}
            ,url: "/recipe_recommend"
            ,success: function (result) {
				console.log(result);
				$("#recommend_count").text(result.count);
                if(result.status === "recommended") {
					console.log("recommended");
                    $(".photo_review_like_btn").html('<i class="fas fa-heart"></i> 추천 취소').addClass("active");
                } else {
					console.log("cancel");
                    $(".photo_review_like_btn").html('<i class="fas fa-heart"></i> 추천').removeClass("active");
                }
            }
            ,error: function () {
                console.log("추천 실패");
            }
        });
    });
	

	// 페이지 로드 시 댓글 목록 초기화
	$(document).ready(function() {
	    // 초기 댓글 목록 로드
        loadComments();
	});
	
	// 댓글 목록 로드
    function loadComments() {
        $.ajax({
            type: "get",
            url: "/recipe/comment/list",
            data: { recipe_id: recipe_id },
            success: function(recipeCommentList) {
                console.log(recipeCommentList);
                renderCommentList(recipeCommentList);
            },
            error: function() {
                console.log("댓글 목록 불러오기 실패");
            }
        });
    }
	
	function renderCommentList(commentList) {
	    let output = "";

	    // 부모 자식 분리
	    const parents = commentList.filter(c => c.parentCommentNo == 0);
	    const children = commentList.filter(c => c.parentCommentNo != 0);

	    // 부모 기준으로 출력
	    parents.forEach(parent => {
	        // 부모 댓글 출력
	        output += renderParent(parent);

	        // 해당 부모의 자식 댓글 출력
	        children.filter(child => child.parentCommentNo == parent.comment_no)
		            .forEach(child => {
		                output += renderChild(child);
		            });
	    });

	    // 화면에 반영
	    document.getElementById("comment_list").innerHTML = output;
	}

	// 부모 댓글 표시
	function renderParent(c) {
	    let html = `<div class="comment-item parent">
				        <div class="comment-main">
				            <div class="comment-profile">
				                <div class="comment-avatar">
				                    <i class="fas fa-user"></i>
				                </div>
				            </div>
				            <div class="comment-content">
				                <div class="comment-header">
				                    <span class="comment-author">` + (c.mf_nickname) + `<span class="comment_no">` + c.comment_no + `</span>`
				                        + (c.mf_no == sessionUserNo? `<span class="author-tag">작성자</span>` : ``) +
				                        `<span class="comment-date">(`+(c.created_at)+`)</span>
				                    </span>
				                </div>
				                <div class="comment-text">` + c.comment_content + `</div>
				                <div class="comment-footer">
				                    <span class="comment-like ` + (c.recommended == 1 ? 'active' : '') + `"onclick="commentRecommend(` + c.comment_no+`, this)">
				                        <span class="like-count">` + c.recommend_count + `</span>
				                        <i class="` + (c.recommended == 1 ? 'fas' : 'far') + ` fa-heart"></i>
				                    </span>
				                    <span class="reply-btn" onclick="setReply(this, ` + c.comment_no+`)">답글</span>
				                </div>
				            </div>
				        </div>
				        ` + (c.mf_no == sessionUserNo ? `
				        <div class="comment-actions">
				            <div class="dropdown-item delete"onclick="deleteComment(` + c.comment_no + `)">
								<i class="fas fa-trash-alt"></i> 삭제
				            </div>
				        </div>` : ``) + `</div>`;
	    return html;
	}

	// 자식 댓글 표시
	function renderChild(c) {
	    let html = `<div class="comment-item child">
				        <div class="comment-main">
				            <div class="comment-profile">
				                <div class="comment-avatar">
				                    <i class="fas fa-user"></i>
				                </div>
				            </div>
				            <div class="comment-content">
				                <div class="comment-header">
				                    <span class="comment-author">` + c.mf_nickname+`<span class="comment_no">` + c.comment_no + `</span>`
				                         + (c.mf_no == sessionUserNo? `<span class="author-tag">작성자</span>` : ``) +
										`<span class="comment-date">(` + c.created_at + `)</span>
				                    </span>
				                </div>
				                <div class="comment-text">` + c.comment_content + `</div>
				                <div class="comment-footer">
				                    <span class="comment-like ` + (c.recommended == 1 ? 'active' : '') + `"onclick="commentRecommend(` + c.comment_no + `, this)">
				                        <span class="like-count">` + c.recommend_count + `</span>
				                        <i class="` + (c.recommended == 1 ? 'fas' : 'far') + ` fa-heart"></i>
				                    </span>
				                </div>
				            </div>
				        </div>
				        ` + (c.mf_no == sessionUserNo ? `
				        <div class="comment-actions">
				            <div class="dropdown-item delete"
				                 onclick="deleteComment(` + c.comment_no + `)">
				                <i class="fas fa-trash-alt"></i> 삭제
				            </div>
				        </div>` : ``) + `</div>`;
	    return html;
	}
	
	// 댓글 작성
    function commentWrite(parentCommentNo) {
        console.log("유저 넘 => " + sessionUserNo);
    	let content = document.getElementById("input_recipe_comment").value;

		// 로그인 체크
	    if (sessionUserNo == '') {
	        alert("로그인 후 이용 가능합니다.");
	        return;
	    }
		
		if (parentCommentNo > 0) {
	        const replyInput = document.querySelector(".reply-box input");
	        if (!replyInput || !replyInput.value.trim()) {
	            alert("답글 내용을 입력해주세요.");
	            return;
	        }
	        content = replyInput.value;
	    }
	    // 일반 댓글이면 메인 input
	    else {
	        const mainInput = document.getElementById("input_recipe_comment");
	        if (!mainInput.value.trim()) {
	            alert("댓글 내용을 입력해주세요.");
	            return;
	        }
	        content = mainInput.value;
	    }

        $.ajax({
            type: "post",
            url: "/recipe/comment",
            data: {
                recipe_id: recipe_id,
                comment_content: content,
				parentCommentNo: parentCommentNo
            },
            success: function(recipeCommentList) {
                console.log("작성 성공");
                document.getElementById("input_recipe_comment").value = "";
				// 답글 모드에서 일반 댓글 모드로 돌아감
				parentCommentNo = 0;
                // 댓글 목록 새로고침
                loadComments();
            },
            error: function() {
                console.log("실패");
            }
        });
    }
	
	// 답글
	function setReply(el) {
		// 로그인 체크
	    if (sessionUserNo == '') {
	        alert("로그인 후 이용 가능합니다.");
	        return;
	    }
		// 답글창 이미 열려있으면 닫기
		document.querySelectorAll(".reply-box").forEach(box => box.remove());
		// 답글이 속한 div 찾기
		const commentItem = el.closest(".comment-item");
		// 부모 댓글 번호 가져오기
	    parentCommentNo = commentItem.querySelector(".comment_no").textContent;

	    console.log("답글 대상 comment_no =", parentCommentNo);

		// 답글 입력창 생성
		const replyBox = document.createElement("div");
		replyBox.className = "reply-box";

		replyBox.innerHTML = `
			<div class="reply-form">
			    <div class="reply-top">
			        <div class="reply-target">↳ 작성자에게 답글</div>
			        <input type="text" id="replyContent" placeholder="답글을 입력하세요">
			    </div>

			    <div class="reply-actions">
			        <button class="btn-comment reply_btn" onclick="commentWrite(`+parentCommentNo+`)">등록</button>
			        <button class="btn-comment reply_btn" onclick="cancelReply()">취소</button>
			    </div>
			</div>
		`;

		// 댓글 바로 아래에 삽입
		commentItem.appendChild(replyBox);
		replyBox.querySelector("#replyContent").focus();
	}

	// 답글 취소
	function cancelReply() {
	    parentCommentNo = 0;
	    document.querySelectorAll(".reply-box").forEach(box => box.remove());
	}
	
	
	// 댓글 삭제 기능
    function deleteComment(comment_no) {
        $.ajax({
            type: "post",
            url: "/recipe/comment/delete",
            data: { comment_no: comment_no },
            success: function() {
                console.log("댓글 삭제 성공"); 
                loadComments();
            },
            error: function() {
                console.log("댓글 삭제 실패");
            }
        });
    }
	

	// 댓글 추천
	function commentRecommend(comment_no, el){
		console.log("commentRecommend 누름");
		// 로그인 체크
	    if (sessionUserNo == '') {
	        alert("로그인 후 이용 가능합니다.");
	        return;
	    }
		
		$.ajax({
			type: "post",
			url: "/recipe/comment/recommend",
			data: {comment_no: comment_no},
			success: function(result){
				if(result == "recommend"){
					console.log("추천됨 {}"+result);
					$(el).addClass("active");
	                $(el).find("i").removeClass("far").addClass("fas");
					updateLike(el, true);
				}else if(result == "cancel"){
					console.log("추천 취소됨 {}"+result);
					$(el).removeClass("active");
	                $(el).find("i").removeClass("fas").addClass("far");
					updateLike(el, false);
				}
			},
			error:function(result){
				console.log("실패"+result);
			}
		});
	}
	// 추천 수 확인
	function updateLike(el, recommend) {
	    const $countEl = $(el).find(".like-count");
	    let count = parseInt($countEl.text(), 10) || 0;
		console.log("찾은 엘리먼트:", $countEl);

	    if (recommend) {
	        $countEl.text(count + 1);
	    } else {
	        $countEl.text(Math.max(0, count - 1));
	    }
	}
</script>