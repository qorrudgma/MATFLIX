<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 프로필</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="mypage_container">
        <!-- 프로필 섹션 - 가독성 향상 -->
        <section class="profile_section">
            <div class="profile_header">
                <div class="profile_image_div">
	                <div class="profile_image_large" id="profile_image_preview">
						<c:choose>
						    <c:when test="${not empty profile.profile_image_path}">
								<img src="${pageContext.request.contextPath}${profile.profile_image_path}">
							</c:when>
							<c:otherwise>
								<i class="fas fa-user" id="profile_id"></i>
							</c:otherwise>
						</c:choose>
	                </div>
					<span class="modify_profile_image" id="open_profile_image_edit">이미지 수정</span>
					<form id="profile_image_form" enctype="multipart/form-data">
						<div class="profile_image_edit_panel" id="profile_image_edit_panel" style="display:none;">
						    <input type="file"
						           id="profile_image_file"
								   name="image_file"
						           accept="image/*">
						    <div class="profile_image_edit_actions">
						        <button type="button" id="profile_image_confirm" class="mf_btn mf_btn_primary">
						            확인
						        </button>
						        <button type="button" id="profile_image_cancel" class="mf_btn mf_btn_ghost">
						            취소
						        </button>
						    </div>
						</div>
					</form>
                </div>

                <div class="profile_info_container">
					<div class="profile_info">
                        <h2>
                            ${user.getMf_nickname()}
                            <button type="button" id="show_nickname_form" class="edit_profile_btn">
                                <i class="fas fa-edit user_nick_name"></i>닉네임 수정
                            </button>
                            <div id="nickname_change_form" style="display:none; margin-top: 10px;">
                                <form action="${pageContext.request.contextPath}/nickname" method="post" class="nickname-form">
                                    <input type="hidden" name="mf_id" value="${user.getMf_id()}">
                                    <div class="form-row">
                                        <label for="mf_nickname">새 닉네임:</label>
                                        <input type="text" id="mf_nickname" name="mf_nickname" maxlength="8" placeholder="한글 최대 8글자" required
											   pattern="^[a-zA-Z가-힣0-9]{1,8}$"
											   oninvalid="this.setCustomValidity('닉네임은 영어, 한글, 숫자만 가능하며 최대 8글자까지 입력할 수 있습니다.')"
										       oninput="this.setCustomValidity('')">
                                        <input type="submit" value="변경" class="nickname-submit">
                                        <button type="button" id="cancel_nickname" class="nickname-cancel">취소</button>
                                    </div>
                                </form>
                            </div>
                        </h2>
                    </div>

                    <div class="user_bio">안녕하세요! 맛있는 요리를 사랑하는 요리 초보입니다.</div>
                    <div class="profile_stats">
                        <div class="stat_item">
                            <span class="stat_number">${profile.recipe_count}</span>
                            <span class="stat_label">레시피</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${profile.follower_count}</span>
                            <span class="stat_label">팔로워</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${profile.following_count}</span>
                            <span class="stat_label">팔로잉</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 탭 메뉴 -->
        <div class="mypage_tabs">
            <div class="tab_btn active" data-tab="my_recipes">내 레시피</div>
            <div class="tab_btn" data-tab="favorites">나의 즐겨찾기</div>
            <div class="tab_btn" data-tab="my_posts">내 게시글</div>
            <div class="tab_btn" data-tab="account_settings">계정 설정</div>
			<div class="tab_btn" data-tab="environment">환경 설정</div>
        </div>

        <!-- 탭 콘텐츠 -->
        <div class="tab_content active" id="my_recipes_content">
            <!-- 내 레시피 목록 -->
            <div class="recipe_grid">
				<c:forEach var="r" items="${my_recipe}">
					<a class="recipe-card" href="recipe_content_view?recipe_id=${r.recipe_id}">
						<div class="recipe-image">
							<img src="${pageContext.request.contextPath}${r.image_path}" alt="${r.title}">
							<div class="recipe-category">한식</div>
						</div>
						<div class="recipe-info">
							<h3>${r.title}<span class="review_count"> [${r.review_count}]</span></h3>
							<span class="recipe_star">
							    <span class="star_fill">
									<c:choose>
									    <c:when test="${r.star == 0}">
											<span class ='no_star'>리뷰 없음</span>
									    </c:when>
									    <c:otherwise>
									        <c:forEach begin="1" end="${r.star}">★</c:forEach><c:forEach begin="${r.star + 1}" end="5">☆</c:forEach>
									    </c:otherwise>
									</c:choose>
							    </span>
							</span>
							<p><strong>${r.mf_nickname}</strong></p>
							<span class="recipe_time">${r.display_time}</span>
						</div>
					</a>
				</c:forEach>
                
                <c:if test="${empty my_recipe}">
                    <div class="empty-state">
                        <i class="fas fa-utensils"></i>
                        <p>아직 등록한 레시피가 없습니다.</p>
                        <a href="insert_recipe" class="add_recipe_btn">
                            <i class="fas fa-plus"></i> 레시피 등록하기
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
		
		<!-- 레시피 등록 버튼 -->
	    <button class="add_recipe_btn" onclick="location.href='recipe_write_new'">
	        <i class="fas fa-plus"></i>
	    </button>
        
        <div class="tab_content" id="favorites_content">
            <!-- 즐겨찾기 목록 -->
