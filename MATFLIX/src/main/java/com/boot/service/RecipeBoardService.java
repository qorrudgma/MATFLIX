package com.boot.service;

import java.util.HashMap;

import com.boot.dto.RecipeBoardDTO;

public interface RecipeBoardService {
	public void insert_rc_board(HashMap<String, String> params, int rc_recipe_id);

	public RecipeBoardDTO get_board_by_id(int rc_recipe_id);
}
