package com.boot.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.AdminUserSearchDTO;
import com.boot.dto.RecipeReportDTO;
import com.boot.dto.SearchDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.AdminUserService;
import com.boot.service.ReportService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class AdminController {

	@Autowired
	private AdminUserService adminUserService;

	@Autowired
	private ReportService reportService;

	@GetMapping("/admin/dashboard")
	public String admin_dashboard(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "type", required = false) String type,
			@RequestParam(value = "keyword", required = false) String keyword, HttpSession session, Model model) {
		log.info("관리자");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null || !"ADMIN".equals(user.getMf_role())) {
			log.info("관리자 계정 아님");
			return "redirect:/access_denied";
		}
		AdminUserSearchDTO ASDTO = new AdminUserSearchDTO();
		ASDTO.setPage(page);
		ASDTO.setType(type);
		ASDTO.setKeyword(keyword);
		// 리스트
//		List<AdminUserDTO> user_list = adminUserService.user_list(ASDTO);
		// 페이징
		Map<String, Object> pageData = adminUserService.getUserListPage(ASDTO);
		// 접속자

//		model.addAttribute("user_list", user_list);
		model.addAttribute("page", page);
		model.addAllAttributes(pageData);
		log.info("관리 페이지 옴");
		return "dashboard";
	}

	@PostMapping("/admin/user/update")
	@ResponseBody
	public String update_user_status(@RequestParam("mf_no") int mf_no, @RequestParam("status") String status) {
		log.info("update_user_status() {}, {}", mf_no, status);
		try {
			adminUserService.user_status_update(mf_no, status);
			return "ok";
		} catch (Exception e) {
			return "fail";
		}
	}

	@GetMapping("/admin/report/recipe")
	public String admin_report_recipe(
			@RequestParam(name = "status", required = false, defaultValue = "PENDING") String status, Model model) {
		SearchDTO search = new SearchDTO();
//		search.setType(status);
//		search.setKeyword(status);

		List<RecipeReportDTO> report_list = reportService.recipe_report_list(search);

		model.addAttribute("tab", "report_recipe");
		model.addAttribute("status", status);
		model.addAttribute("report_list", report_list);

		return "dashboard";
	}
}