package com.boot.controller;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final CustomOAuth2Success customOAuth2Success;
    private final CustomLogoutSuccessHandler customLogoutSuccessHandler;
    private final ClientRegistrationRepository clientRegistrationRepository;
    public SecurityConfig(CustomOAuth2Success customOAuth2Success, CustomLogoutSuccessHandler customLogoutSuccessHandler,ClientRegistrationRepository clientRegistrationRepository) {
        this.customOAuth2Success = customOAuth2Success;
        this.customLogoutSuccessHandler = customLogoutSuccessHandler;
        this.clientRegistrationRepository = clientRegistrationRepository;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/main", "/custom_login/**", "/css/**", "/js/**", "/images/**", "/**").permitAll()
                .anyRequest().authenticated()  // 인증이 필요한 URL 설정
            .and()
            .oauth2Login()
                .loginPage("/custom_login")  // 커스텀 로그인 페이지
                .authorizationEndpoint()
                .authorizationRequestResolver(
                    new CustomAuthorizationRequestResolver(clientRegistrationRepository)
                )
            .and()
                .successHandler(customOAuth2Success)
            .and()
            .logout()
                .logoutUrl("/log_out")  // 로그아웃 URL
                .logoutSuccessUrl("/main")  // 로그아웃 후 리디렉션
                .logoutSuccessHandler(customLogoutSuccessHandler)  // 로그아웃 성공 후 처리
                .invalidateHttpSession(true)  // 세션 무효화
                .deleteCookies("JSESSIONID", "OAuth_Token")  // 쿠키 삭제
                .permitAll();  // 로그아웃 URL을 누구나 접근 가능하게 설정

        return http.build();
    }
}
