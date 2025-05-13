<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!------------------------------------여기 추가함---------------------------------------->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function() {
    $('.tab_btn[data-tab="account_settings"]').on('click', function() {
      window.location.href = '/account';
    });
  });
</script>
<!------------------------------------여기 추가함---------------------------------------->

<div class="mypage_container">
    <!-- 프로필 섹션 -->
<section class="profile_section">
        <div class="profile_header">
            <div class="profile_image_large">
                <img src="${pageContext.request.contextPath}/resources/image/MATFLIX.png" alt="프로필 이미지">
                <button class="edit_profile_image"><i class="fas fa-camera"></i></button>
            </div>
            <div class="profile_info_container">
<!--                <div class="profile_info">-->
<!--                    <h2>${user.getMf_nickname()}-->
<!--					<button class="edit_profile_btn tab_btn" data-tab="nickname_settings"><i class="fas fa-edit user_nick_name"></i></button></h2>-->
<!--                </div>-->

<!--	--------------------------------------닉네임 변경 div ----------------------------------------->
				<div class="profile_info">
				    <h2>
				        ${user.getMf_nickname()}
				        <form action="${pageContext.request.contextPath}/nickname_form" method="get" style="display:inline;">
				            <input type="hidden" name="mf_id" value="${user.getMf_id()}"/>
				            <button type="submit" class="edit_profile_btn tab_btn">
				                <i class="fas fa-edit user_nick_name"></i>닉네임 수정
				            </button>
				        </form>
				    </h2>
				</div>

	
                    <div class="user_bio">안녕하세요! 맛있는 요리를 사랑하는 요리 초보입니다.</div>
                <div class="profile_stats">
                    <div class="stat_item">
                        <span class="stat_number">15</span>
                        <span class="stat_label">레시피</span>
                    </div>
                    <div class="stat_item">
                        <span class="stat_number">142</span>
                        <span class="stat_label">팔로워</span>
                    </div>
                    <div class="stat_item">
                        <span class="stat_number">56</span>
                        <span class="stat_label">팔로잉</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 탭 메뉴 -->
    <div class="mypage_tabs">
        <button class="tab_btn active" onclick="location.href='my_recipe'">내 레시피</button>
        <button class="tab_btn" data-tab="saved_recipes">저장한 레시피</button>
        <button class="tab_btn" data-tab="liked_recipes">좋아요한 레시피</button>
        <button class="tab_btn" data-tab="account_settings">계정 설정</button>
    </div>

   <!-- 내 레시피 탭 -->
   <div class="tab_content active" id="my_recipes">
       <div class="tab_header">
           <h3>내 레시피</h3>
           <button class="add_recipe_btn"><i class="fas fa-plus"></i> 새 레시피 등록</button>
       </div>
       <div class="recipe_grid">
           <% for(int i=1; i<=16; i++) { %>
               <div class="recipe_card">
                   <div class="recipe_image">
                       <img alt="food" src="${pageContext.request.contextPath}/resources/image/food.jpg">
                       <div class="recipe_overlay">
                           <a href="#" class="btn_view">레시피 보기</a>
                       </div>
                       <div class="recipe_actions">
                           <button class="recipe_action_btn edit_btn"><i class="fas fa-edit"></i></button>
                           <button class="recipe_action_btn delete_btn"><i class="fas fa-trash"></i></button>
                       </div>
                   </div>
                   <div class="recipe_info">
                       <h3><a href="#">매콤한 떡볶이 <%= i %></a></h3>
                       <p>집에서 간단하게 만드는 매콤달콤 떡볶이</p>
                       <div class="recipe_meta">
                           <div class="recipe_rating">
                               <i class="fas fa-star"></i>
                               <i class="fas fa-star"></i>
                               <i class="fas fa-star"></i>
                               <i class="fas fa-star"></i>
                               <i class="far fa-star"></i>
                               <span>(32)</span>
                           </div>
                           <div class="recipe_time">
                               <i class="far fa-clock"></i> 30분
                           </div>
                       </div>
                   </div>
               </div>
           <% } %>
       </div>
       <div class="pagination">
           <button class="pagination_btn prev_page"><i class="fas fa-chevron-left"></i></button>
           <button class="pagination_btn active" data-page="1">1</button>
           <button class="pagination_btn next_page"><i class="fas fa-chevron-right"></i></button>
       </div>
   </div>


    <!-- 저장한 레시피 탭 (기본적으로 숨겨짐) -->
    <div class="tab_content" id="saved_recipes">
        <div class="tab_header">
            <h3>저장한 레시피</h3>
        </div>
        <div class="recipe_grid">
            <!-- 저장한 레시피 카드들 -->
        </div>
    </div>

    <!-- 좋아요한 레시피 탭 (기본적으로 숨겨짐) -->
    <div class="tab_content" id="liked_recipes">
        <div class="tab_header">
            <h3>좋아요한 레시피</h3>
        </div>
        <div class="recipe_grid">
            <!-- 좋아요한 레시피 카드들 -->
        </div>
    </div>

    <!-- 계정 설정 탭 (기본적으로 숨겨짐) -->
    <div class="tab_content" id="account_settings">
        <div class="tab_header">
            <h3>계정 설정</h3>
        </div>
        <div class="settings_form">
        </div>
    </div>
    
    <div class="tab_content" id="nickname_settings">
        <div class="tab_header">
            <h3>닉네임 변경</h3>
        </div>
        <div class="settings_form">
        </div>
    </div>
</div>