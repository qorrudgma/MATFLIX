package com.boot.service;

import java.util.ArrayList;
import java.util.List;

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
	public List<RecipeCommentDTO> all_recipe_comment(int recipt_id) {
		RecipeCommentDAO dao = sqlSession.getMapper(RecipeCommentDAO.class);
		List<RecipeCommentDTO> recipe_coment_list = new ArrayList<>();
		recipe_coment_list = dao.all_recipe_comment(recipt_id);
		return recipe_coment_list;
	}

}
