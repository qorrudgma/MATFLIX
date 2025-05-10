package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.boot.dto.RecommendDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.BoardService;
import com.boot.service.RecommendService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RecommendController {

	@Autowired
	private RecommendService recommendService;

	@Autowired
	private BoardService boardService;

	@PostMapping("/recommend")
	@ResponseBody
	public String recommend(@SessionAttribute("user") TeamDTO user, @RequestParam int boardNo) {
		log.info("recommend()");
		RecommendDTO dto = new RecommendDTO();
		dto.setBoardNo(boardNo);
		dto.setMf_no(user.getMf_no());

		int check = recommendService.check_recommend(dto);

		if (check == 1) {
			recommendService.delete_recommend(dto);
			boardService.hitDown(boardNo);
			return "delete";
		} else {
			recommendService.recommend(dto);
			boardService.hitDown(boardNo);
			return "recommend";
		}

	}
}