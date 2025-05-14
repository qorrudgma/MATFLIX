// 전역 변수 선언
let currentBannerIndex = 0;
let bannerInterval;
let touchStartX = 0;
let touchEndX = 0;

// DOM이 완전히 로드된 후 실행
document.addEventListener('DOMContentLoaded', function() {
    console.log('메인 스크립트 초기화 중...');
    
    // 배너 슬라이더 초기화
    initBannerSlider();
    
    // 레시피 슬라이더 초기화
    initRecipeSliders();
    
    console.log('메인 스크립트 초기화 완료');
});

// 배너 슬라이더 초기화 함수
function initBannerSlider() {
    const bannerSlider = document.getElementById('bannerSlider');
    const bannerIndicators = document.getElementById('bannerIndicators');
    
    // 배너 슬라이더가 존재하는지 확인
    if (!bannerSlider || !bannerIndicators) {
        console.error('배너 슬라이더 요소를 찾을 수 없습니다.');
        return;
    }
    
    const bannerSlides = bannerSlider.querySelectorAll('.banner-slide');
    
    // 배너 슬라이드가 존재하는지 확인
    if (bannerSlides.length === 0) {
        console.error('배너 슬라이드를 찾을 수 없습니다.');
        return;
    }
    
    console.log(`${bannerSlides.length}개의 배너 슬라이드를 발견했습니다.`);
    
    // 첫 번째 슬라이드 활성화
    bannerSlides[0].classList.add('active');
    
    // 배너 인디케이터 생성
    bannerIndicators.innerHTML = ''; // 기존 인디케이터 제거
    for (let i = 0; i < bannerSlides.length; i++) {
        const indicator = document.createElement('div');
        indicator.className = 'banner-indicator' + (i === 0 ? ' active' : '');
        indicator.onclick = function() {
            goToBanner(i);
        };
        bannerIndicators.appendChild(indicator);
    }
    
    // 배너 이미지 로드 확인
    bannerSlides.forEach((slide, index) => {
        const img = slide.querySelector('img');
        if (img) {
            // 이미지 로드 이벤트 리스너 추가
            img.addEventListener('load', function() {
                console.log(`배너 이미지 ${index + 1} 로드 완료`);
            });
            
            img.addEventListener('error', function() {
                console.error(`배너 이미지 ${index + 1} 로드 실패`);
                // 이미지 로드 실패 시 대체 이미지 표시
                img.src = `${window.location.origin}/images/default-banner.jpg`;
            });
            
            // 이미지가 이미 캐시되어 있는 경우를 위한 처리
            if (img.complete) {
                console.log(`배너 이미지 ${index + 1}이 이미 로드되어 있습니다.`);
            }
        }
    });
    
    // 배너 화살표 이벤트 리스너 설정
    const prevArrow = document.querySelector('.banner-arrow.prev');
    const nextArrow = document.querySelector('.banner-arrow.next');
    
    if (prevArrow) {
        prevArrow.addEventListener('click', function() {
            moveBanner(-1);
        });
    }
    
    if (nextArrow) {
        nextArrow.addEventListener('click', function() {
            moveBanner(1);
        });
    }
    
    // 배너 컨테이너에 마우스 이벤트 리스너 추가
    const bannerContainer = document.querySelector('.banner-slider-container');
    if (bannerContainer) {
        bannerContainer.addEventListener('mouseenter', function() {
            console.log('배너에 마우스 오버, 자동 슬라이드 중지');
            clearInterval(bannerInterval);
        });
        
        bannerContainer.addEventListener('mouseleave', function() {
            console.log('배너에서 마우스 아웃, 자동 슬라이드 재개');
            startAutoSlide();
        });
        
        // 터치 이벤트 리스너 추가
        bannerContainer.addEventListener('touchstart', function(e) {
            touchStartX = e.changedTouches[0].screenX;
            clearInterval(bannerInterval); // 터치 시 자동 슬라이드 중지
        }, false);
        
        bannerContainer.addEventListener('touchend', function(e) {
            touchEndX = e.changedTouches[0].screenX;
            const swipeThreshold = 50;
            if (touchEndX < touchStartX - swipeThreshold) {
                // 왼쪽으로 스와이프
                moveBanner(1);
            } else if (touchEndX > touchStartX + swipeThreshold) {
                // 오른쪽으로 스와이프
                moveBanner(-1);
            }
            startAutoSlide(); // 터치 종료 후 자동 슬라이드 재개
        }, false);
    }
    
    // 자동 슬라이드 시작
    startAutoSlide();
    
    // 페이지 가시성 변경 이벤트 리스너 추가
    document.addEventListener('visibilitychange', function() {
        if (document.hidden) {
            // 페이지가 보이지 않을 때 자동 슬라이드 중지
            clearInterval(bannerInterval);
        } else {
            // 페이지가 다시 보일 때 자동 슬라이드 재개
            startAutoSlide();
        }
    });
}

