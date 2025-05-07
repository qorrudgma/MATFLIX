package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.*;

public interface CommentDAO {
	public void save(HashMap<String, String> param);
	public ArrayList<CommentDTO> findAll(HashMap<String, String> param);
}















