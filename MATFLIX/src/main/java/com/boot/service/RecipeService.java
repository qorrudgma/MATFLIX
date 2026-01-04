package com.boot.service;

import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeIngredientDTO;
import com.boot.dto.RecipeStepDTO;
import com.boot.dto.RecipeTagDTO;
import com.boot.dto.RecipeWriteDTO;

public interface RecipeService {
	public void process_recipe_write(RecipeWriteDTO dto);

	public void insert_recipe(RecipeDTO dto);

	public void insert_recipe_ingredient(RecipeIngredientDTO dto);

	public void insert_recipe_step(RecipeStepDTO dto);

	public void insert_recipe_tag(RecipeTagDTO dto);
}