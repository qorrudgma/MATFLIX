package com.boot.dao;

import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeIngredientDTO;
import com.boot.dto.RecipeStepDTO;
import com.boot.dto.RecipeTagDTO;

public interface RecipeDAO {
	public void insert_recipe(RecipeDTO dto);

	public void insert_recipe_ingredient(RecipeIngredientDTO dto);

	public void insert_recipe_step(RecipeStepDTO dto);

	public void insert_recipe_tag(RecipeTagDTO dto);

	public void insert_recipe_image(RecipeImageDTO dto);

	public void delete_recipe(int recipe_id);
}