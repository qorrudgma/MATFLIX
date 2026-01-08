package com.boot.dao;

import java.util.List;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentDAO {
	public void insert_recipe_comment(RecipeCommentDTO recipeCommentDTO);

	public List<RecipeCommentDTO> all_recipe_comment(int recipt_id);
}