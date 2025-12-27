package com.boot.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.BoardDTO;
import com.boot.dto.Criteria;
import com.boot.dto.PageDTO;
import com.boot.service.PageService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class PageController {
	@Autowired
	private PageService service;

	@RequestMapping("/list")
	public String list(Criteria cri, Model model) {
		log.info("@# list()");
		log.info("@# cri=>" + cri);

		ArrayList<BoardDTO> list = service.listWithPaging(cri);
		int total = service.getTotalCount(cri);
		log.info("@# total=>" + total);

		// 게시글 시간 조정
		LocalDate today = LocalDate.now();
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MM-dd");

		for (BoardDTO dto : list) {
			LocalDateTime boardDate = dto.getBoardDate();

			if (boardDate.toLocalDate().isEqual(today)) {
				dto.setDisplayDate(boardDate.format(timeFormatter));
			} else {
				dto.setDisplayDate(boardDate.format(dateFormatter));
			}
		}

		model.addAttribute("list", list);
		model.addAttribute("pageMaker", new PageDTO(total, cri));

		return "list";
	}

//	@RequestMapping("/follow_board_list")
	public String follow_board_list(int mf_no) {
//	public String follow_board_list(Criteria cri, Model model) {
		log.info("@# follow_board_list()");
//		log.info("@# cri=>" + cri);
//
//		ArrayList<BoardDTO> list = service.listWithPaging(cri);
//		int total = service.getTotalCount(cri);
//		log.info("@# total=>" + total);
//
//		model.addAttribute("list", list);
//		model.addAttribute("pageMaker", new PageDTO(total, cri));

		return "list";
	}
}