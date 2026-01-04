package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dto.RecipeWriteDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipeFileStorageService")
public class RecipeFileStorageServiceImpl implements RecipeFileStorageService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void save_image(int recipe_id, RecipeWriteDTO dto) {
		// 여기에 저장하는 로직 짜야함
	}
}