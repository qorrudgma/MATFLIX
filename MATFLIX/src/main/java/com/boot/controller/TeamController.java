/*==========================================================
* 파일명     : TeamController.java
* 작성자     : 손병관
* 작성일자   : 2025-05-09
* 설명       : 이 클래스는 [로그인, 회원가입, 회원 정보 수정, 닉네임 변경, 회원 삭제까지 구현한 controller 입니다.]


* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-07   손병관       최초 생성
* 2025-05-07   손병관       로그인 및 회원가입 구현
* 2025-05-08   손병관       마이페이지 동작
* 2025-05-08   손병관       회원 정보 수정 구현
* 2025-05-09   손병관       회원 탈퇴 및 닉네임 변경 구현
============================================================*/

package com.boot.controller;

import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.FavoriteDTO;
import com.boot.dto.NotifSettingDTO;
import com.boot.dto.RecipeAttachDTO;
import com.boot.dto.RecipeDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.BoardService;
import com.boot.service.EmailService;
import com.boot.service.FavoriteService;
import com.boot.service.FollowService;
import com.boot.service.NotifSettingService;
import com.boot.service.NotificationService;
import com.boot.service.RecipeService;
import com.boot.service.RecipeUploadService;
import com.boot.service.RecommendService;
import com.boot.service.TeamService;

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
	private RecipeUploadService recipeUploadService;

	@Autowired
	private FavoriteService favoriteService;

	@Autowired
	private RecommendService recommendService;

	@Autowired
	private NotifSettingService notifSettingService;

	// 프로필 보기
	@RequestMapping("/profile")
	public String profile(HttpSession session, Model model) throws Exception {
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			log.info("@#user => " + user);
			return "redirect:/"; // 로그인 안 되어 있으면 로그인 페이지로
		}

		TeamDTO dto = service.find_list(user.getMf_id());
		List<Map<String, Object>> profile_board = boardService.profile_board_list(user.getMf_no());
		log.info(profile_board + "");
		for (int i = 0; i < profile_board.size(); i++) {
			Map<String, Object> board = profile_board.get(i);
			int boardNo = (int) board.get("boardNo");
			int recommend_count = recommendService.total_recommend(boardNo);
			board.put("recommend_count", recommend_count);
		}

		String mf_no = Integer.toString(user.getMf_no());
		List<RecipeAttachDTO> my_recipe_attach = new ArrayList<>();
		List<RecipeDTO> my_recipe = recipeService.get_recipe_by_user_id(mf_no);

		for (int i = 0; i < my_recipe.size(); i++) {
			my_recipe_attach.add(recipeUploadService.get_upload_by_id(my_recipe.get(i).getRc_recipe_id()));
		}

		int mfNo = user.getMf_no();

		// 즐겨찾기
		List<FavoriteDTO> originalFavoriteList = favoriteService.getUserFavoriteRecipes(mfNo);

		List<Map<String, Object>> favoritesForView = new ArrayList<>();

		for (FavoriteDTO f_dto : originalFavoriteList) {
			Map<String, Object> favoriteMap = new HashMap<>();
			favoriteMap.put("favoriteId", f_dto.getFavoriteId());
			favoriteMap.put("mfNo", f_dto.getMfNo());
			favoriteMap.put("recipeId", f_dto.getRecipeId());

			if (f_dto.getCreatedAt() != null) {
				Date createdAtAsDate = Date.from(f_dto.getCreatedAt().atZone(ZoneId.systemDefault()).toInstant());
				favoriteMap.put("createdAt", createdAtAsDate);
			} else {
				favoriteMap.put("createdAt", null);
			}

			favoritesForView.add(favoriteMap);
		}
		int my_recipe_count = recipeService.my_recipe_count(mfNo);
		int user_follow_count = followService.user_follow_count(mfNo);
		int user_follower_count = followService.user_follower_count(mfNo);

		model.addAttribute("favorites", favoritesForView);
		model.addAttribute("my_recipe", my_recipe);
		model.addAttribute("my_recipe_attach", my_recipe_attach);
		model.addAttribute("dto", dto);
		model.addAttribute("profile_board", profile_board);
		model.addAttribute("my_recipe_count", my_recipe_count);
		model.addAttribute("user_follow_count", user_follow_count);
		model.addAttribute("user_follower_count", user_follower_count);

		return "profile";
	}

