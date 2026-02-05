package com.boot.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.BoardDTO;
import com.boot.dto.FavoriteRecipeDTO;
import com.boot.dto.NotifSettingDTO;
import com.boot.dto.ProfileDTO;
import com.boot.dto.ProfileImageDTO;
import com.boot.dto.RecipeDTO;
import com.boot.dto.TeamDTO;
import com.boot.dto.WithdrawDTO;
import com.boot.service.BoardService;
import com.boot.service.EmailService;
import com.boot.service.FavoriteRecipeService;
import com.boot.service.FileStorageService;
import com.boot.service.FollowService;
import com.boot.service.NotifSettingService;
import com.boot.service.NotificationService;
import com.boot.service.RecipeService;
import com.boot.service.RecommendService;
import com.boot.service.TeamService;
import com.boot.util.TimeUtil;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
//@RequestMapping("/member")
public class TeamController {

	@Autowired
	private TeamService service;

	@Autowired
	private EmailService emailService;

	@Autowired
	private FollowService followService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private RecipeService recipeService;

	@Autowired
	private RecommendService recommendService;

	@Autowired
	private FavoriteRecipeService favoriteRecipeService;

	@Autowired
	private NotifSettingService notifSettingService;

	@Autowired
	private FileStorageService fileStorageService;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	@Autowired
	private SessionRegistry sessionRegistry;

	// 프로필 보기
	@RequestMapping("/profile")
	public String profile(HttpSession session, Model model) throws Exception {
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			log.info("@#user => " + user);
			return "redirect:/"; // 로그인 안 되어 있으면 로그인 페이지로
		}

		int mf_no = user.getMf_no();
		ProfileDTO profile = service.profile(mf_no);

//		List<Map<String, Object>> profile_board = boardService.profile_board_list(user.getMf_no());
//		log.info(profile_board + "");
//		for (int i = 0; i < profile_board.size(); i++) {
//			Map<String, Object> board = profile_board.get(i);
//			int boardNo = (int) board.get("boardNo");
//			int recommend_count = recommendService.total_recommend(boardNo);
//			board.put("recommend_count", recommend_count);
//		}

		List<RecipeDTO> my_recipe = recipeService.my_recipe_list(mf_no);
		for (RecipeDTO c : my_recipe) {
			c.setDisplay_time(TimeUtil.formatDate(c.getCreated_at()));
		}
//		int mfNo = user.getMf_no();

//		int user_follow_count = followService.user_follow_count(mfNo);
//		int user_follower_count = followService.user_follower_count(mfNo);

		model.addAttribute("my_recipe", my_recipe);
		model.addAttribute("profile", profile);
//		model.addAttribute("profile_board", profile_board);
//		model.addAttribute("user_follow_count", user_follow_count);
//		model.addAttribute("user_follower_count", user_follower_count);

