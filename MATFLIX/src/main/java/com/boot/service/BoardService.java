package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.BoardDTO;

public interface BoardService {
	public ArrayList<BoardDTO> list();

	public void write(BoardDTO boardDTO);

	public BoardDTO contentView(HashMap<String, String> param);

	public void modify(HashMap<String, String> param);

	public void delete(HashMap<String, String> param);

	public void hitUp(HashMap<String, String> param);
}
