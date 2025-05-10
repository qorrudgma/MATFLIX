package com.boot.dao;

import com.boot.dto.RecipeCriteria;

public interface RecipePageDAO {
//	Criteria 객체를 이용해서 페이징 처리
	public int[] listWithPaging(RecipeCriteria cri);

	public int totalList(RecipeCriteria cri);
}
