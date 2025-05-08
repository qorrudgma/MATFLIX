package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.TeamDTO;
import com.boot.service.TeamService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
//@RequestMapping("/member")
public class TeamController {

	@Autowired
	private TeamService service;

	// 마이페이지
//	@RequestMapping("/profile")
//	public String profile(@RequestParam("mf_id") String mf_id, Model model) {
//		TeamDTO dto = service.find_list(mf_id);
//		model.addAttribute("dto", dto);
//		System.out.println(mf_id);
//		return "profile";
//	}
	@RequestMapping("/profile")
	public String profile(HttpSession session, Model model) {
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			return "redirect:/"; // 로그인 안 되어 있으면 로그인 페이지로
		}

		TeamDTO dto = service.find_list(user.getMf_id());
		model.addAttribute("dto", dto);
		return "profile";
	}

	@RequestMapping("/delete_member")
	public String delete_member(@RequestParam("mf_id") String mf_id, Model model) {
		model.addAttribute("mf_id", mf_id);
		return "delete_member";
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

	// 마이페이지 내에 계정설정 확인
	@RequestMapping("/mem_update")
	@ResponseBody
	public String mem_update(@RequestParam HashMap<String, String> param, HttpSession session) {
		System.out.println(param);
		service.update_ok(param);
		System.out.println("test1");
		session.invalidate();
		System.out.println("test2");
		return "ok";
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
		if (result == 1) {
			TeamDTO dto = service.find_list(mf_id);
			HttpSession session = request.getSession();
			session.setAttribute("user", dto);
			return "main"; // 로그인 성공 시 이동할 페이지
		} else {
			model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "main"; // 로그인 실패 시 다시 로그인 페이지로
		}
	}

//	@RequestMapping("/main_membership")
//	@ResponseBody
//	public String login_ok(@RequestParam("mf_id") String mf_id, @RequestParam("mf_pw") String mf_pw, Model model,
//			HttpServletRequest request) {
//		boolean login_ok = false;
//
//		int result = service.login(mf_id, mf_pw);
//		if (result == 1) {
//			model.addAttribute("mf_id", mf_id);
//			System.out.println(mf_id);
//			HttpSession session = request.getSession();
//			TeamDTO dto = service.find_list(mf_id);
//			session.setAttribute("user", dto);
//			login_ok = true;
//		}
//		return login_ok ? "available" : "unavailable";
//	}

	// 로그아웃
	@RequestMapping("/log_out")
	public String log_out(HttpSession session) {
		System.out.println(session.getAttribute("user"));
		System.out.println("log_out124124");
		System.out.println(session);
		session.invalidate();
		return "redirect:/";
	}

	// 회원가입 로직
	@PostMapping("/recruit_result_ok")
	public String write(@RequestParam HashMap<String, String> param) {
		service.recruit(param);

//		return "redirect:/login";
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

	// 통합 코드
//	@PostMapping("/recruit_result_ok")
//	public String recruitOrCheck(@RequestParam HashMap<String, String> param, Model model) {
//		String mf_id = param.get("mf_id"); // "check" 또는 "recruit"
//
//		ArrayList<TeamDTO> list = service.list();
//		for (TeamDTO teamDTO : list) {
//			if (teamDTO.getMf_id().equals(mf_id)) {
//				return "redirect:/recruit";
//			}
//		}
//
//		return "redirect:/login";
//	}

	// 마이페이지 내에 계정설정 확인
	@RequestMapping("/nickname")
	public String nickname(@RequestParam("mf_nickname") String mf_nickname, @RequestParam("mf_id") String mf_id,
			Model model, HttpServletRequest request) {
		System.out.println("nickname  test1");
		service.nickname(mf_nickname, mf_id);
		System.out.println("nickname  test2");
		model.addAttribute("mf_id", mf_id);

		return "redirect:profile";
	}

}