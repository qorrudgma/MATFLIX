package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.*;

public interface NoticeBoardDAO {
	public ArrayList<NoticeBoardDTO> list();
//	public void write(HashMap<String, String> param);
	public void write(NoticeBoardDTO boardDTO);
	public NoticeBoardDTO contentView(HashMap<String, String> param);
	public void modify(HashMap<String, String> param);
	public void delete(HashMap<String, String> param);
}















