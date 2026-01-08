package com.boot.service;

import java.util.List;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentService {
	public void insert_recipe_comment(RecipeCommentDTO recipeCommentDTO);

	public List<RecipeCommentDTO> all_recipe_comment(int recipt_id);

//	public void add_recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no);
}