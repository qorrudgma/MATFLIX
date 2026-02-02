package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentDAO {
	public void insert_recipe_comment(RecipeCommentDTO recipeCommentDTO);

	public List<RecipeCommentDTO> all_recipe_comment(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no);

	public void recipe_comment_modify(RecipeCommentDTO recipeCommentDTO);

	public void recipe_comment_delete(int comment_no);

	public void add_recipe_comment_recommend(int comment_no);

	public void minus_recipe_comment_recommend(int comment_no);
}