		return "profile";
	}

	// 프로필 이미지
	@PostMapping("/profile_image")
	@ResponseBody
	public String profile_image(String profile_image_path, MultipartFile image_file, HttpSession session) {
		log.info("profile_image()");
		log.info("image_path => {}, image_file => {}", profile_image_path, image_file);
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			throw new RuntimeException("로그인 필요");
		}
		int mf_no = user.getMf_no();
		ProfileImageDTO PIDTO = new ProfileImageDTO();
		PIDTO.setMf_no(mf_no);
		PIDTO.setProfile_image_path(profile_image_path);
		PIDTO.setImage_file(image_file);

		fileStorageService.modify_profile_image(PIDTO);
		return "";
	}

	// 프로필 즐겨찾기
	@PostMapping("/favorite_recipe_list")
	@ResponseBody
	public List<FavoriteRecipeDTO> favorite_recipe_list(HttpSession session) {
		log.info("favorite_recipe_list()");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			throw new RuntimeException("로그인 필요");
		}
		int mf_no = user.getMf_no();
		List<FavoriteRecipeDTO> favorite_recipe_list = favoriteRecipeService.favorite_recipe_list(mf_no);
		for (FavoriteRecipeDTO c : favorite_recipe_list) {
			c.setDisplay_time(TimeUtil.formatDate(c.getCreated_at()));
		}
		log.info("favorite_recipe_list=> " + favorite_recipe_list);
		return favorite_recipe_list;
	}

	// 프로필 내 게시글
	@PostMapping("/my_board_list")
	@ResponseBody
	public List<BoardDTO> my_board_list(HttpSession session) {
		log.info("my_board_list()");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			throw new RuntimeException("로그인 필요");
		}
		int mf_no = user.getMf_no();
		List<BoardDTO> my_board_list = boardService.my_board_list(mf_no);
		log.info("my_board_list=> " + my_board_list);
		return my_board_list;
	}

	@PostMapping("/withdraw")
	@ResponseBody
	@Transactional
	public Map<String, String> withdraw(@RequestBody WithdrawDTO dto, HttpSession session) {
		log.info("WithdrawDTO => " + dto);
		Map<String, String> result = new HashMap<>();
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		log.info("user.getMf_no() => " + user.getMf_no());
		int mf_no = user.getMf_no();
		String encodedPw = service.pw_check(mf_no);
		log.info("encodedPw => " + encodedPw);

		// BCrypt 비교
		if (!passwordEncoder.matches(dto.getMf_pw(), encodedPw)) {
			result.put("message", "비밀번호가 일치하지 않습니다.");
			log.info("result => " + result);
			return result;
		}
		dto.setMf_no(mf_no);
		service.member_withdraw_reason(dto);
		session.invalidate(); // 로그아웃
		service.delete_ok(mf_no);

		result.put("message", "회원 탈퇴 완료");
		result.put("result", "delete");
		log.info("result => " + result);
		return result;
	}

	// ========================================================
	// 탈퇴 페이지 이동
	@RequestMapping("/delete_member")
	public String delete_member(HttpSession session, Model model) {
		log.info("삭제하러옴");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			return "redirect:/";
		}
		model.addAttribute("mf_id", user.getMf_id());
		return "delete_member";
	}

	// 탈퇴 처리 (비밀번호 확인 포함)
	@PostMapping("/delete_member_check")
	@ResponseBody
	public String delete_member_check(@RequestParam("mf_id") String mf_id, @RequestParam("mf_pw") String mf_pw,
			HttpSession session) {
		log.info("탈퇴 버튼 누름");
		TeamDTO user = (TeamDTO) session.getAttribute("user"); // 기존 비밀번호 확인용
		int mf_no = user.getMf_no();
		String pw_check = service.pw_check(mf_no); // 기존 비밀번호 확인용
		if (pw_check != null && pw_check.equals(mf_pw)) {
			service.delete_ok(mf_no); // delete_ok에 바로 mf_id 전달
			session.invalidate(); // 세션 종료
			log.info("삭제 및 세션 종료");
			return "available";
		} else {
			return "unavailable";
		}
//		return "";
	}
	// ========================================================

	// 계정설정 비밀번호 확인 이동
	@RequestMapping("/member_check")
	public String member_check(@RequestParam("mf_id") String mf_id, Model model) {
		model.addAttribute("mf_id", mf_id);
		return "member_check";
	}

	// 계정설정 비밀번호 확인
	@RequestMapping("/member_check_ok")
	@ResponseBody
	public String member_check_ok(@RequestParam("mf_id") String mf_id, @RequestParam("mf_pw") String mf_pw) {
		log.info("member_check_ok()");
		boolean check_ok = false;
		TeamDTO dto = service.login(mf_id, mf_pw);
		if (dto != null) {
			check_ok = true;
		}
		return check_ok ? "available" : "unavailable";
	}

	// 회원정보 수정 후 자동 로그아웃
	@RequestMapping("/mem_update")
	@ResponseBody
	public Map<String, Object> mem_update(@RequestParam HashMap<String, String> param, HttpSession session) {
		log.info("mem_update()");
		service.update_ok(param);
		session.invalidate(); // 로그아웃 처리

		Map<String, Object> result = new HashMap<>();
		result.put("status", "success");
		result.put("redirect", "/login");
		return result;
	}

	// 회원가입
	@RequestMapping("/recruit")
	public String recruit() {
		return "recruit";
	}

	// 로그인
	@RequestMapping("/login")
	public String login() {
		return "login";
	}

	// 로그인 가능 여부 확인
	@PostMapping("/main_membership")
	public String login_ok(@RequestParam("mf_id") String mf_id, @RequestParam("mf_pw") String mf_pw,
			@RequestParam(required = false) String remember, HttpServletResponse response, HttpServletRequest request,
			Model model) {
//		int result = service.login(mf_id, mf_pw);
//		log.info("@# result =>" + result);
		int find_id = service.find_id(mf_id);
		if (find_id == 1) {
			TeamDTO user = service.login(mf_id, mf_pw);
			if (user == null) {
				model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
				log.info("로그인 실패");
				return "login"; // 로그인 실패 시 다시 로그인 페이지로
			}
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			log.info("user => " + user);

			// Security 권한 추가
			UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(user.getMf_id(), null,
					Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getMf_role())));
			SecurityContextHolder.getContext().setAuthentication(auth);
			sessionRegistry.registerNewSession(session.getId(), auth.getPrincipal());
