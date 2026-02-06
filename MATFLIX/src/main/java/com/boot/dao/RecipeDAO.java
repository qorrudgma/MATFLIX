package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeIngredientDTO;
import com.boot.dto.RecipeStepDTO;
import com.boot.dto.RecipeTagDTO;

public interface RecipeDAO {
	public void insert_recipe(RecipeDTO dto);

	public void modify_recipe(RecipeDTO dto);

	public void insert_recipe_ingredient(RecipeIngredientDTO dto);

	public void delete_recipe_ingredient(int recipe_id);

	public void insert_recipe_step(RecipeStepDTO dto);

	public void delete_recipe_step(int recipe_id);

	public void insert_recipe_tag(RecipeTagDTO dto);

	public void delete_recipe_tag(int recipe_id);

	public void insert_recipe_image(RecipeImageDTO dto);

	public void delete_recipe_image(int recipe_id);

	public String find_recipe_image_path(@Param("recipe_id") int recipe_id, @Param("step_no") int step_no);

	public void delete_recipe(int recipe_id);

	public List<RecipeDTO> recipe_list();

	public List<RecipeDTO> my_recipe_list(int mf_no);

	public List<RecipeDTO> follow_recipe_list(int mf_no);

	public RecipeDTO recipe(int recipe_id);

	public List<RecipeIngredientDTO> recipe_ingredient(int recipe_id);

	public List<RecipeStepDTO> recipe_step(int recipe_id);

	public List<RecipeImageDTO> recipe_image(int recipe_id);

	public List<RecipeTagDTO> recipe_tag(int recipe_id);

	public int recipe_recommend_count(int recipe_id);

	public int recipe_mf_no(int recipe_id);

	public void modify_recipe_star(int recipe_id);
}