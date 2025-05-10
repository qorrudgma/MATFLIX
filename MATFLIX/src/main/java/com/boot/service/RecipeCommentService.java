package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.RecipeCommentDTO;

public interface RecipeCommentService {
	public void save(HashMap<String, String> param);

	public ArrayList<RecipeCommentDTO> findAll(int rc_boardNo);
}
