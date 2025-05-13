package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.NoticeBoardDTO;

public interface NoticeBoardService {
	public ArrayList<NoticeBoardDTO> list();

//	public void write(HashMap<String, String> param);
	public void write(NoticeBoardDTO boardDTO);

	public NoticeBoardDTO contentView(HashMap<String, String> param);

	public void modify(HashMap<String, String> param);

	public void delete(HashMap<String, String> param);
}
