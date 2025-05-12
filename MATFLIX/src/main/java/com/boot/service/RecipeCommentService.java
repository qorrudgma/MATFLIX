package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentService {
	public void save(HashMap<String, String> param, @Param("mf_no") int mf_no);

	public ArrayList<RecipeCommentDTO> findAll(int rc_boardNo);

	public int count_comment_by_id(int mf_no, int rc_boardNo);
}
