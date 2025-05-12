package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeCommentDAO;
import com.boot.dto.RecipeCommentDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipeCommentService")
public class RecipeCommentServiceImpl implements RecipeCommentService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void save(HashMap<String, String> param, int mf_no) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		param.put("mf_no", String.valueOf(mf_no)); // mf_no를 HashMap에 추가
		dao.save(param); // 수정된 HashMap을 DAO에 전달
	}

	@Override
	public ArrayList<RecipeCommentDTO> findAll(int rc_boardNo) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		ArrayList<RecipeCommentDTO> list = dao.findAll(rc_boardNo);
		return list;
	}

	@Override
	public int count_comment_by_id(int mf_no, int rc_boardNo) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		log.info("Service 된다.");
		int result = dao.count_comment_by_id(mf_no, rc_boardNo);
		return result;
	}

}
