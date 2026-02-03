package com.boot.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.BoardDTO;
import com.boot.dto.ProfileDTO;
import com.boot.dto.RecipeDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.BoardService;
import com.boot.service.FollowService;
import com.boot.service.RecipeService;
import com.boot.service.RecommendService;
import com.boot.service.TeamService;
import com.boot.util.TimeUtil;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class OtherController {

	@Autowired
	private TeamService teamService;

	@Autowired
	private RecipeService recipeService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private FollowService followService;

	@Autowired
	private RecommendService recommendService;

	@RequestMapping("/other_profile")
	public String other_profile(@RequestParam("mf_no") int mf_no, HttpSession session, Model model) {
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		ProfileDTO profile = teamService.profile(mf_no);

		List<RecipeDTO> my_recipe = recipeService.my_recipe_list(mf_no);
		for (RecipeDTO c : my_recipe) {
			c.setDisplay_time(TimeUtil.formatDate(c.getCreated_at()));
		}
		if (user != null) {
			if (followService.check_follow(user.getMf_no(), mf_no) == 1) {
				model.addAttribute("follow", true);
			} else {
				model.addAttribute("follow", false);
			}
		}

		model.addAttribute("my_recipe", my_recipe);
		model.addAttribute("profile", profile);
		log.info("model => " + model);

		return "other_profile";
	}

	@PostMapping("/other_board_list")
	@ResponseBody
	public List<BoardDTO> my_board_list(int mf_no) {
		log.info("other_board_list()");
		List<BoardDTO> other_board_list = boardService.my_board_list(mf_no);
		log.info("other_board_list=> " + other_board_list);
		return other_board_list;
	}
}