//			TeamDTO user = (TeamDTO) session.getAttribute("user");

			int notification_count = notificationService.notification_count(user.getMf_no());
			log.info("notification_count => " + notification_count);
			session.setAttribute("notification_count", notification_count);

//			List<Integer> user_follow_list = followService.user_follow_list(user.getMf_no());
//			if (user_follow_list != null) {
//				session.setAttribute("user_follow_list", user_follow_list);
//				log.info("@# session user_follow_list => " + session.getAttribute("user_follow_list"));
//			}
			log.info("@# session => " + session.getAttribute("user"));

			// 아이디 저장 쿠키 처리
			if ("on".equals(remember)) {
				Cookie cookie = new Cookie("savedId", mf_id);
				cookie.setMaxAge(60 * 60 * 24 * 7); // 7일 동안 저장
				cookie.setPath("/"); // 전체 경로에서 접근 가능
				response.addCookie(cookie);
			} else {
				// 체크 안 하면 쿠키 삭제
				Cookie cookie = new Cookie("savedId", "");
				cookie.setMaxAge(0);
				cookie.setPath("/");
				response.addCookie(cookie);
			}
			int mf_no = user.getMf_no();
			service.last_login_at(mf_no);

			return "redirect:/main"; // 로그인 성공 시 이동할 페이지
		} else {
			model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
			log.info("로그인 실패");
			return "login"; // 로그인 실패 시 다시 로그인 페이지로
		}
	}

	// 로그아웃
	@RequestMapping("/log_out")
	public String log_out(HttpSession session) {
		System.out.println(session.getAttribute("user"));
		System.out.println("log_out124124");
		System.out.println(session);
		session.invalidate();
		return "redirect:main";
	}

	// 회원가입 로직
	@PostMapping("/recruit_result_ok")
	public String write(@RequestParam HashMap<String, String> param) {
		service.recruit(param);

		return "login";
	}

	// 아이디 중복 체크 로직
	@PostMapping("/mf_id_check")
	@ResponseBody
	public String checkId(@RequestParam String mf_id, Model model) {

		ArrayList<TeamDTO> list = service.list();
		boolean exists;
		int count = 0;
		for (TeamDTO teamDTO : list) {
			if (teamDTO.getMf_id().equals(mf_id)) {
				count++;
			}
		}
		if (count != 0) {
			exists = true;
		} else {
			exists = false;
		}
		return exists ? "unavailable" : "available";
	}

	// 이메일 체크
	@PostMapping("/email_check")
	@ResponseBody
	public String email_check(@RequestParam String mf_email, HttpSession session) {
		log.info(mf_email);
		String code = emailService.sendEmail(mf_email);
		log.info("보냄");

		session.setAttribute("authCode", code);
//      session.setAttribute("authCodeTime", System.currentTimeMillis());
		log.info(session.getAttribute("authCode") + "");
		return code;
	}

	// 인증번호 체크
	@PostMapping("/code_check")
	@ResponseBody
	public String code_check(@RequestParam String code_chk, HttpSession session) {
		log.info("내가 적은 인증 코드 => " + code_chk);

		String code = (String) session.getAttribute("authCode");
		log.info("인증 코드 => " + code);

		String result = "";
		if (code.equals(code_chk)) {
			result = "true";
			return result;
		} else {
			result = "false";
			return result;
		}
	}

	// 닉네임 변경 폼 이동용
	@RequestMapping("/nickname_form")
	public String nickname_form(@RequestParam("mf_id") String mf_id, Model model) {
		model.addAttribute("mf_id", mf_id);
		return "nickname"; // nickname.jsp로 이동
	}

	// 닉네임 변경
