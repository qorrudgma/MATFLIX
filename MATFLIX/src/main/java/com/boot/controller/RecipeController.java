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

import com.boot.dto.RecipeWriteDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.RecipeRecommendService;
import com.boot.service.RecipeService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RecipeController {
	@Autowired
	private RecipeService recipeService;

	@Autowired
	private RecipeRecommendService recipeRecommendService;

	@RequestMapping("/recipe_write")
	public String recipe_write(RecipeWriteDTO dto, HttpSession session) {
		log.info("recipe_write 컨트롤러에 왔음");
		log.info("dto 1 => " + dto);
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		dto.setMf_no(user.getMf_no());
		log.info("dto 2 => " + dto);
		recipeService.process_recipe_write(dto);
		return "redirect:/recipe_list";
	}

	@RequestMapping("/delete_recipe")
	public String delete_recipe(int recipe_id) {
		recipeService.delete_recipe(recipe_id);
		// 레시피 메인으로 가는걸로 바꾸기
		return "insert_recipe";
	}

	@GetMapping("/recipe_list")
	public String recipe_list(Model model) {
		model.addAttribute("recipe_list", recipeService.recipe_list());
		return "recipe_list";
	}

	@GetMapping("/main")
	public String main(Model model) {
		model.addAttribute("recipe_list", recipeService.recipe_list());
		return "main";
	}

	@GetMapping("/recipe_content_view")
	public String recipe_content_view(@RequestParam("recipe_id") int recipe_id, Model model, HttpSession session) {
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		model.addAttribute("recipe", recipeService.recipe(recipe_id));
		model.addAttribute("ingredient_list", recipeService.recipe_ingredient(recipe_id));
		model.addAttribute("step_list", recipeService.recipe_step(recipe_id));
		model.addAttribute("image_list", recipeService.recipe_image(recipe_id));
		model.addAttribute("tag_list", recipeService.recipe_tag(recipe_id));
		if (user != null) {
			model.addAttribute("recommended",
					recipeRecommendService.check_recipe_recommend(recipe_id, user.getMf_no()));
		}
		log.info("model => " + model);
		return "recipe_content_view";
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

}