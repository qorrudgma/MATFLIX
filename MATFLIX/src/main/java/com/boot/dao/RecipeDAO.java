package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RcCourseDTO;
import com.boot.dto.RcIngredientDTO;
import com.boot.dto.RecipeDTO;

public interface RecipeDAO {
// 요리 등록
	public void insert_recipe(HashMap<String, String> recipeData);

// 요리 과정 등록
	public void insert_rc_course(@Param("rc_course_description") String rc_course_description);

// 요리 재료 등록
	public void insert_rc_ingredient(@Param("rc_ingredient_name") String rc_ingredient_name,
			@Param("rc_ingredient_amount") String rc_ingredient_amount);

//===========================================================================
//	각 카테고리 별 레시피 아이디 추출
	public int[] get_food(int rc_category1_id);

//	모든 요리 정보 가져옴
	public ArrayList<RecipeDTO> find_list_all();

//===========================================================================
//	해당 요리정보 가져오기
	public RecipeDTO get_recipe_by_id(int rc_recipe_id);

	public ArrayList<RcIngredientDTO> get_recipe_ingredient_by_id(int rc_recipe_id);

	public ArrayList<RcCourseDTO> get_recipe_course_by_id(int rc_recipe_id);

//===========================================================================
//	페이징 리스트
	public RecipeDTO paging_recipe_list(int rc_recipe_id);

//===========================================================================
//	마이페이지 내 내레시피
	public ArrayList<RecipeDTO> get_recipe_by_user_id(String mf_no);

//===========================================================================
//	레시피 아이디로 멤버 넘버 추출
	public int get_mf_no_by_id(int rc_recipe_id);

//===========================================================================
//	요리 별점 업데이트
	public void update_star_score(@Param("star_score") double star_score, @Param("rc_recipe_id") int rc_recipe_id);
}
