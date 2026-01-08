package com.boot.service;

import org.apache.ibatis.annotations.Param;

public interface RecipeRecommendService {
	public void recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no);

	public void add_recipe_recommend(int recipe_id);

	public void delete_recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no);

	public void minus_recipe_recommend(int recipe_id);

	public int check_recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no);
}