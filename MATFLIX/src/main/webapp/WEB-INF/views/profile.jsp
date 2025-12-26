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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="mypage_container">
        <!-- 프로필 섹션 - 가독성 향상 -->
        <section class="profile_section">
            <div class="profile_header">
                <div class="profile_image_large">
                    <img src="${pageContext.request.contextPath}/image/MATFLIX.png" alt="프로필 이미지">
                    <button class="edit_profile_image"><i class="fas fa-camera"></i></button>
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
                                        <input type="text" id="mf_nickname" name="mf_nickname" required>
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
                            <span class="stat_number">${my_recipe_count}</span>
                            <span class="stat_label">레시피</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${user_follower_count}</span>
                            <span class="stat_label">팔로워</span>
                        </div>
                        <div class="stat_item">
                            <span class="stat_number">${user_follow_count}</span>
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
                <c:forEach var="recipe" items="${my_recipe}">
                    <a href="recipe_content_view?rc_recipe_id=${recipe.rc_recipe_id}">
                        <div class="recipe_card">
                            <c:set var="imageShown" value="false" scope="page" />
                            <c:forEach var="attach" items="${my_recipe_attach}">
                                <c:if test="${!imageShown && attach.rc_recipe_id == recipe.rc_recipe_id && not empty attach.fileName}">
                                    <img src="/upload/${attach.uploadPath}/${attach.uuid}_${attach.fileName}" alt="${recipe.rc_name}" />
                                    <c:set var="imageShown" value="true" scope="page" />
                                </c:if>
                            </c:forEach>
                            <p>
                                ${recipe.rc_recipe_id}. ${recipe.rc_name} <br/>
                                (${recipe.rc_created_at})
                                <c:if test="${not empty recipe.rc_difficulty}">
                                    <br/>난이도: ${recipe.rc_difficulty}
                                </c:if>
                            </p>
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
            
            <c:if test="${not empty my_recipe}">
                <a href="insert_recipe" class="floating_add_btn">
                    <i class="fas fa-plus"></i>
                </a>
            </c:if>
        </div>
        
        <div class="tab_content" id="favorites_content">
            <!-- 즐겨찾기 목록 -->
            <div class="favorites_list">
                <c:choose>
                    <c:when test="${not empty favorites && fn:length(favorites) > 0}">
                        <c:forEach var="fav" items="${favorites}">
                            <div class="favorite_item" id="favorite-item-${fav.recipeId}">
                                <div class="favorite_content">
                                    <h3 class="favorite_title">
                                        <a href="${pageContext.request.contextPath}/recipe_content_view?rc_recipe_id=${fav.recipeId}" class="recipe_link">
                                            <i class="fas fa-utensils"></i> 레시피 #${fav.recipeId}
                                        </a>
                                    </h3>
                                    
                                    <c:if test="${not empty fav.createdAt}">
                                        <div class="favorite_date">
                                            <i class="far fa-calendar-alt"></i>
                                            즐겨찾기 추가일:
                                            <fmt:formatDate value="${fav.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="favorite_actions">
                                    <button class="delete_btn" onclick="removeFavorite(${fav.recipeId})">
                                        <i class="fas fa-trash-alt"></i> 삭제
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-heart"></i>
                            <p>즐겨찾기한 레시피가 없습니다.</p>
                            <a href="${pageContext.request.contextPath}/recipe_board" class="browse_btn">
                                <i class="fas fa-search"></i> 레시피 둘러보기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- 내 게시글 -->
        <div class="tab_content" id="my_posts_content">
            <div class="board_list">
                <c:forEach var="board" items="${profile_board}">
                    <a href="content_view?pageNum=1&amount=10&type=&keyword=&boardNo=${board.boardNo}" class="board_card">
                        <div class="board_title">
                            <i class="fas fa-file-alt"></i> ${board.boardTitle}
                        </div>
                        <div class="board_stats">
                            <div class="board_stat">
                                <i class="fas fa-thumbs-up"></i>
                                <span>추천수: ${board.recommend_count}</span>
                            </div>
                            <div class="board_stat">
                                <i class="fas fa-eye"></i>
                                <span>조회수: ${board.boardHit}</span>
                            </div>
                            <div class="board_stat">
                                <i class="fas fa-calendar-alt"></i>
                                <span>작성일: ${board.boardDate}</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
                
                <c:if test="${empty profile_board}">
                    <div class="empty-state">
                        <i class="fas fa-clipboard"></i>
                        <p>아직 작성한 게시글이 없습니다.</p>
                        <a href="${pageContext.request.contextPath}/board_list" class="browse_btn">
                            <i class="fas fa-pencil-alt"></i> 게시글 작성하기
                        </a>
                    </div>
                </c:if>
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
                        <input type="password" id="mf_pw" name="mf_pw" required>
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_pw_chk">
                            <i class="fas fa-check-circle"></i> 비밀번호 확인
                        </label>
                        <input type="password" id="mf_pw_chk" name="mf_pw_chk" required
                            oninput="checkPasswordMatch()">
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
                    <button type="button" class="delete_btn" onclick="location.href='/delete_member'">
                        <i class="fas fa-user-times"></i> 회원 탈퇴
                    </button>
                </div>
            </div>
        </div>
		
		<!-- 환경 설정 -->
		<div class="tab_content" id="environment_content">
		    <h3>알림 설정</h3>

		    <div class="notif_setting_list">

		        <div class="notif_item">
		            <span>팔로우</span>
		            <label class="toggle_switch">
		                <input type="checkbox" data-type="follow">
		                <span class="slider"></span>
		            </label>
		        </div>

		        <div class="notif_item">
		            <span>게시글</span>
		            <label class="toggle_switch">
		                <input type="checkbox" data-type="board">
		                <span class="slider"></span>
		            </label>
		        </div>

		        <div class="notif_item">
		            <span>댓글</span>
		            <label class="toggle_switch">
		                <input type="checkbox" data-type="comment">
		                <span class="slider"></span>
		            </label>
		        </div>

		        <div class="notif_item">
		            <span>추천</span>
		            <label class="toggle_switch">
		                <input type="checkbox" data-type="recommend">
		                <span class="slider"></span>
		            </label>
		        </div>

		        <div class="notif_item">
		            <span>레시피 댓글</span>
		            <label class="toggle_switch">
		                <input type="checkbox" data-type="recipe_comment">
		                <span class="slider"></span>
		            </label>
		        </div>

		    </div>
		</div>		
		
		<!-- 닉네임 수정 -->
		
    </div>
    
    <jsp:include page="footer.jsp" />
    
    <script>
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
							for (let i = 0; i < mf_no_notif_setting.length; i++) {
							    const type = mf_no_notif_setting[i].notif_type;
							    const yn = mf_no_notif_setting[i].yn;

							    $('input[data-type="' + type + '"]').prop('checked', yn === 1);
							}
		               },
		               error: function(e) {
		                   alert("오류 발생"+e);
		               }
		           });
		        }
            });
			
			$('input[type="checkbox"]').change(function() {
			    const type = $(this).data('type');
			    const yn = $(this).is(':checked') ? 1 : 0;

			    // 서버로 보내기
				$.ajax({
				    url: "/update_notif_setting",
				    type: "post",
				    data: {
				        notif_type: type,
				        yn: yn
				    },
				    success: function() {
				        console.log("알림 설정 변경 완료");
				    },
				    error: function(e) {
				        alert("설정 변경 실패"+e.responseText);
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
		            
		            $.ajax({
		                type: "POST",
		                url: $(this).attr("action"),
		                data: $(this).serialize(),
		                success: function(response) {
		                    alert("닉네임이 성공적으로 변경되었습니다.");
		                    location.reload(); // 페이지 리로드
		                },
		                error: function() {
		                    alert("닉네임 변경 중 오류가 발생했습니다.");
		                }
		            });
		        });
    </script>
</body>
</html>
