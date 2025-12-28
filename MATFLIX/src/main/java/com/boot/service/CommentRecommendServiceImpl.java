package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.CommentRecommendDAO;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service("CommentRecommendService")
public class CommentRecommendServiceImpl implements CommentRecommendService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_comment_recommend(int commentNo, int mf_no) {
		log.info("여기는 오나?");
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		dao.add_comment_recommend(commentNo, mf_no);
	}

	@Override
	public void minus_comment_recommend(int commentNo, int mf_no) {
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		dao.minus_comment_recommend(commentNo, mf_no);
	}

	@Override
	public void delete_comment(int commentNo) {
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		dao.delete_comment(commentNo);
	}

	@Override
	public int comment_yn(int commentNo, int mf_no) {
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		int yn = dao.comment_yn(commentNo, mf_no);
		return yn;
	}
}