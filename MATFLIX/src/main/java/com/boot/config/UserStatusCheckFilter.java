package com.boot.config;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.web.filter.OncePerRequestFilter;

import com.boot.dao.TeamDAO;
import com.boot.dto.TeamDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class UserStatusCheckFilter extends OncePerRequestFilter {

	private final TeamDAO teamDAO;

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

//		System.out.println("====== 필터 통과 중: " + request.getRequestURI());
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		if (auth != null && auth.isAuthenticated()) {
			String userId = "";

			// Principal 타입에 따라 ID 추출 (핵심 수정 부분)
			if (auth.getPrincipal() instanceof CustomUserDetails) {
				userId = ((CustomUserDetails) auth.getPrincipal()).getUsername();
			} else if (auth.getPrincipal() instanceof String) {
				userId = (String) auth.getPrincipal(); // 로그상 "banned"가 여기 해당됨
			}

//			System.out.println("## 찾아낼 ID: " + userId);

			if (!userId.equals("") && !userId.equals("anonymousUser")) {
				// DB에서 실시간 상태 조회
				TeamDTO user = teamDAO.find_list(userId);
//				System.out.println("## DB에서 가져온 데이터: " + user);

				if (user != null) {
//					System.out.println("## DB 상태값 확인: " + user.getStatus());

					// 상태가 ACTIVE가 아니면 즉시 추방
					if (!"ACTIVE".equals(user.getStatus())) {
						System.out.println("!!! 차단된 유저 감지 - 로그아웃 처리 시작 !!!");
						new SecurityContextLogoutHandler().logout(request, response, auth);
						response.sendRedirect("/login?error=banned");
						return;
					}
				}
			}
		}
		filterChain.doFilter(request, response);
	}
}