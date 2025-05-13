package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.boot.dto.BoardDTO;

public interface BoardService {
	public ArrayList<BoardDTO> list();

	public void write(BoardDTO boardDTO);

	public BoardDTO contentView(HashMap<String, String> param);

	public void modify(HashMap<String, String> param);

	public void delete(HashMap<String, String> param);

	public void hitUp(HashMap<String, String> param);

	public void hitDown(int boardNo);

	public List<Map<String, Object>> profile_board_list(int mf_no);
}