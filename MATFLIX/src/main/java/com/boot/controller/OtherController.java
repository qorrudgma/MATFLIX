package com.boot.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.TeamDTO;
import com.boot.service.BoardService;
import com.boot.service.FollowService;
import com.boot.service.RecommendService;
import com.boot.service.TeamService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class OtherController {

	@Autowired
	private TeamService teamService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private FollowService followService;

	@Autowired
	private RecommendService recommendService;

	@RequestMapping("/other_profile")
	public String other_profile(@RequestParam("mf_no") int mf_no, Model model) {
		TeamDTO user = teamService.find_user_by_no(mf_no);
		int follow_count = followService.user_follow_count(mf_no);
		int follower_count = followService.user_follower_count(mf_no);

		List<Map<String, Object>> profile_board = boardService.profile_board_list(mf_no);
		List<Map<String, Object>> profile_board_list = new ArrayList<>();
		for (Map<String, Object> board : profile_board) {
			int board_no = (int) board.get("boardNo");
			int recommend_count = recommendService.total_recommend(board_no);

			board.put("recommend_count", recommend_count);

			profile_board_list.add(board);
		}

		model.addAttribute("user", user);
		model.addAttribute("follow_count", follow_count);
		model.addAttribute("follower_count", follower_count);
		model.addAttribute("profile_board_list", profile_board_list);
		log.info("profile_board_list => " + profile_board_list);
//		log.info("upload_list => " + upload_list);

		return "other_profile";
	}
}