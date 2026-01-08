package com.boot.service;

import java.util.List;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentService {
	public void insert_recipe_comment(RecipeCommentDTO recipeCommentDTO);

	public List<RecipeCommentDTO> all_recipe_comment(int recipt_id);
}