// 레시피 슬라이더 초기화 함수
function initRecipeSliders() {
    const recipeSliders = document.querySelectorAll('.recipe-slider');
    
    recipeSliders.forEach(slider => {
        // 터치 이벤트 리스너 추가
        slider.addEventListener('touchstart', function(e) {
            touchStartX = e.changedTouches[0].screenX;
        }, false);
        
        slider.addEventListener('touchend', function(e) {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe(slider);
        }, false);
        
        // 슬라이더 버튼 이벤트 리스너 추가
        const prevBtn = slider.parentElement.querySelector('.prev-btn');
        const nextBtn = slider.parentElement.querySelector('.next-btn');
        
        if (prevBtn) {
            prevBtn.addEventListener('click', function() {
                slideRecipes(slider.id, -1);
            });
        }
        
        if (nextBtn) {
            nextBtn.addEventListener('click', function() {
                slideRecipes(slider.id, 1);
            });
        }
    });
}

// 배너 이동 함수
function moveBanner(direction) {
    const bannerSlider = document.getElementById('bannerSlider');
    const bannerSlides = bannerSlider.querySelectorAll('.banner-slide');
    
    // 현재 활성화된 슬라이드 비활성화
    bannerSlides[currentBannerIndex].classList.remove('active');
    
    // 새로운 인덱스 계산
    currentBannerIndex += direction;
    
    if (currentBannerIndex < 0) {
        currentBannerIndex = bannerSlides.length - 1;
    } else if (currentBannerIndex >= bannerSlides.length) {
        currentBannerIndex = 0;
    }
    
    // 새 슬라이드 활성화
    bannerSlides[currentBannerIndex].classList.add('active');
    
    updateBannerIndicators();
}

// 특정 배너로 이동
function goToBanner(index) {
    const bannerSlider = document.getElementById('bannerSlider');
    const bannerSlides = bannerSlider.querySelectorAll('.banner-slide');
    
    // 현재 활성화된 슬라이드 비활성화
    bannerSlides[currentBannerIndex].classList.remove('active');
    
    // 새 인덱스 설정
    currentBannerIndex = index;
    
    // 새 슬라이드 활성화
    bannerSlides[currentBannerIndex].classList.add('active');
    
    updateBannerIndicators();
    resetAutoSlide(); // 수동으로 이동 시 타이머 재설정
}

// 배너 인디케이터 업데이트
function updateBannerIndicators() {
    const bannerIndicators = document.getElementById('bannerIndicators');
    if (!bannerIndicators) return;
    
    // 인디케이터 업데이트
    const indicators = bannerIndicators.querySelectorAll('.banner-indicator');
    indicators.forEach((indicator, index) => {
        indicator.className = 'banner-indicator' + (index === currentBannerIndex ? ' active' : '');
    });
}

// 자동 슬라이드 시작 함수
function startAutoSlide() {
    // 기존 인터벌이 있으면 제거
    if (bannerInterval) {
        clearInterval(bannerInterval);
    }
    
    bannerInterval = setInterval(function() {
        moveBanner(1);
    }, 5000); // 5초마다 슬라이드
}

// 자동 슬라이드 재설정 함수
function resetAutoSlide() {
    clearInterval(bannerInterval);
    startAutoSlide();
}

// 레시피 슬라이더 기능
function slideRecipes(sliderId, direction) {
    const slider = document.getElementById(sliderId);
    if (!slider) return;
    
    const cards = slider.querySelectorAll('.recipe-card');
    if (cards.length === 0) return;
    
    const cardWidth = cards[0].offsetWidth + 20; // 카드 너비 + 마진
    const scrollAmount = cardWidth * Math.min(3, cards.length) * direction; // 한 번에 최대 3개씩 이동
    
    slider.scrollBy({
        left: scrollAmount,
        behavior: 'smooth'
    });
}

// 스와이프 처리 함수
function handleSwipe(slider) {
    const swipeThreshold = 50;
    if (touchEndX < touchStartX - swipeThreshold) {
        // 왼쪽으로 스와이프
        slideRecipes(slider.id, 1);
    } else if (touchEndX > touchStartX + swipeThreshold) {
        // 오른쪽으로 스와이프
        slideRecipes(slider.id, -1);
    }
}
