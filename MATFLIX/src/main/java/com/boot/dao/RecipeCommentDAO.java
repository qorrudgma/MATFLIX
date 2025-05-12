package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentDAO {
	public void save(HashMap<String, String> param);

	public ArrayList<RecipeCommentDTO> findAll(int rc_boardNo);

	public int count_comment_by_id(@Param("mf_no") int mf_no, @Param("rc_boardNo") int rc_boardNo);
}