//   @RequestMapping("/delete_member")
//   public String delete_member(@RequestParam("mf_id") String mf_id, Model model) {
//      model.addAttribute("mf_id", mf_id);
//      return "delete_member";
//   }

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
		TeamDTO dto = service.find_list(mf_id); // 기존 비밀번호 확인용
		TeamDTO user = (TeamDTO) session.getAttribute("user"); // 기존 비밀번호 확인용
		if (dto != null && dto.getMf_pw().equals(mf_pw)) {
			log.info("mf_id => " + mf_id);
			log.info("mf_no => " + user.getMf_no());
			service.delete_ok(user.getMf_no()); // delete_ok에 바로 mf_id 전달
			session.invalidate(); // 세션 종료
			log.info("삭제 및 세션 종료");
			return "available";
		} else {
			return "unavailable";
		}
//		return "";
	}

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
		boolean check_ok = false;
		TeamDTO dto = service.find_list(mf_id);
		String mf_pw_check = dto.getMf_pw();
		System.out.println(mf_pw_check);
		if (mf_pw.equals(mf_pw_check)) {
			System.out.println("test1");
			check_ok = true;
		}
		System.out.println("test2");
		return check_ok ? "available" : "unavailable";
	}

	// 회원정보 수정 후 자동 로그아웃
	@RequestMapping("/mem_update")
	@ResponseBody
	public Map<String, Object> mem_update(@RequestParam HashMap<String, String> param, HttpSession session) {
		System.out.println(param);
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
			HttpServletRequest request, Model model) {
		log.info("@# mf_id 입니다 : " + mf_id);
		log.info("@# mf_pw 입니다 : " + mf_pw);
		int result = service.login(mf_id, mf_pw);
		log.info("@# result =>" + result);
		if (result == 1) {
			TeamDTO dto = service.find_list(mf_id);
			HttpSession session = request.getSession();
			session.setAttribute("user", dto);
			TeamDTO user = (TeamDTO) session.getAttribute("user");

			int notification_count = notificationService.notification_count(user.getMf_no());
			log.info("notification_count => " + notification_count);
			session.setAttribute("notification_count", notification_count);

			List<Integer> user_follow_list = followService.user_follow_list(user.getMf_no());
			if (user_follow_list != null) {
				session.setAttribute("user_follow_list", user_follow_list);
				log.info("@# session user_follow_list => " + session.getAttribute("user_follow_list"));
			}
			log.info("@# session => " + session.getAttribute("user"));
			return "redirect:/main"; // 로그인 성공 시 이동할 페이지
		} else {
			model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
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
	@RequestMapping("/nickname")
	public String nickname(@RequestParam("mf_nickname") String mf_nickname, @RequestParam("mf_id") String mf_id,
			Model model, HttpSession session) {
		service.nickname(mf_nickname, mf_id); // 닉네임 변경 처리

		// 변경된 사용자 정보 다시 가져와서 세션 갱신
		TeamDTO updatedUser = service.find_list(mf_id);
		session.setAttribute("user", updatedUser); // 세션 갱신

		return "redirect:profile"; // 리디렉션
	}

	// 계정 설정 클릭시
	@RequestMapping("/account")
	public String account() {

		return "mem_update";
	}

	// 환경 설정 클릭시
	@RequestMapping("/environment")
	@ResponseBody
	public ArrayList<NotifSettingDTO> environment(@RequestParam("mf_no") int mf_no) {
		log.info("environment 컨트롤러 옴");
		ArrayList<NotifSettingDTO> mf_no_notif_setting = notifSettingService.mf_no_notif_setting(mf_no);
		log.info("!@#mf_no_notif_setting => " + mf_no_notif_setting);
		return mf_no_notif_setting;
	}

	// 알림 설정 업데이트
	@RequestMapping("/update_notif_setting")
	@ResponseBody
	public void update_notif_setting(@RequestParam("notif_type") String notif_type, @RequestParam("yn") int yn,
			HttpSession session) {
		log.info("update_notif_setting 컨트롤러 옴");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		notifSettingService.update_notif_setting(mf_no, notif_type, yn);
	}

	// 로그인
	@RequestMapping("/recipe_write_new")
	public String recipe_write_new() {
		return "recipe_write_new";
	}
}