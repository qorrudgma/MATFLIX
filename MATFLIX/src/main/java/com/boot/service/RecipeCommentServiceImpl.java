package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeCommentDAO;
import com.boot.dto.RecipeCommentDTO;

@Service("RecipeCommentService")
public class RecipeCommentServiceImpl implements RecipeCommentService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void save(HashMap<String, String> param) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		dao.save(param);
	}

	@Override
	public ArrayList<RecipeCommentDTO> findAll(int rc_boardNo) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		ArrayList<RecipeCommentDTO> list = dao.findAll(rc_boardNo);
		return list;
	}

}