//   @RequestMapping("/nickname")
//   public String nickname(@RequestParam("mf_nickname") String mf_nickname, @RequestParam("mf_id") String mf_id,
//         Model model, HttpServletRequest request) {
//      System.out.println("nickname  test1");
//      service.nickname(mf_nickname, mf_id);
//      System.out.println("nickname  test2");
//      model.addAttribute("mf_id", mf_id);
//
//      return "redirect:profile";
//   }
	@PostMapping("/nickname")
	@ResponseBody
	public Map<String, Object> nickname(@RequestParam("mf_nickname") String mf_nickname,
			@RequestParam("mf_id") String mf_id, HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		LocalDateTime lastUpdate = service.nickname_updatetime_check(mf_no);

		if (lastUpdate != null && lastUpdate.plusMonths(1).isAfter(LocalDateTime.now())) {
			String nextDate = TimeUtil.formatDateTime(lastUpdate.plusMonths(1));
			result.put("success", false);
			result.put("message", "다음 닉네임 변경 가능일: " + nextDate);
			return result;
		}

		// 자기 자신 제외한 중복 체크가 이상적
		boolean nickname_check = service.nickname_check(mf_nickname) > 0;

		if (nickname_check) {
			result.put("success", false);
			result.put("message", "이미 사용 중인 닉네임입니다.");
			return result;
		}

		service.nickname(mf_nickname, mf_id);

		TeamDTO updatedUser = service.find_list(mf_id);
		session.setAttribute("user", updatedUser);

		result.put("success", true);
		result.put("message", "닉네임이 성공적으로 변경되었습니다.");

		service.nickname_updatetime_update(mf_no);

		return result;
	}

	// 계정 설정 클릭시
	@RequestMapping("/account")
	public String account() {

		return "mem_update";
	}

	// 환경 설정 클릭시
	@RequestMapping("/environment")
	@ResponseBody
	public NotifSettingDTO environment(@RequestParam("mf_no") int mf_no) {
		log.info("environment 컨트롤러 옴");
		NotifSettingDTO mf_no_notif_setting = notifSettingService.mf_no_notif_setting(mf_no);
		log.info("!@#mf_no_notif_setting => " + mf_no_notif_setting);
		return mf_no_notif_setting;
	}

	// 알림 설정 업데이트
	@PostMapping("/update_notif_setting")
	@ResponseBody
	public void update_notif_setting(@RequestBody NotifSettingDTO notifSettingDTO, HttpSession session) {
		log.info("update_notif_setting 컨트롤러 옴");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		notifSettingDTO.setMf_no(mf_no);
		log.info("notifSettingDTO => " + notifSettingDTO);
		notifSettingService.update_notif_setting(notifSettingDTO);
	}
}