$(document).ready(function() {
    // 스크롤 상단 버튼
    $(window).scroll(function() {
        if ($(this).scrollTop() > 300) {
            $('#page_up').addClass('visible');
        } else {
            $('#page_up').removeClass('visible');
        }
    });
    
    $('#page_up').click(function() {
        $('html, body').animate({scrollTop: 0}, 500);
        return false;
    });
    
    // 모바일 메뉴 토글
    $('.menu-toggle').click(function() {
        $('.nav-container').toggleClass('active');
    });
    
    // 검색창 포커스 효과
    $('.search-input').focus(function() {
        $(this).parent().addClass('focused');
    }).blur(function() {
        $(this).parent().removeClass('focused');
    });
    
    // 프로필 이미지 클릭 시 마이페이지로 이동
    $('.profile_image').click(function() {
        window.location.href = '/profile';
    });
    
    // 드롭다운 메뉴 (모바일에서 클릭으로 작동)
    if (window.innerWidth <= 768) {
        $('.nav-item.dropdown').click(function(e) {
            e.preventDefault();
            $(this).toggleClass('active');
            $(this).find('.dropdown-content').slideToggle(200);
        });
    }
});

// 마이페이지 이동 함수
function my_page() {
    window.location.href = '/profile';
}