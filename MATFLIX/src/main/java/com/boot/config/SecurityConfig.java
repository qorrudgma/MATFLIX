package com.boot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
public class SecurityConfig {

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

//		http.csrf(csrf -> csrf.disable()).authorizeHttpRequests(auth -> auth.anyRequest().permitAll())
//				.formLogin(form -> form.disable());
		http.csrf(csrf -> csrf.disable()).authorizeHttpRequests(auth -> auth
				// /admin/** 경로는 ADMIN 권한만 접근 가능
				.requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN")
				// 나머지 요청은 로그인된 사용자만 접근 가능
				.anyRequest().permitAll()).formLogin(form -> form.disable());

		return http.build();
	}
}