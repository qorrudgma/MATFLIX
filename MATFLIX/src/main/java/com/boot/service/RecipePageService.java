package com.boot.service;

import com.boot.dto.RecipeCriteria;

public interface RecipePageService {
	public int[] listWithPaging(RecipeCriteria cri);

	public int totalList(RecipeCriteria cri);
}
