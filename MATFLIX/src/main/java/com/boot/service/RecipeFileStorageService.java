package com.boot.service;

import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.RecipeWriteDTO;
import com.boot.dto.ReviewImageDTO;

public interface RecipeFileStorageService {
	public void save_image(int recipe_id, RecipeWriteDTO dto);

	public String save_review_image(ReviewImageDTO dto);

	public void modify_recipe_image(int recipe_id, RecipeWriteDTO dto);

	public void modify_revoiw_image(RecipeReviewWriteDTO dto);
}