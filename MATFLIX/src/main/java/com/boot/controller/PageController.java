package com.boot.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.BoardDTO;
import com.boot.dto.Criteria;
import com.boot.dto.PageDTO;
import com.boot.dto.RecipeDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.PageService;
import com.boot.service.RecipeService;
import com.boot.util.TimeUtil;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class PageController {
	@Autowired
	private PageService service;
	@Autowired
	private RecipeService recipeService;

	@RequestMapping("/list")
	public String list(@Param("cri") Criteria cri, Model model) {
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

	@RequestMapping("/follow_board_list")
	public String follow_board_list(@Param("cri") Criteria cri, HttpSession session, Model model) {
		log.info("@# follow_board_list()");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		// 게시글 시간 조정
		ArrayList<BoardDTO> follow_board_list = service.f_listWithPaging(cri, mf_no);

		LocalDate today = LocalDate.now();
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MM-dd");

		for (BoardDTO dto : follow_board_list) {
			LocalDateTime boardDate = dto.getBoardDate();

			if (boardDate.toLocalDate().isEqual(today)) {
				dto.setDisplayDate(boardDate.format(timeFormatter));
			} else {
				dto.setDisplayDate(boardDate.format(dateFormatter));
			}
		}
		int f_total = service.f_getTotalCount(cri, mf_no);

		List<RecipeDTO> recipe_list = recipeService.follow_recipe_list(mf_no);
		for (RecipeDTO c : recipe_list) {
			c.setDisplay_time(TimeUtil.formatDate(c.getCreated_at()));
		}

		model.addAttribute("follow_board_list", follow_board_list);
		model.addAttribute("pageMaker", new PageDTO(f_total, cri));
		model.addAttribute("recipe_list", recipe_list);
		log.info("recipe_list => " + recipe_list);

		return "follow_board_list";
	}
}