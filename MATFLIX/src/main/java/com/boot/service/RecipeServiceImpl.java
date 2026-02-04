package com.boot.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.dao.RecipeDAO;
import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeIngredientDTO;
import com.boot.dto.RecipeStepDTO;
import com.boot.dto.RecipeTagDTO;
import com.boot.dto.RecipeWriteDTO;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class RecipeServiceImpl implements RecipeService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private FileStorageService fileStorageService;

	@Override
	@Transactional
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

		insert_recipe(RDTO);

		int recipe_id = RDTO.getRecipe_id();

		// 재료 테이블
		insert_recipe_ingredient(recipe_id, dto);
		// 순서 테이블
		insert_recipe_step(recipe_id, dto);
		// 태그 테이블
		insert_recipe_tag(recipe_id, dto);
		// 이미지 저장
		fileStorageService.save_image(recipe_id, dto);
	}

	@Override
	@Transactional
	public void process_recipe_modify(RecipeWriteDTO dto) {
		// 여기부터 레시피 테이블
		RecipeDTO RDTO = new RecipeDTO();
		int recipe_id = dto.getRecipe_id();
		RDTO.setRecipe_id(recipe_id);
		RDTO.setMf_no(dto.getMf_no());
		RDTO.setTitle(dto.getTitle());
		RDTO.setIntro(dto.getIntro());
		RDTO.setServings(dto.getServings());
		RDTO.setCook_time(dto.getCook_time());
		RDTO.setDifficulty(dto.getDifficulty());
		RDTO.setCategory(dto.getCategory());
		RDTO.setTip(dto.getTip());

		log.info("RDTO => " + RDTO);
		modify_recipe(RDTO);

		// 재료 테이블
		delete_recipe_ingredient(recipe_id);
		insert_recipe_ingredient(recipe_id, dto);
		// 순서 테이블
		delete_recipe_step(recipe_id);
		insert_recipe_step(recipe_id, dto);
		// 태그 테이블
		delete_recipe_tag(recipe_id);
		insert_recipe_tag(recipe_id, dto);
//		// 이미지
		delete_recipe_image(recipe_id);
		fileStorageService.modify_recipe_image(recipe_id, dto);
	}

	@Override
	public void insert_recipe(RecipeDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.insert_recipe(dto);
	}

	@Override
	public void modify_recipe(RecipeDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.modify_recipe(dto);
	}

	@Override
	public void insert_recipe_ingredient(int recipe_id, RecipeWriteDTO dto) {
		String[] names = dto.getIngredient_name();
		String[] amounts = dto.getIngredient_amount();

		for (int i = 0; i < names.length; i++) {
			RecipeIngredientDTO RIDTO = new RecipeIngredientDTO();

			RIDTO.setRecipe_id(recipe_id);
			RIDTO.setIngredient_name(names[i]);
			RIDTO.setIngredient_amount(amounts[i]);

			RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
			dao.insert_recipe_ingredient(RIDTO);
		}
	}

	@Override
	public void delete_recipe_ingredient(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.delete_recipe_ingredient(recipe_id);
	}

	@Override
	public void insert_recipe_step(int recipe_id, RecipeWriteDTO dto) {
		int[] nums = dto.getStep_no();
		String[] contents = dto.getStep_content();

		for (int i = 0; i < contents.length; i++) {
			RecipeStepDTO RSDTO = new RecipeStepDTO();

			RSDTO.setRecipe_id(recipe_id);
			RSDTO.setStep_no(nums[i] + 1);
			RSDTO.setStep_content(contents[i]);

			RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
			dao.insert_recipe_step(RSDTO);
		}
	}

	@Override
	public void delete_recipe_step(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.delete_recipe_step(recipe_id);
	}

	@Override
	public void insert_recipe_tag(int recipe_id, RecipeWriteDTO dto) {
		String[] tags = dto.getTags();

		for (int i = 0; i < tags.length; i++) {
			RecipeTagDTO RTDTO = new RecipeTagDTO();

			RTDTO.setRecipe_id(recipe_id);
			RTDTO.setTag(tags[i]);

			RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
			dao.insert_recipe_tag(RTDTO);
		}
	}

	@Override
	public void delete_recipe_tag(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.delete_recipe_tag(recipe_id);
	}

	@Override
	public void insert_recipe_image(RecipeImageDTO dto) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.insert_recipe_image(dto);
	}

	@Override
	public String find_recipe_image_path(@Param("recipe_id") int recipe_id, @Param("step_no") int step_no) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		String image_path = dao.find_recipe_image_path(recipe_id, step_no);
		return image_path;
	}

	@Override
	public void delete_recipe_image(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.delete_recipe_image(recipe_id);
	}

	@Override
	public void delete_recipe(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeImageDTO> dto = dao.recipe_image(recipe_id);
		fileStorageService.delete_image(dto);
		dao.delete_recipe(recipe_id);
	}

	@Override
	public List<RecipeDTO> recipe_list() {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeDTO> dto = dao.recipe_list();
		return dto;
	}

	@Override
	public List<RecipeDTO> my_recipe_list(int mf_no) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeDTO> dto = dao.my_recipe_list(mf_no);
		return dto;
	}

	@Override
	public List<RecipeDTO> follow_recipe_list(int mf_no) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeDTO> dto = dao.follow_recipe_list(mf_no);
		return dto;
	}

	@Override
	public RecipeDTO recipe(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		RecipeDTO dto = dao.recipe(recipe_id);
		return dto;
	}

	@Override
	public List<RecipeIngredientDTO> recipe_ingredient(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeIngredientDTO> dto = dao.recipe_ingredient(recipe_id);
		return dto;
	}

	@Override
	public List<RecipeStepDTO> recipe_step(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeStepDTO> dto = dao.recipe_step(recipe_id);
		return dto;
	}

	@Override
	public List<RecipeImageDTO> recipe_image(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeImageDTO> dto = dao.recipe_image(recipe_id);
		return dto;
	}

	@Override
	public List<RecipeTagDTO> recipe_tag(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		List<RecipeTagDTO> dto = dao.recipe_tag(recipe_id);
		return dto;
	}

	@Override
	public int recipe_recommend_count(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		int count = dao.recipe_recommend_count(recipe_id);
		return count;
	}

	@Override
	public void modify_recipe_star(int recipe_id) {
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);
		dao.modify_recipe_star(recipe_id);
	}
}