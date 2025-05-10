package com.boot.dao;

import com.boot.dto.RecipeBoardDTO;

public interface RecipeBoardDAO {
	public void insert_rc_board(RecipeBoardDTO dto);

	public RecipeBoardDTO get_board_by_id(int rc_recipe_id);
}
