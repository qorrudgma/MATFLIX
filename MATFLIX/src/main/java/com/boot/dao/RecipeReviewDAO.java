package com.boot.dao;

import java.util.List;

import com.boot.dto.RecipeReviewDTO;
import com.boot.dto.RecipeReviewSummaryDTO;
import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.ReviewImageDTO;

public interface RecipeReviewDAO {
	public void process_recipe_write(RecipeReviewWriteDTO dto);

	public void insert_review(RecipeReviewDTO dto);

	public void modify_review(RecipeReviewDTO dto);

	public void delete_review(int recipe_id);

	public List<RecipeReviewDTO> review_list();

//	이미지
	public void insert_review_image(ReviewImageDTO imageDTO);

	public List<ReviewImageDTO> review_image_list(int review_id);

	// 리뷰 별점
	public void insert_review_summary(RecipeReviewSummaryDTO dto);

	public RecipeReviewSummaryDTO review_summary_list(int review_id);
}