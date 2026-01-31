package com.boot.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.FavoriteRecipeDAO;
import com.boot.dto.FavoriteRecipeDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service("FavoriteRecipeService")
@RequiredArgsConstructor
@Slf4j
public class FavoriteRecipeServiceImpl implements FavoriteRecipeService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void insert_favorite_recipe(int mf_no, int recipe_id) {
		FavoriteRecipeDAO dao = sqlSession.getMapper(FavoriteRecipeDAO.class);
		dao.insert_favorite_recipe(mf_no, recipe_id);
	}

	@Override
	public void delete_favorite_recipe(int mf_no, int recipe_id) {
		FavoriteRecipeDAO dao = sqlSession.getMapper(FavoriteRecipeDAO.class);
		dao.delete_favorite_recipe(mf_no, recipe_id);
	}

	@Override
	public int check_favorite_recipe(int mf_no, int recipe_id) {
		FavoriteRecipeDAO dao = sqlSession.getMapper(FavoriteRecipeDAO.class);
		int favorite_check = dao.check_favorite_recipe(mf_no, recipe_id);
		return favorite_check;
	}

	@Override
	public List<FavoriteRecipeDTO> favorite_recipe_list(int mf_no) {
		FavoriteRecipeDAO dao = sqlSession.getMapper(FavoriteRecipeDAO.class);
		List<FavoriteRecipeDTO> favorite_recipe_list = dao.favorite_recipe_list(mf_no);
		return favorite_recipe_list;
	}
}