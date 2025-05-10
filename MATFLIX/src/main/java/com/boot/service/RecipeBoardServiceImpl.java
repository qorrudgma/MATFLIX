package com.boot.service;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeBoardDAO;
import com.boot.dto.RecipeBoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipeBoardService")
public class RecipeBoardServiceImpl implements RecipeBoardService {

	@Autowired
	private SqlSession session;

	@Override
	public void insert_rc_board(HashMap<String, String> params, int rc_recipe_id) {
		RecipeBoardDAO dao = session.getMapper(RecipeBoardDAO.class);

		RecipeBoardDTO boardDTO = new RecipeBoardDTO();

		boardDTO.setRc_boardName(params.get("rc_name"));
		boardDTO.setRc_boardTitle(params.get("rc_name"));
		boardDTO.setRc_boardContent(params.get("rc_description"));
		boardDTO.setRc_recipe_id(rc_recipe_id);

		dao.insert_rc_board(boardDTO);
	}

	@Override
	public RecipeBoardDTO get_board_by_id(int rc_recipe_id) {
		RecipeBoardDAO dao = session.getMapper(RecipeBoardDAO.class);
		RecipeBoardDTO dto = dao.get_board_by_id(rc_recipe_id);
		return dto;
	}
}
