package com.boot.service;

import org.apache.ibatis.annotations.Param;

public interface RecipeCommentRecommendService {
	public void add_recipe_comment_recommend(@Param("comment_no") int comment_no, @Param("mf_no") int mf_no);

	public void minus_recipe_comment_recommend(@Param("comment_no") int comment_no, @Param("mf_no") int mf_no);

	public int recipe_comment_yn(@Param("comment_no") int comment_no, @Param("mf_no") int mf_no);
}