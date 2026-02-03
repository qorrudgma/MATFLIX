package com.boot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.RankDTO;
import com.boot.service.FollowService;
import com.boot.service.TeamService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RankController {
	@Autowired
	private TeamService teamService;

	@Autowired
	private FollowService followService;

	// 랭킹(user 랭킹)
	@RequestMapping("/user_rank")
	public String user_rank(Model model) {
		List<RankDTO> user_rank = followService.select_user_ranking();
//		log.info("user_rank => " + user_rank);
//		model.addAttribute("user_rank", user_rank);
//		user_rank.get(0);
//		log.info("user_rank.get(0) => " + user_rank.get(0));
//		user_rank.get(0).get("following_id");
//		log.info("user_rank.get(0).get('following_id') => " + user_rank.get(0).get("following_id"));
//		List<Map<String, Object>> user_rank_list = new ArrayList<>();
//		for (int i = 0; i < user_rank.size(); i++) {
//			int user_mf_no = (int) user_rank.get(i).get("following_id");
////			teamService.rank_user(user_mf_no);
//			user_rank_list.add(teamService.rank_user(user_mf_no));
//		}
		model.addAttribute("user_rank_list", user_rank);
		log.info("user_rank_list => " + user_rank);

		return "user_rank";
	}
}