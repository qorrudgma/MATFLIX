package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeDAO;
import com.boot.dto.RcCourseDTO;
import com.boot.dto.RcIngredientDTO;
import com.boot.dto.RecipeDTO;

@Service
public class RecipeServiceImpl implements RecipeService {

	@Autowired
	private SqlSession session;

	// 요리 등록
	// =====================================================================
	@Override
	public void insert_recipe(HashMap<String, String> recipeData) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		dao.insert_recipe(recipeData);
	}

	@Override
	public void insert_rc_course(String rc_course_description) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		dao.insert_rc_course(rc_course_description);
	}

	@Override
	public void insert_rc_ingredient(String rc_ingredient_name, String rc_ingredient_amount) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		dao.insert_rc_ingredient(rc_ingredient_name, rc_ingredient_amount);
	}

//	각 카테고리 별 레시피 아이디 추출	
//=====================================================================
	@Override
	public int[] get_food(int rc_category1_id) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		int[] result = dao.get_food(rc_category1_id);
		return result;
	}

//	모든 요리 정보 리스트
//=====================================================================
	@Override
	public ArrayList<RecipeDTO> find_list_all() {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		ArrayList<RecipeDTO> list = dao.find_list_all();
		return list;
	}

//	해당 요리정보 가져오기
//===========================================================================
	@Override
	public RecipeDTO get_recipe_by_id(int rc_recipe_id) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		RecipeDTO dto = dao.get_recipe_by_id(rc_recipe_id);
		return dto;
	}

	@Override
	public ArrayList<RcIngredientDTO> get_recipe_ingredient_by_id(int rc_recipe_id) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		ArrayList<RcIngredientDTO> Ingdto = dao.get_recipe_ingredient_by_id(rc_recipe_id);
		return Ingdto;
	}

	@Override
	public ArrayList<RcCourseDTO> get_recipe_course_by_id(int rc_recipe_id) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		ArrayList<RcCourseDTO> coursedto = dao.get_recipe_course_by_id(rc_recipe_id);
		return coursedto;
	}

//	페이징 리스트
//===========================================================================	
	@Override
	public RecipeDTO paging_recipe_list(int rc_recipe_id) {
		RecipeDAO dao = session.getMapper(RecipeDAO.class);
		RecipeDTO dto = dao.paging_recipe_list(rc_recipe_id);
		return dto;
	}

}
