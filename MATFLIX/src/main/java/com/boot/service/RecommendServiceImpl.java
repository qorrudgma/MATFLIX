package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecommendDAO;
import com.boot.dto.RecommendDTO;

@Service("RecommendService")
public class RecommendServiceImpl implements RecommendService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void recommend(RecommendDTO recomemdDTO) {
		RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
		dao.recommend(recomemdDTO);
	}

	@Override
	public int check_recommend(RecommendDTO recomemdDTO) {
		RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
		int check = dao.check_recommend(recomemdDTO);

		return check;
	}

	@Override
	public int total_recommend(int boardNo) {
		RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
		int total_recommend = dao.total_recommend(boardNo);

		return total_recommend;
	}

	@Override
	public void delete_recommend(RecommendDTO recomemdDTO) {
		RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
		dao.delete_recommend(recomemdDTO);
	}

	@Override
	public void delete_board(int boardNo) {
		RecommendDAO dao = sqlSession.getMapper(RecommendDAO.class);
		dao.delete_board(boardNo);
	}
}