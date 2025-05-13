package com.boot.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.security.oauth2.core.user.OAuth2User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * OAuth2 로그인/로그아웃 커스텀 핸들러 통합
 */
@Component
public class CustomOAuth2Success implements AuthenticationSuccessHandler {

    private static final Logger logger = LoggerFactory.getLogger(CustomOAuth2Success.class);

    // ✅ 로그인 성공 핸들러
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        // 네이버는 응답 속 response 안에 사용자 정보 있음
        Map<String, Object> attributes = oAuth2User.getAttributes();
        
        String registrationId = request.getRequestURI().contains("google")? "google" :
        						request.getRequestURI().contains("kakao")? "kakao" : "naver";
        
        String name =  null;
        String email = null;
        switch (registrationId) {
		case "google":
			name = (String) attributes.get("name");
			email = (String) attributes.get("email");
			logger.info("✅ 구글 로그인 성공 - 이름: {}, 이메일: {}", name, email);
			break;
		case "naver":
			Map<String, Object> responseMap = (Map<String, Object>) attributes.get("response");
			name = (String) responseMap.get("name");
			email = (String) responseMap.get("email");
			logger.info("✅ 네이버 로그인 성공 - 이름: {}, 이메일: {}", name, email);
			break;
		default:
			logger.warn("⚠️ response가 null입니다. 전체 Attributes: {}", attributes);
		}
//        Map<String, Object> responseMap = (Map<String, Object>) attributes.get("response");
//
//        if (responseMap != null) {
//            String name = (String) responseMap.get("name");
//            String email = (String) responseMap.get("email");
//
//            logger.info("✅ 네이버 로그인 성공 - 이름: {}, 이메일: {}", name, email);
//        } else {
//            logger.warn("⚠️ response가 null입니다. 전체 Attributes: {}", attributes);
//        }

        response.sendRedirect("/main");
    }


}
