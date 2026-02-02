package com.boot.service;

import java.util.List;

import com.boot.dto.ProfileImageDTO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.RecipeWriteDTO;
import com.boot.dto.ReviewImageDTO;

public interface FileStorageService {
	public void save_image(int recipe_id, RecipeWriteDTO dto);

	public void delete_image(List<RecipeImageDTO> dto);

	public String save_review_image(ReviewImageDTO dto);

	public void modify_recipe_image(int recipe_id, RecipeWriteDTO dto);

	public void delete_revoiw_image(int recipe_id);

	public void modify_revoiw_image(RecipeReviewWriteDTO dto);

	public void modify_profile_image(ProfileImageDTO dto);
}