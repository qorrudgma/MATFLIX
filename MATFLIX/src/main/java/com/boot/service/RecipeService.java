package com.boot.service;

import java.util.List;

import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeIngredientDTO;
import com.boot.dto.RecipeStepDTO;
import com.boot.dto.RecipeTagDTO;
import com.boot.dto.RecipeWriteDTO;

public interface RecipeService {
	public void process_recipe_write(RecipeWriteDTO dto);

	public void insert_recipe(RecipeDTO dto);

	public void insert_recipe_ingredient(int recipe_id, RecipeWriteDTO dto);

	public void insert_recipe_step(int recipe_id, RecipeWriteDTO dto);

	public void insert_recipe_tag(int recipe_id, RecipeWriteDTO dto);

	public void insert_recipe_image(RecipeImageDTO dto);

	public void delete_recipe(int recipe_id);

	public List<RecipeDTO> recipe_list();

	public List<RecipeDTO> my_recipe_list(int mf_no);

	public RecipeDTO recipe(int recipe_id);

	public List<RecipeIngredientDTO> recipe_ingredient(int recipe_id);

	public List<RecipeStepDTO> recipe_step(int recipe_id);

	public List<RecipeImageDTO> recipe_image(int recipe_id);

	public List<RecipeTagDTO> recipe_tag(int recipe_id);

	public int recipe_recommend_count(int recipe_id);
}