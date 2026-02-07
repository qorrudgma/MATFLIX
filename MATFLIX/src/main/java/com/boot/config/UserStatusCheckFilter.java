package com.boot.config;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.web.filter.OncePerRequestFilter;

import com.boot.dao.TeamDAO;
import com.boot.dto.TeamDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class UserStatusCheckFilter extends OncePerRequestFilter {

	private final TeamDAO teamDAO;
	private final SessionRegistry sessionRegistry;

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		// 중복 로그인으로 "만료된 세션"이면 즉시 강제 로그아웃 + 세션 완전 제거
		HttpSession session = request.getSession(false);
		if (session != null) {
			String sessionId = session.getId();
			SessionInformation info = sessionRegistry.getSessionInformation(sessionId);

			if (info != null && info.isExpired()) {
				Authentication auth = SecurityContextHolder.getContext().getAuthentication();
				new SecurityContextLogoutHandler().logout(request, response, auth);
				// logout이 invalidate 처리하지만, 혹시 몰라서 한 번 더 안전 처리
				try {
					session.invalidate();
				} catch (IllegalStateException e) {
					// 이미 invalidate 된 경우 무시
				}
				response.sendRedirect("/login?dup=1");
				return;
			}
		}

//		System.out.println("====== 필터 통과 중: " + request.getRequestURI());
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		if (auth != null && auth.isAuthenticated()) {
			String userId = "";

			// Principal 타입에 따라 ID 추출
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