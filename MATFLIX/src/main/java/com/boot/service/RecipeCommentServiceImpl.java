package com.boot.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;
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
	public void insert_recipe_comment(RecipeCommentDTO recipeCommentDTO) {
		log.info("!@# insert_recipe_comment");
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		dao.insert_recipe_comment(recipeCommentDTO);
	}

	@Override
	public List<RecipeCommentDTO> all_recipe_comment(@Param("recipe_id") int recipe_id, @Param("mf_no") int mf_no) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		List<RecipeCommentDTO> recipe_coment_list = new ArrayList<>();
		recipe_coment_list = dao.all_recipe_comment(recipe_id, mf_no);
		return recipe_coment_list;
	}

	@Override
	public void recipe_comment_modify(RecipeCommentDTO recipeCommentDTO) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		dao.recipe_comment_modify(recipeCommentDTO);
	}

	@Override
	public void recipe_comment_delete(int comment_no) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		dao.recipe_comment_delete(comment_no);
	}

	@Override
	public void add_recipe_comment_recommend(int comment_no) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		dao.add_recipe_comment_recommend(comment_no);
	}

	@Override
	public void minus_recipe_comment_recommend(int comment_no) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		dao.minus_recipe_comment_recommend(comment_no);
	}
}