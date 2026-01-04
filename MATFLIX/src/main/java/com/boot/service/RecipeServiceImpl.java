package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeDAO;
import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeIngredientDTO;
import com.boot.dto.RecipeStepDTO;
import com.boot.dto.RecipeTagDTO;
import com.boot.dto.RecipeWriteDTO;

@Service
public class RecipeServiceImpl implements RecipeService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private RecipeService recipeService;

	@Override
	public void process_recipe_write(RecipeWriteDTO dto) {
		// 여기부터 레시피 테이블
		RecipeDTO RDTO = new RecipeDTO();
		RDTO.setMf_no(dto.getMf_no());
		RDTO.setTitle(dto.getTitle());
		RDTO.setIntro(dto.getIntro());
		RDTO.setServings(dto.getServings());
		RDTO.setCook_time(dto.getCook_time());
		RDTO.setDifficulty(dto.getDifficulty());
		RDTO.setCategory(dto.getCategory());
		RDTO.setTip(dto.getTip());

		recipeService.insert_recipe(RDTO);

		// 여기부터 재료 테이블
		int recipe_id = RDTO.getRecipe_id();

		String[] names = dto.getIngredient_name();
		String[] amounts = dto.getIngredient_amount();

		for (int i = 0; i < names.length; i++) {
			RecipeIngredientDTO RIDTO = new RecipeIngredientDTO();

			RIDTO.setRecipe_id(recipe_id);
			RIDTO.setIngredient_name(names[i]);
			RIDTO.setIngredient_amount(amounts[i]);

			recipeService.insert_recipe_ingredient(RIDTO);
		}

		// 여기부터 순서 테이블
		String[] nums = dto.getStep_no();
		String[] contents = dto.getStep_content();

		for (int i = 0; i < nums.length; i++) {
			RecipeStepDTO RSDTO = new RecipeStepDTO();

			RSDTO.setRecipe_id(recipe_id);
			RSDTO.setStep_no(nums[i]);
			RSDTO.setStep_content(contents[i]);

			recipeService.insert_recipe_step(RSDTO);
		}

		// 태그 테이블
		String[] tags = dto.getTags();

		for (int i = 0; i < tags.length; i++) {
			RecipeTagDTO RTDTO = new RecipeTagDTO();

			RTDTO.setRecipe_id(recipe_id);
			RTDTO.setTag(tags[i]);

			recipeService.insert_recipe_tag(RTDTO);
		}

		// 이미지 저장

		// 이미지 테이블
	}

	@Override
	public void insert_recipe(RecipeDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.insert_recipe(dto);
	}

	@Override
	public void insert_recipe_ingredient(RecipeIngredientDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.insert_recipe_ingredient(dto);
	}

	@Override
	public void insert_recipe_step(RecipeStepDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.insert_recipe_step(dto);
	}

	@Override
	public void insert_recipe_tag(RecipeTagDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.insert_recipe_tag(dto);
	}
}