<!--            <div class="favorites_list">-->
            <div class="recipe_grid" id="favorites_list">
            </div>
        </div>
        
        <!-- 내 게시글 -->
        <div class="tab_content" id="my_posts_content">
            <div class="board_list">
            </div>
        </div>
		
		<!-- 계정 설정 -->
        <div class="tab_content" id="account_settings_content">
            <!-- 계정 설정 폼 -->
            <div class="form_container">
                <form id="user_update" class="update_form">
                    <input type="hidden" name="mf_id" value="${user.getMf_id()}">
                    
                    <div class="form_group">
                        <label for="mf_name">
                            <i class="fas fa-user"></i> 이름
                        </label>
                        <input type="text" id="mf_name" name="mf_name" value="${user.mf_name}"
                            required maxlength="20"
                            pattern="^[a-z가-힣]+$"
                            title="소문자, 한글만 입력 가능합니다."
                            oninvalid="this.setCustomValidity('올바른 이름 형식이 아닙니다. 소문자/한글만 입력하세요.')"
                            oninput="this.setCustomValidity('')">
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_pw">
                            <i class="fas fa-lock"></i> 비밀번호
                        </label>
						<div class="password_wrap">
	                        <input type="password" id="mf_pw" name="mf_pw" required>
							<span class="password_toggle">
	                            <i class="fa fa-eye" id="togglePassword"></i>
	                        </span>
	                    </div>
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_pw_chk">
                            <i class="fas fa-check-circle"></i> 비밀번호 확인
                        </label>
						<div class="password_wrap">
                        	<input type="password" id="mf_pw_chk" name="mf_pw_chk" required oninput="checkPasswordMatch()">
							<span class="password_toggle">
	                        	<i class="fa fa-eye" id="togglePwChk"></i>
	                        </span>
	                    </div>
                        <div id="pw_match_msg" class="validation_msg"></div>
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_email">
                            <i class="fas fa-envelope"></i> 이메일
                        </label>
                        <input type="email" id="mf_email" name="mf_email" value="${user.mf_email}" required
                            placeholder="example@email.com"
                            pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                            oninvalid="this.setCustomValidity('올바른 이메일 주소 형식으로 입력해주세요.')"
                            oninput="this.setCustomValidity('')">
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_phone">
                            <i class="fas fa-phone"></i> 전화번호
                        </label>
                        <input type="tel" id="mf_phone" name="mf_phone" value="${user.mf_phone}" required
                            placeholder="010-0000-0000"
                            pattern="^010-\d{4}-\d{4}$"
                            oninvalid="this.setCustomValidity('010-0000-0000 형식으로 입력해주세요.')"
                            oninput="this.setCustomValidity('')">
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_birth">
                            <i class="fas fa-birthday-cake"></i> 생년월일
                        </label>
                        <input type="date" id="mf_birth" name="mf_birth" value="${user.mf_birth}" required>
                    </div>
                    
                    <div class="form_actions">
                        <button type="button" class="submit_btn" onclick="fn_submit()">
                            <i class="fas fa-save"></i> 수정하기
                        </button>
                        <button type="button" class="cancel_btn" onclick="location.href='/main'">
                            <i class="fas fa-times"></i> 취소
                        </button>
                    </div>
                </form>
                
                <div class="delete_account">
					<button type="button" class="delete_btn" id="open_delete_modal">
					    <i class="fas fa-user-times"></i> 회원 탈퇴
					</button>
                </div>
            </div>
        </div>
		
		<!-- 환경 설정 -->
		<div class="tab_content" id="environment_content">
		    <h3>알림 설정</h3>
		    <div class="notif_setting_list">
		        <!-- 팔로우 -->
		        <div class="notif_item">
		            <span>팔로우 알림</span>
		            <label class="toggle_switch">
		                <input type="checkbox" id="follow_yn">
		                <span class="slider"></span>
		            </label>
		        </div>

		        <!-- 게시글 -->
		        <div class="notif_group">
		            <div class="notif_item">
		                <span>게시글 알림 전체</span>
		                <label class="toggle_switch">
		                    <input type="checkbox" id="board_all">
		                    <span class="slider"></span>
		                </label>
		            </div>
		            <div class="notif_sub">
		                <label>
		                    <input type="checkbox" id="board_comment_yn"> 댓글
		                </label>
		                <label>
		                    <input type="checkbox" id="board_reaction_yn"> 반응
		                </label>
		            </div>
		        </div>

		        <!-- 레시피 -->
		        <div class="notif_group">
		            <div class="notif_item">
		                <span>레시피 알림 전체</span>
		                <label class="toggle_switch">
		                    <input type="checkbox" id="recipe_all">
		                    <span class="slider"></span>
		                </label>
		            </div>
		            <div class="notif_sub">
		                <label>
		                    <input type="checkbox" id="recipe_review_yn"> 리뷰
		                </label>
		                <label>
		                    <input type="checkbox" id="recipe_comment_yn"> 댓글
		                </label>
		                <label>
		                    <input type="checkbox" id="recipe_reaction_yn"> 반응
		                </label>
		            </div>
		        </div>

				<!-- 댓글 -->				
		        <div class="notif_group">
		            <div class="notif_item">
		                <span>댓글 알림 상세</span>
		                <label class="toggle_switch">
		                    <input type="checkbox" id="comment_all">
		                    <span class="slider"></span>
		                </label>
		            </div>
		            <div class="notif_sub">
		                <label>
		                    <input type="checkbox" id="recomment_yn"> 답글
		                </label>
		                <label>
		                    <input type="checkbox" id="comment_reaction_yn"> 반응
		                </label>
		            </div>
		        </div>
		    </div>
		    <button id="save_notif_btn" class="submit_btn" disabled>저장</button>
		</div>
		
    </div>
	<div id="delete_modal">
	    <div class="delete_modal_content">

	        <h2>정말 회원 탈퇴 하시겠습니까?</h2>
	        <p class="warning_text">
	            탈퇴 시 모든 데이터는 복구되지 않습니다.
	        </p>

	        <!-- 비밀번호 -->
	        <input type="password" id="delete_pw" placeholder="비밀번호 입력">

	        <!-- 탈퇴 이유 -->
	        <div class="delete_reason">
	            <label><input type="radio" name="reason" value="SERVICE_DISSATISFACTION"> 서비스가 불편해요.</label>
	            <label><input type="radio" name="reason" value="LOW_USAGE"> 사용을 잘 안해요.</label>
	            <label><input type="radio" name="reason" value="LACK_OF_CONTENT"> 콘텐츠가 부족해요.</label>
	            <label><input type="radio" name="reason" value="FOUND_ALTERNATIVE"> 다른 서비스를 사용해요.</label>
	            <label>
	                <input type="radio" name="reason" value="ETC"> 기타
	            </label>

				<textarea id="etc_reason"
				          placeholder="기타 사유 입력"
				          style="display:none;"
				          maxlength="200"></textarea>
	        </div>

	        <div class="delete_modal_btn">
	            <button id="confirm_delete">탈퇴</button>
	            <button id="close_delete_modal">취소</button>
	        </div>

	    </div>
	</div>
    
    <jsp:include page="footer.jsp" />
    
    <script>
		let originalProfileImageHtml = null;
		let selectedProfileImageFile = null;
		const contextPath = "${pageContext.request.contextPath}";
		
		// 이미지 수정 열기
		$("#open_profile_image_edit").on("click", function () {
		    const preview = $("#profile_image_preview");
		    // 원본 상태 저장 (취소용)
		    originalProfileImageHtml = preview.html();
		    $("#profile_image_edit_panel").slideDown(200);
		    $("#profile_image_file").val("");
		    $("#profile_image_edit_preview").html("");
		});

		// 파일 선택 트리거
		$("#profile_image_edit_panel").on("click", function () {
		    $("#profile_image_file").click();
		});

		// 파일 선택 미리보기
		$("#profile_image_file").on("change", function () {
		    const file = this.files[0];
		    if (!file) return;

		    selectedProfileImageFile = file;

		    const reader = new FileReader();
		    reader.onload = function (e) {
		        $("#profile_image_preview").html(
		            '<img src="' + e.target.result + '" class="profile_image_img">'
		        );
		    };
		    reader.readAsDataURL(file);
		});

		// 확인 버튼
		$("#profile_image_confirm").on("click", function () {
		    const fileInput = $("#profile_image_file")[0];

		    if (!fileInput.files.length) {
		        alert("이미지를 선택해주세요.");
		        return;
		    }

		    const formData = new FormData();
		    formData.append("image_file", fileInput.files[0]);
			// 기존 이미지 있을경우 추가하기
		    formData.append("profile_image_path", null);

		    $.ajax({
		        url: "/profile_image",
		        type: "post",
		        data: formData,
		        processData: false,
		        contentType: false,
		        success: function () {
		            alert("프로필 이미지가 변경되었습니다.");
		            location.reload();
		        },
		        error: function () {
		            alert("이미지 업로드 실패");
		        }
		    });
		});


		// 취소 버튼
		$("#profile_image_cancel").on("click", function () {
		    // 원래 이미지로 복구
		    if (originalProfileImageHtml) {
		        $("#profile_image_preview").html(originalProfileImageHtml);
		    }
		    $("#profile_image_edit_panel").slideUp(200);
		    // 초기화
		    selectedProfileImageFile = null;
		    originalProfileImageHtml = null;
		    $("#profile_image_file").val("");
		});

		
				
        $(document).ready(function() {
            // 탭 전환 기능
            $('.tab_btn').click(function() {
                const tabId = $(this).data('tab');
                
                // 탭 활성화
                $('.tab_btn').removeClass('active');
                $(this).addClass('active');
                
                // 콘텐츠 전환
                $('.tab_content').removeClass('active');
                $('#' + tabId + '_content').addClass('active');
				
				if (tabId === 'environment') {
					console.log("!@#"+sessionUserNo);
					$.ajax({
		               type: "post",
		               data: {mf_no: sessionUserNo},
		               url: "/environment",
		               success: function(mf_no_notif_setting) {
						console.log(mf_no_notif_setting);
						    $("#follow_yn").prop("checked", mf_no_notif_setting.follow_yn === 1);
						    $("#board_comment_yn").prop("checked", mf_no_notif_setting.board_comment_yn === 1);
						    $("#board_reaction_yn").prop("checked", mf_no_notif_setting.board_reaction_yn === 1);
						    $("#recipe_review_yn").prop("checked", mf_no_notif_setting.recipe_review_yn === 1);
						    $("#recipe_comment_yn").prop("checked", mf_no_notif_setting.recipe_comment_yn === 1);
						    $("#recipe_reaction_yn").prop("checked", mf_no_notif_setting.recipe_reaction_yn === 1);
						    $("#recomment_yn").prop("checked", mf_no_notif_setting.recomment_yn === 1);
						    $("#comment_reaction_yn").prop("checked", mf_no_notif_setting.comment_reaction_yn === 1);
							$("#board_all").prop("checked",
							    $("#board_comment_yn").is(":checked") && $("#board_reaction_yn").is(":checked")
							);
							$("#recipe_all").prop("checked",
							    $("#recipe_review_yn").is(":checked") &&
							    $("#recipe_comment_yn").is(":checked") &&
							    $("#recipe_reaction_yn").is(":checked")
							);
							$("#comment_all").prop("checked",
							    $("#recomment_yn").is(":checked") && $("#comment_reaction_yn").is(":checked")
							);
		               },
		               error: function(e) {
		                   alert("오류 발생"+e);
		               }
		           });
		        } else if(tabId === "favorites"){
					console.log("즐겨 찾기 탭");
					$.ajax({
		               type: "post",
		               url: "/favorite_recipe_list",
		               success: function(favorite_recipe_list) {
							console.log(favorite_recipe_list);
						 	let html = "";
							if (favorite_recipe_list && favorite_recipe_list.length > 0) {
								favorite_recipe_list.forEach(function(fav) {
									let stars = "";
									if (fav.star == 0) {
									    stars = "<span class ='no_star'>리뷰 없음</span>";
									} else {
								        for (let i = 1; i <= fav.star; i++) {
								            stars += "★";
								        }
								        for (let i = fav.star + 1; i <= 5; i++) {
								            stars += "☆";
								        }
							        }
									html += `<a class="recipe-card" href="recipe_content_view?recipe_id=`+fav.recipe_id+`">
												<div class="recipe-image">
													<img src="`+contextPath+fav.image_path+`" alt="`+fav.title+`">
													<div class="recipe-category">`+fav.category+`</div>
												</div>
												<div class="recipe-info">
													<h3>`+fav.title+`<span class="review_count"> [`+fav.review_count+`]</span></h3>
													<span class="recipe_star">
										                <span class="star_fill">`+stars+`</span>
										            </span>
													<p><strong>`+fav.mf_nickname+`</strong></p>
													<span class="recipe_time">`+fav.display_time+`</span>
												</div>
											</a>`;
								});
							}else {
								html += `<div class="empty-state">
						                <i class="fas fa-utensils"></i>
						                <p>아직 등록한 레시피가 없습니다.</p>
						                <a href="insert_recipe" class="add_recipe_btn">
						                    <i class="fas fa-plus"></i> 레시피 등록하기
						                </a>
						            </div>`;
							}
							$("#favorites_list").html(html);
		               },
		               error: function(e) {
		                   alert("오류 발생"+e);
		               }
		           });
				}else if(tabId === "my_posts"){
	   				console.log("내 게시글 탭");
	   				$.ajax({
	   	               type: "post",
	   	               url: "/my_board_list",
	   	               success: function(my_board_list) {
	   						console.log(my_board_list);
	   					 	let html = "";
	   						if (my_board_list && my_board_list.length > 0) {
	   							my_board_list.forEach(function(board) {
	   								html += `<a href="content_view?pageNum=1&amount=10&type=&keyword=&boardNo=`+board.boardNo+`" class="board_card">
						                        <div class="board_title">
						                            <i class="fas fa-file-alt"></i> `+board.boardTitle+` <span id="profile_comment_count">[`+board.comment_count+`]</span>
						                        </div>
						                        <div class="board_stats">
						                            <div class="board_stat">
						                                <i class="fas fa-thumbs-up"></i>
						                                <span>추천수: `+board.recommend_count+`</span>
						                            </div>
						                            <div class="board_stat">
						                                <i class="fas fa-eye"></i>
						                                <span>조회수: `+board.boardHit+`</span>
						                            </div>
						                            <div class="board_stat">
						                                <i class="fas fa-calendar-alt"></i>
						                                <span>작성일: `+board.boardDate+`</span>
						                            </div>
						                        </div>
						                    </a>`;
	   							});
	   						}else {
	   							html += `<div class="empty-state">
					                        <i class="fas fa-clipboard"></i>
					                        <p>아직 작성한 게시글이 없습니다.</p>
					                        <a href="`+contextPath+`/board_list" class="browse_btn">
					                            <i class="fas fa-pencil-alt"></i> 게시글 작성하기
					                        </a>
					                    </div>`;
	   						}
	   						$(".board_list").html(html);
	   	               },
	   	               error: function(e) {
	   	                   alert("오류 발생"+e);
	   	               }
	   	           });
	   			}
            });
			
			// 알림 성절
			const saveBtn = document.getElementById("save_notif_btn");

			const bindGroup = (parentId, childIds) => {
			    const parent = document.getElementById(parentId);
			    const children = childIds.map(id => document.getElementById(id));

			    parent.addEventListener("change", () => {
			        children.forEach(ch => ch.checked = parent.checked);
			        saveBtn.disabled = false;
			    });

			    children.forEach(ch => {
			        ch.addEventListener("change", () => {
			            parent.checked = children.every(c => c.checked);
			            saveBtn.disabled = false;
			        });
			    });
			};

			bindGroup("board_all", ["board_comment_yn", "board_reaction_yn"]);
			bindGroup("recipe_all", ["recipe_review_yn", "recipe_comment_yn", "recipe_reaction_yn"]);
			bindGroup("comment_all", ["recomment_yn", "comment_reaction_yn"]);

			document.querySelectorAll("input[type=checkbox]").forEach(cb => {
			    cb.addEventListener("change", () => {
			        saveBtn.disabled = false;
			    });
			});

			$("#save_notif_btn").click(function() {
			    let notifData = {
			        follow_yn: $("#follow_yn").is(":checked") ? 1 : 0,
			        board_comment_yn: $("#board_comment_yn").is(":checked") ? 1 : 0,
			        board_reaction_yn: $("#board_reaction_yn").is(":checked") ? 1 : 0,
			        recipe_review_yn: $("#recipe_review_yn").is(":checked") ? 1 : 0,
			        recipe_comment_yn: $("#recipe_comment_yn").is(":checked") ? 1 : 0,
			        recipe_reaction_yn: $("#recipe_reaction_yn").is(":checked") ? 1 : 0,
			        recomment_yn: $("#recomment_yn").is(":checked") ? 1 : 0,
			        comment_reaction_yn: $("#comment_reaction_yn").is(":checked") ? 1 : 0
			    };

			    $.ajax({
			        url: "/update_notif_setting",
			        type: "POST",
			        data: JSON.stringify(notifData),
			        contentType: "application/json",
			        success: function(res) {
			            alert("알림 설정이 저장되었습니다.");
			        }
			    });
			});
        });
        
        // 비밀번호 일치 확인
        function checkPasswordMatch() {
            const pw = document.getElementById("mf_pw").value;
            const pwChk = document.getElementById("mf_pw_chk").value;
            const msg = document.getElementById("pw_match_msg");
    
            if (pwChk.length === 0) {
                msg.textContent = "";
                return;
            }
    
            if (pw === pwChk) {
                msg.textContent = "비밀번호가 일치합니다.";
                msg.style.color = "green";
            } else {
                msg.textContent = "비밀번호가 일치하지 않습니다.";
                msg.style.color = "red";
            }
        }
        
        // 즐겨찾기 삭제 기능
        function removeFavorite(recipeId) {
            if (!confirm('이 레시피를 즐겨찾기에서 삭제하시겠습니까?')) {
                return;
            }
    
            fetch('/favorites/recipe/remove', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ recipeId: recipeId })
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert(result.message || '즐겨찾기에서 삭제되었습니다.');
                    const itemToRemove = document.getElementById('favorite-item-' + recipeId);
                    if (itemToRemove) {
                        itemToRemove.remove();
                    }
    
                    // 남은 항목이 없다면 메시지 출력
                    if (document.querySelectorAll('.favorite_item').length === 0) {
                        const list = document.querySelector('.favorites_list');
                        list.innerHTML = `
                            <div class="empty-state">
                                <i class="fas fa-heart"></i>
                                <p>즐겨찾기한 레시피가 없습니다.</p>
                                <a href="${pageContext.request.contextPath}/recipe_board" class="browse_btn">
                                    <i class="fas fa-search"></i> 레시피 둘러보기
                                </a>
                            </div>
                        `;
                    }
                } else {
                    alert(result.message || '즐겨찾기 삭제에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error removing favorite:', error);
                alert('즐겨찾기 삭제 중 오류가 발생했습니다.');
            });
        }
        
        // 회원정보 수정 기능
        function fn_submit() {
            const form = document.getElementById("user_update");
    
            // 유효성 검사 실행
            if (!form.checkValidity()) {
                form.reportValidity();  // 브라우저 기본 경고창
                return;
            }
    
            const formData = $("#user_update").serialize();
    
            $.ajax({
                type: "post",
                data: formData,
                url: "mem_update",
                success: function(data) {
                    if (data.status === "success") {
                        alert("수정이 정상적으로 처리되었습니다.");
                        location.href = data.redirect; // 로그인 페이지로 이동
                    }
                },
                error: function() {
                    alert("오류 발생");
                }
            });
        }
		
		// 닉네임 수정 폼 표시/숨김 처리
        $("#show_nickname_form").click(function() {
            $("#nickname_change_form").slideDown(300);
            $(this).hide();
        });

        $("#cancel_nickname").click(function() {
            $("#nickname_change_form").slideUp(300);
            $("#show_nickname_form").show();
        });

        // 닉네임 변경 폼 제출
        $(".nickname-form").submit(function(e) {
            e.preventDefault();
			
			const nickname = $("#mf_nickname").val().trim();
		    const nicknameRegex = /^[a-zA-Z가-힣0-9]{1,8}$/;
			
			if (!nicknameRegex.test(nickname)) {
		        alert("특수문자는 사용 불가하며 최대 8글자까지 입력할 수 있습니다.");
		        $("#mf_nickname").focus();
		        return;
		    }
            
            $.ajax({
                type: "POST",
                url: $(this).attr("action"),
                data: $(this).serialize(),
                success: function(response) {
					alert(response.message);
			        if (response.success) {
			            location.reload(); // 페이지 리로드
			        }
                },
                error: function() {
                    alert("닉네임 변경 중 오류가 발생했습니다.");
                }
            });
        });
		
		// 비밀번호 표시/숨기기 기능
		$(document).ready(function() {
		    // 비밀번호 필드 토글
		    $("#togglePassword").on("click", function() {
		        const passwordField = document.getElementById("mf_pw");
		        const type = passwordField.type === "password" ? "text" : "password";
		        passwordField.type = type;
		        $(this).toggleClass("fa-eye fa-eye-slash");
		    });
		    
		    // 비밀번호 확인 필드 토글
		    $("#togglePwChk").on("click", function() {
		        const passwordField = document.getElementById("mf_pw_chk");
		        const type = passwordField.type === "password" ? "text" : "password";
		        passwordField.type = type;
		        $(this).toggleClass("fa-eye fa-eye-slash");
		    });
		});
		
		$(document).ready(function(){
		    $("#open_delete_modal").click(function(){
		        $("#delete_modal").css("display","flex");
		    });

		    $("#close_delete_modal").click(function(){
		        $("#delete_modal").hide();
		    });
		});
		
		$(document).keydown(function(e){
		    if(e.key === "Escape"){
		        $("#delete_modal").hide();
		    }
		});

		$("input[name='reason']").change(function(){
		    const selected = $(this).val();

			if(selected === "ETC"){
		        $("#etc_reason")
		            .prop("disabled", false)
		            .show()
		            .focus();
		    }else{
		        $("#etc_reason")
		            .prop("disabled", true)
		            .hide()
		            .val("");
		    }

		});
		
		$("#confirm_delete").click(function(e){
			console.log("최종 탈퇴 버튼 누름");
			
			const reason = $("input[name='reason']:checked").val();
			const etc = $("#etc_reason").val().trim();
			const pw = $("#delete_pw").val().trim();
			const etcReason = $("#etc_reason").val().trim();
			
			if(!pw){
			    alert("비밀번호를 입력하세요.");
			    return;
			}

			if(!reason){
			    alert("탈퇴 사유를 선택하세요.");
			    return;
			}
			
			if(reason === "ETC" && !etc.trim()){
			    alert("기타 사유를 입력해주세요.");
				$("#etc_reason").focus();
			    return;
			}
			
			console.log(pw);
			console.log(reason);
			console.log(etcReason);
			$.ajax({
                type: "POST",
                url: "/withdraw",
		        contentType: "application/json",
		        data: JSON.stringify({
		            mf_pw: pw,
		            reason_type: reason,
		            reason_detail: reason === "ETC" ? etcReason : reason
		        }),
                success: function(response) {
					alert(response.message);
					if(response.result === "delete"){
						window.location.href="main";
					}else{
						location.href="/profile";
					}
                },
                error: function() {
                    alert("탈퇴중 오류 발생.");
                }
            });
		});
    </script>
</body>
</html>