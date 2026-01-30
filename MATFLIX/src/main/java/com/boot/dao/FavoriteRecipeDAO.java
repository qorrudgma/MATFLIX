package com.boot.dao;

import org.apache.ibatis.annotations.Param;

public interface FavoriteRecipeDAO {
	public void insert_favorite_recipe(@Param("mf_no") int mf_no, @Param("recipe_id") int recipe_id);

	public void delete_favorite_recipe(@Param("mf_no") int mf_no, @Param("recipe_id") int recipe_id);

	public int check_favorite_recipe(@Param("mf_no") int mf_no, @Param("recipe_id") int recipe_id);
}
