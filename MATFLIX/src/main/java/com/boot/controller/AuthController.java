package com.boot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuthController {

	private final SessionRegistry sessionRegistry;

	@GetMapping("/session_check")
	@ResponseBody
	public Map<String, Object> session_check(HttpServletRequest request) {

		Map<String, Object> result = new HashMap<>();

		HttpSession session = request.getSession(false);
		if (session == null) {
			result.put("ok", false);
			result.put("reason", "NO_SESSION");
			return result;
		}

		SessionInformation info = sessionRegistry.getSessionInformation(session.getId());
		if (info != null && info.isExpired()) {
			result.put("ok", false);
			result.put("reason", "DUP_LOGIN");
			return result;
		}

		result.put("ok", true);
		return result;
	}
}