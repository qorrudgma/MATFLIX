/*==========================================================
* 파일명     : KakaoAuthController.java
* 작성자     : 손병관
* 작성일자   : 2025-05-12
* 설명       : 이 클래스는 [카카오 소셜 로그인을 구현한 controller 입니다.]


* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-10   손병관       최초 생성
* 2025-05-11   손병관       기본적인 로직 생성
* 2025-05-12   손병관       카카오 소셜 로그인 DB 저장 완료
============================================================*/
package com.boot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.boot.dto.TeamDTO;
import com.boot.service.KakaoUserService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/login/oauth2/code")
@Slf4j
public class KakaoAuthController {

	@Value("${kakao.client-id}")
	private String clientId;

	@Value("${kakao.client-secret:}") // 비워두면 빈 문자열
	private String clientSecret;

	@Autowired
	private KakaoUserService kakaoUserService;

	@GetMapping("/kakao")
	public String kakaoCallback(@RequestParam String code, HttpSession session, HttpServletRequest request) {
		String accessToken = getAccessToken(code);
		Map<String, Object> userInfo = getUserInfo(accessToken);

		String kakaoId = "kakao_" + userInfo.get("id");
		String nickname = (String) userInfo.get("nickname");
		String email = (String) userInfo.get("email");

		TeamDTO existing = kakaoUserService.findById(kakaoId);
		TeamDTO dto = new TeamDTO();

		if (existing == null) {
			dto.setMf_id(kakaoId);
			dto.setMf_pw("kakao_login");
			dto.setMf_pw_chk("kakao_login");
			dto.setMf_name(nickname);
			dto.setMf_nickname(nickname);
			dto.setMf_email(email);
			dto.setMf_role("USER");
			kakaoUserService.register(dto);
		} else {
			dto = existing; // ✅ 기존 유저 정보를 dto에 대입
		}

		session.setAttribute("user", dto);
		session.setAttribute("loginId", kakaoId);
		log.info("@# user => " + dto);

		return "redirect:/main";
	}

	private String getAccessToken(String code) {
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", clientId);
		if (!clientSecret.isEmpty()) {
			params.add("client_secret", clientSecret);
		}
		params.add("redirect_uri", "http://localhost:8485/login/oauth2/code/kakao");
		params.add("code", code);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

		try {
			ResponseEntity<Map> response = restTemplate.postForEntity("https://kauth.kakao.com/oauth/token", request,
					Map.class);
			Map<String, Object> body = response.getBody();
			return (String) body.get("access_token");
		} catch (HttpClientErrorException e) {
			log.error("▶ Kakao 토큰 요청 실패 ▶ status: {} / body: {}", e.getStatusCode(), e.getResponseBodyAsString());
			throw e;
		}
	}

	private Map<String, Object> getUserInfo(String token) {
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(token);
		headers.set("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);

		HttpEntity<?> request = new HttpEntity<>(headers);

		try {
			ResponseEntity<Map> response = restTemplate.exchange("https://kapi.kakao.com/v2/user/me", HttpMethod.GET,
					request, Map.class);
			Map<String, Object> body = response.getBody();
			@SuppressWarnings("unchecked")
			Map<String, Object> kakaoAccount = (Map<String, Object>) body.get("kakao_account");
			@SuppressWarnings("unchecked")
			Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");

			Map<String, Object> result = new HashMap<>();
			result.put("id", body.get("id"));
			result.put("email", kakaoAccount.get("email"));
			result.put("nickname", profile.get("nickname"));
			return result;
		} catch (HttpClientErrorException e) {
			log.error("▶ Kakao 사용자 정보 요청 실패 ▶ status: {} / body: {}", e.getStatusCode(), e.getResponseBodyAsString());
			throw e;
		} catch (RestClientException e) {
			log.error("▶ Kakao 사용자 정보 요청 중 예외 ▶ message: {}", e.getMessage());
			throw e;
		}
	}

}
