package com.boot.config;

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

	@Bean
	public HttpSessionEventPublisher httpSessionEventPublisher() {
		return new HttpSessionEventPublisher();
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
				.sessionManagement(session -> session.maximumSessions(1) // 중복 로그인 방지
						.sessionRegistry(sessionRegistry()));

		// 모든 요청 전에 유저 상태를 체크
		http.addFilterAfter(new UserStatusCheckFilter(teamDAO), UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}
}