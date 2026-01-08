package com.boot.service;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeRecommendDAO;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class RecipeRecommendServiceImpl implements RecipeRecommendService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no) {
		log.info("여기는 오나 {}, {}", recipe_id, mf_no);
		RecipeRecommendDAO dao = sqlSession.getMapper(RecipeRecommendDAO.class);
		dao.recipe_recommend(recipe_id, mf_no);
		log.info("성공?");
	}

	@Override
	public void add_recipe_recommend(int recipe_id) {
		RecipeRecommendDAO dao = sqlSession.getMapper(RecipeRecommendDAO.class);
		dao.add_recipe_recommend(recipe_id);
	}

	@Override
	public void delete_recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no) {
		RecipeRecommendDAO dao = sqlSession.getMapper(RecipeRecommendDAO.class);
		dao.delete_recipe_recommend(recipe_id, mf_no);
	}

	@Override
	public void minus_recipe_recommend(int recipe_id) {
		RecipeRecommendDAO dao = sqlSession.getMapper(RecipeRecommendDAO.class);
		dao.minus_recipe_recommend(recipe_id);
	}

	@Override
	public int check_recipe_recommend(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no) {
		RecipeRecommendDAO dao = sqlSession.getMapper(RecipeRecommendDAO.class);
		int recommend = dao.check_recipe_recommend(recipe_id, mf_no);
		return recommend;
	}
}