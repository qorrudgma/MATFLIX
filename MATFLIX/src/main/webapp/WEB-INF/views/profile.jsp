<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function() {
    $('.tab_btn[data-tab="account_settings"]').on('click', function() {
      window.location.href = '/account';
    });
  });
</script>
<div class="mypage_container">
    <!-- 프로필 섹션 -->
<section class="profile_section">
        <div class="profile_header">
            <div class="profile_image_large">
                <img src="${pageContext.request.contextPath}/resources/image/MATFLIX.png" alt="프로필 이미지">
                <button class="edit_profile_image"><i class="fas fa-camera"></i></button>
            </div>
            <div class="profile_info_container">
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
        <button class="tab_btn active" data-tab="my_recipes">내 레시피</button>
        <a href="${pageContext.request.contextPath}/favorites/recipe/myFavoriteRecipes" class="btn btn-primary">나의 즐겨찾기 보기</a>
        <button class="tab_btn" data-tab="liked_recipes">추천한 레시피</button>
        <button class="tab_btn" data-tab="account_settings">계정 설정</button>
    </div>

    <!-- 내 레시피 탭 -->

</div>