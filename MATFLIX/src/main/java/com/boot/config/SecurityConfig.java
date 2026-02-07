package com.boot.config;

import java.io.IOException;

import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.session.SessionInformationExpiredStrategy;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.boot.dao.TeamDAO;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

	private final TeamDAO teamDAO; // 필터에 넘겨줄 용도

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public SessionRegistry sessionRegistry() {
		return new SessionRegistryImpl();
	}

//	@Bean
//	public HttpSessionEventPublisher httpSessionEventPublisher() {
//		return new HttpSessionEventPublisher();
//	}

	@Bean
	public ServletListenerRegistrationBean<HttpSessionEventPublisher> http_session_event_publisher() {
		ServletListenerRegistrationBean<HttpSessionEventPublisher> bean = new ServletListenerRegistrationBean<>(
				new HttpSessionEventPublisher());
		bean.setOrder(0);
		return bean;
	}

	@Bean
	public SessionInformationExpiredStrategy session_expired_strategy() {
		return event -> {
			try {
				// 여기서 세션 invalidate까지 같이 해주면 "session user"도 같이 날아감
				if (event.getRequest().getSession(false) != null) {
					event.getRequest().getSession(false).invalidate();
				}
				event.getResponse().sendRedirect("/login?dup=1");
			} catch (IOException e) {
				throw new RuntimeException(e);
			}
		};
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.csrf(csrf -> csrf.disable()).authorizeHttpRequests(auth -> auth
				// 관리자 경로는 admin만
				.requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN")
				// 비로그인 유저도 모두 허용
				.anyRequest().permitAll())
				.formLogin(form -> form.loginPage("/login").defaultSuccessUrl("/main").permitAll())
				.logout(logout -> logout.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
						.logoutSuccessUrl("/main").invalidateHttpSession(true))
				.sessionManagement(session -> session.maximumSessions(1).maxSessionsPreventsLogin(true)
						.sessionRegistry(sessionRegistry()).expiredSessionStrategy(session_expired_strategy()));

		// 모든 요청 전에 유저 상태를 체크
		http.addFilterAfter(new UserStatusCheckFilter(teamDAO, sessionRegistry()),
				UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}
}