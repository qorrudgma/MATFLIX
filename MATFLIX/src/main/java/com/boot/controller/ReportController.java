package com.boot.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.service.AdminUserService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ReportController {

	@Autowired
	private AdminUserService adminUserService;

//	@GetMapping("/admin/dashboard")
	public String admin_dashboard(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "type", required = false) String type,
			@RequestParam(value = "keyword", required = false) String keyword, HttpSession session, Model model) {
		return "dashboard";
	}
}