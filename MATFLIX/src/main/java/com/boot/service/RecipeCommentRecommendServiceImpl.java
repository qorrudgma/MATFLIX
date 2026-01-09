package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeCommentDAO;
import com.boot.dao.RecipeCommentRecommendDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipeCommentRecommendService")
public class RecipeCommentRecommendServiceImpl implements RecipeCommentRecommendService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_recipe_comment_recommend(int comment_no, int mf_no) {
		RecipeCommentRecommendDAO RCRdao = sqlSession.getMapper(RecipeCommentRecommendDAO.class);
		RecipeCommentDAO RCdao = sqlSession.getMapper(RecipeCommentDAO.class);

		RCRdao.add_recipe_comment_recommend(comment_no, mf_no);
		RCdao.add_recipe_comment_recommend(comment_no);
	}

	@Override
	public void minus_recipe_comment_recommend(int comment_no, int mf_no) {
		RecipeCommentRecommendDAO RCRdao = sqlSession.getMapper(RecipeCommentRecommendDAO.class);
		RecipeCommentDAO RCdao = sqlSession.getMapper(RecipeCommentDAO.class);

		RCRdao.minus_recipe_comment_recommend(comment_no, mf_no);
		RCdao.minus_recipe_comment_recommend(comment_no);
	}

	@Override
	public int recipe_comment_yn(int comment_no, int mf_no) {
		RecipeCommentRecommendDAO dao = sqlSession.getMapper(RecipeCommentRecommendDAO.class);
		int yn = dao.recipe_comment_yn(comment_no, mf_no);
		return yn;
	}
}