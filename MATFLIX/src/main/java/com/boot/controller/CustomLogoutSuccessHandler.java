package com.boot.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

    private static final Logger logger = LoggerFactory.getLogger(CustomLogoutSuccessHandler.class);

    // ✅ 로그아웃 성공 핸들러
    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response,
                                Authentication authentication) throws IOException, ServletException {
    	logger.info("로그아웃 요청이 들어왔습니다.");
        if (authentication != null) {
            logger.info("👋 로그아웃 성공 - 사용자: {}", authentication.getName());
        } else {
            logger.info("👋 로그아웃 성공 - 익명 사용자 로그아웃");
        }
        request.getSession().invalidate(); // 세션 무효화
        
//     // 쿠키 삭제 (JSESSIONID 및 OAuth 관련 쿠키)
//        Cookie jsessionCookie = new Cookie("JSESSIONID", null);
//        jsessionCookie.setMaxAge(0);  // 쿠키 삭제
//        jsessionCookie.setPath("/");   // 사이트 전체에서 쿠키 유효하도록 설정
//        response.addCookie(jsessionCookie);
//
//        Cookie oauthCookie = new Cookie("OAuth_Token", null);
//        oauthCookie.setMaxAge(0);  // 쿠키 삭제
//        oauthCookie.setPath("/");   // 사이트 전체에서 쿠키 유효하도록 설정
//        response.addCookie(oauthCookie);
        // 현재 쿠키 확인 및 삭제
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                logger.info("🔍 현재 쿠키: 이름 = {}, 값 = {}", cookie.getName(), cookie.getValue());

                if ("JSESSIONID".equals(cookie.getName()) || "OAuth_Token".equals(cookie.getName())) {
                    Cookie deleteCookie = new Cookie(cookie.getName(), null);
                    deleteCookie.setMaxAge(0);
                    deleteCookie.setPath("/");
                    response.addCookie(deleteCookie);
                    logger.info("❌ 쿠키 삭제: {}", cookie.getName());
                }
            }
        } else {
            logger.info("⚠️ 쿠키 없음");
        }

        response.sendRedirect("/main");  // 로그아웃 후 리디렉션할 URL (메인 페이지나 로그인 페이지로 리디렉션)
    }
}