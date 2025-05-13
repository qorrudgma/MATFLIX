package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.NoticeCriteria;
import com.boot.dto.NoticePageDTO;
import com.boot.service.NoticePageService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NoticePageController {
	@Autowired
	private NoticePageService service;

	@RequestMapping("/notice_list")
	public String list(NoticeCriteria cri, Model model) {
		log.info("@# list()");
		log.info("@# cri" + cri);

		model.addAttribute("list", service.listWithPaging(cri));
		model.addAttribute("pageMaker", new NoticePageDTO(service.totalList(cri), cri));

		return "notice_list";
	}
}
