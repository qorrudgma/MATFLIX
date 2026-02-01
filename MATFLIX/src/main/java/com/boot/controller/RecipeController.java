/*==========================================================
* 파일명     : RecipeController.java
* 작성자     : 임진우
* 작성일자   : 2025-05-07
* 설명       : recipe 등록, 수정, 삭제, 조회, 관리에 관한 컨트롤러입니다.

* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-07   임진우       최초 생성
* 2025-05-07   임진우       Spring Lagacy에서 Boot로 이동
* 2025-05-07   임진우       이미지 파일 업로드 완료
* 2025-05-08   임진우       main : 이미지 나타내기 로직 구현 => 카테로리별 리스트
* 2025-05-08   임진우       요리 게시판 리스트 및 해당 요리 뷰 작성
* 2025-05-12   임진우       테이블에 유저넘버 추가
* 2025-05-12   임진우       내 레시피 생성
* 2025-05-12   임진우       레시피 보드에 작성자 이름 및 정보 삽입
============================================================*/

package com.boot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeReviewDTO;
import com.boot.dto.RecipeReviewSummaryDTO;
import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.RecipeWriteDTO;
import com.boot.dto.ReviewImageDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.FavoriteRecipeService;
import com.boot.service.FollowService;
import com.boot.service.RecipeRecommendService;
import com.boot.service.RecipeReviewService;
import com.boot.service.RecipeService;
import com.boot.util.TimeUtil;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RecipeController {
	@Autowired
	private RecipeService recipeService;

	@Autowired
	private RecipeRecommendService recipeRecommendService;

	@Autowired
	private RecipeReviewService recipeReviewService;

	@Autowired
	private FollowService followService;

	@Autowired
	private FavoriteRecipeService favoriteRecipeService;

	@RequestMapping("/recipe_write")
	public String recipe_write(RecipeWriteDTO dto, HttpSession session) {
		log.info("recipe_write 컨트롤러에 왔음");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		dto.setMf_no(user.getMf_no());
		log.info("dto => " + dto);

		recipeService.process_recipe_write(dto);

		return "redirect:/recipe_list";
	}

	// 레시피 작성
	@RequestMapping("/recipe_write_new")
	public String recipe_write_new() {
		return "recipe_write_new";
	}

	// 레시피 작성
	@RequestMapping("/recipe_modify_page")
	public String recipe_modify_page(int recipe_id, HttpSession session, Model model) {
		RecipeDTO recipe = recipeService.recipe(recipe_id);
		recipe.setRecipe_id(recipe_id);
		model.addAttribute("recipe", recipe);
		model.addAttribute("ingredient_list", recipeService.recipe_ingredient(recipe_id));
		model.addAttribute("step_list", recipeService.recipe_step(recipe_id));
		model.addAttribute("image_list", recipeService.recipe_image(recipe_id));
		model.addAttribute("tag_list", recipeService.recipe_tag(recipe_id));
		log.info("#@$@!# model => " + model);

		return "recipe_modify";
	}

	// 레시피 작성
	@RequestMapping("/recipe_modify")
	public String recipe_modify(RecipeWriteDTO dto, HttpSession session) {
		log.info("#@$@!# recipe_modify");
		log.info("#@$@!# RecipeWriteDTO => " + dto);
		recipeService.process_recipe_modify(dto);

		return "redirect:/recipe_content_view?recipe_id=" + dto.getRecipe_id();
	}

	@PostMapping("/delete_recipe")
	public String delete_recipe(@RequestParam("recipe_id") int recipe_id) {
		recipeService.delete_recipe(recipe_id);
		// 레시피 메인으로 가는걸로 바꾸기
		return "redirect:/recipe_list";
	}

	@GetMapping("/recipe_list")
	public String recipe_list(Model model) {
		model.addAttribute("recipe_list", recipeService.recipe_list());
		return "recipe_list";
	}

	@GetMapping("/main")
	public String main(Model model) {
		List<RecipeDTO> my_recipe = recipeService.recipe_list();
//		for (RecipeDTO c : my_recipe) {
//			c.setDisplay_time(TimeUtil.timeAgo(c.getCreated_at()));
//		}
		for (RecipeDTO c : my_recipe) {
			c.setDisplay_time(TimeUtil.formatDate(c.getCreated_at()));
		}
		model.addAttribute("recipe_list", my_recipe);
		return "main";
	}

	@GetMapping("/recipe_content_view")
	public String recipe_content_view(@RequestParam("recipe_id") int recipe_id, Model model, HttpSession session) {
		log.info("recipe_id=>" + recipe_id);
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		RecipeDTO recipe = recipeService.recipe(recipe_id);
		String time = TimeUtil.timeAgo(recipe.getCreated_at());
		recipe.setDisplay_updated_at(time);
		model.addAttribute("recipe", recipe);
		model.addAttribute("ingredient_list", recipeService.recipe_ingredient(recipe_id));
		model.addAttribute("step_list", recipeService.recipe_step(recipe_id));
		model.addAttribute("image_list", recipeService.recipe_image(recipe_id));
		model.addAttribute("tag_list", recipeService.recipe_tag(recipe_id));
		RecipeReviewSummaryDTO RRSDTO = recipeReviewService.review_summary_list(recipe_id);
		// 별점 부분

		if (RRSDTO != null) {
			int review_count = RRSDTO.getReview_count();

			if (review_count > 0) {
				model.addAttribute("review_image_list", recipeReviewService.review_image_list(recipe_id, "latest"));
				model.addAttribute("review_summary_list", RRSDTO);

				int rating_sum = RRSDTO.getRating_sum();
				double rating_avg = Math.round(((double) rating_sum / review_count) * 10) / 10.0;
				int star = (int) Math.round(rating_avg);

				model.addAttribute("rating_avg", rating_avg);
				model.addAttribute("star", star);

				model.addAttribute("p_5", RRSDTO.getRating_5() * 100 / review_count);
				model.addAttribute("p_4", RRSDTO.getRating_4() * 100 / review_count);
				model.addAttribute("p_3", RRSDTO.getRating_3() * 100 / review_count);
				model.addAttribute("p_2", RRSDTO.getRating_2() * 100 / review_count);
				model.addAttribute("p_1", RRSDTO.getRating_1() * 100 / review_count);
			}
		}
		if (user != null) {
			int mf_no = user.getMf_no();
			model.addAttribute("recommended", recipeRecommendService.check_recipe_recommend(recipe_id, mf_no));
			model.addAttribute("favorite_check", favoriteRecipeService.check_favorite_recipe(mf_no, recipe_id));
			if (followService.check_follow(user.getMf_no(), recipe.getMf_no()) == 1) {
				model.addAttribute("follow", true);
			} else {
				model.addAttribute("follow", false);
			}
		}
		log.info("model => " + model);
		return "recipe_content_view";
	}

	@PostMapping("/insert_favorite_recipe")
	@ResponseBody
	public Map<String, Object> insert_favorite_recipe(@RequestParam("recipe_id") int recipe_id, HttpSession session) {
		log.info("insert_favorite_recipe()");
		Map<String, Object> result = new HashMap<>();
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();

		favoriteRecipeService.insert_favorite_recipe(mf_no, recipe_id);
		result.put("favorite", true);

		return result;
	}

	@PostMapping("/delete_favorite_recipe")
	@ResponseBody
	public Map<String, Object> delete_favorite_recipe(@RequestParam("recipe_id") int recipe_id, HttpSession session) {
		log.info("delete_favorite_recipe()");
		Map<String, Object> result = new HashMap<>();
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();

		favoriteRecipeService.delete_favorite_recipe(mf_no, recipe_id);
		result.put("favorite", true);

		return result;
	}

	@PostMapping("/recipe_recommend")
	@ResponseBody
	public Map<String, Object> recipe_recommend(@RequestParam("recipe_id") int recipe_id, HttpSession session) {
		log.info("recipe_recommend()");
		Map<String, Object> result = new HashMap<>();
		TeamDTO user = (TeamDTO) session.getAttribute("user");

		if (recipeRecommendService.check_recipe_recommend(recipe_id, user.getMf_no()) == 0) {
			log.info("추천하러옴");
			recipeRecommendService.recipe_recommend(recipe_id, user.getMf_no());
			log.info("추천함");
			recipeRecommendService.add_recipe_recommend(recipe_id);
			log.info("추천 수 증가시킴");
			result.put("status", "recommended");
		} else {
			recipeRecommendService.delete_recipe_recommend(recipe_id, user.getMf_no());
			recipeRecommendService.minus_recipe_recommend(recipe_id);
			result.put("status", "cancel");
		}
		result.put("count", recipeService.recipe_recommend_count(recipe_id));
		log.info("result => " + result);

		return result;
	}

	// 리뷰 =====================
	@PostMapping("/review/write")
	public String review_write(RecipeReviewWriteDTO recipeReviewWriteDTO, HttpSession session) {
		log.info("review_write()");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		recipeReviewWriteDTO.setMf_no(mf_no);
		log.info("recipeReviewDTO => " + recipeReviewWriteDTO);
		recipeReviewService.process_review_write(recipeReviewWriteDTO);
		return "redirect:/recipe_content_view?recipe_id=" + recipeReviewWriteDTO.getRecipe_id();
	}

	@GetMapping("/review/detail")
	@ResponseBody
	public RecipeReviewDTO review_detail(@RequestParam int review_id) {
		log.info("review_detail()");
		RecipeReviewDTO review_detail = recipeReviewService.select_review(review_id);
		String time = TimeUtil.timeAgo(review_detail.getCreated_at());
		log.info("time => " + time);
		review_detail.setDisplay_updated_at(time);
		log.info("review_detail => " + review_detail);
		return review_detail;
	}

	@GetMapping("/review/sort")
	@ResponseBody
	public List<ReviewImageDTO> review_sort(int recipe_id, String sort) {
		log.info("review_sort()");
		List<ReviewImageDTO> review_sort = recipeReviewService.review_image_list(recipe_id, sort);
		return review_sort;
	}

	@PostMapping("/review/modify")
	public String review_modify(RecipeReviewWriteDTO recipeReviewWriteDTO, HttpSession session) {
		log.info("review_modify()");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		recipeReviewWriteDTO.setMf_no(mf_no);
		recipeReviewService.modify_review(recipeReviewWriteDTO);
		log.info("recipeReviewDTO => " + recipeReviewWriteDTO);
		return "redirect:/recipe_content_view?recipe_id=" + recipeReviewWriteDTO.getRecipe_id();
	}
}