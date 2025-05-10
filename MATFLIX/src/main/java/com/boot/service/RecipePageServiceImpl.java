package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipePageDAO;
import com.boot.dto.RecipeCriteria;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipePageService")
public class RecipePageServiceImpl implements RecipePageService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public int[] listWithPaging(RecipeCriteria cri) {
		log.info("@# PageServiceImpl listWithPaging");
		log.info("@# cri" + cri);

		RecipePageDAO dao = sqlSession.getMapper(RecipePageDAO.class);
		int[] list = dao.listWithPaging(cri);

		return list;
	}

	@Override
	public int totalList(RecipeCriteria cri) {
		log.info("@# PageServiceImpl totalList");
		RecipePageDAO dao = sqlSession.getMapper(RecipePageDAO.class);
		int totalList = dao.totalList(cri);
		return totalList;
	}

}
