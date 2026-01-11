/*==========================================================
* 파일명     : RecipeCommentController.java
* 작성자     : 임진우
* 작성일자   : 2025-05-07
* 설명       : recipe 뷰의 댓글기능에 관한 클래스 파일입니다.

* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-08   임진우       최초생성
* 2025-05-08   임진우       댓글 기능 완
* 2025-05-12   임진우       댓글 작성자 별점기능 추가
============================================================*/

package com.boot.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.RecipeCommentDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.RecipeCommentRecommendService;
import com.boot.service.RecipeCommentService;
import com.boot.util.TimeUtil;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RecipeCommentController {

	@Autowired
	private RecipeCommentService recipeCommentService;

	@Autowired
	private RecipeCommentRecommendService recipeCommentRecommendService;

	@PostMapping("/recipe/comment")
	@ResponseBody
	public List<RecipeCommentDTO> save(RecipeCommentDTO recipeCommentDTO, HttpSession session) {
		log.info("@# /recipe/comment");
		log.info("@# recipeCommentDTO=>" + recipeCommentDTO);
		List<RecipeCommentDTO> recipeCommentList = new ArrayList<>();

		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		recipeCommentDTO.setMf_no(mf_no);
		recipeCommentService.insert_recipe_comment(recipeCommentDTO);
		log.info("mf_no => " + mf_no);
		int recipe_id = recipeCommentDTO.getRecipe_id();
		recipeCommentList = recipeCommentService.all_recipe_comment(recipe_id);
		log.info("recipe_id => " + recipe_id);

		return recipeCommentList;
	}

	@GetMapping("/recipe/comment/list")
	@ResponseBody
	public List<RecipeCommentDTO> comment_list(@RequestParam("recipe_id") int recipe_id) {
		List<RecipeCommentDTO> recipeCommentList = recipeCommentService.all_recipe_comment(recipe_id);
		if (recipeCommentList != null) {
			for (RecipeCommentDTO c : recipeCommentList) {
				c.setDisplay_time(TimeUtil.timeAgo(c.getCreated_at()));
			}
		}
		log.info("recipeCommentList => " + recipeCommentList);

		return recipeCommentList;
	}

	@PostMapping("/recipe/comment/delete")
	@ResponseBody
	public void recipe_comment_delete(@RequestParam("comment_no") int comment_no) {
		log.info("comment_no => " + comment_no);
		recipeCommentService.recipe_comment_delete(comment_no);
		log.info("디비에 deleted = 1");
	}

	@PostMapping("/recipe/comment/recommend")
	@ResponseBody
	public String recipe_comment_recommend(@RequestParam("comment_no") int comment_no, HttpSession session) {
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();

		int check = recipeCommentRecommendService.recipe_comment_yn(comment_no, mf_no);

		if (check == 1) {
			recipeCommentRecommendService.minus_recipe_comment_recommend(comment_no, mf_no);
			log.info("@# 댓글 추천 취소 성공");
			return "cancel";
		} else {
			recipeCommentRecommendService.add_recipe_comment_recommend(comment_no, mf_no);
			log.info("@# 댓글 추천 성공");
			return "recommend";
		}
	}
}
