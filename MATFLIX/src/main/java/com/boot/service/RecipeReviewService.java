package com.boot.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RecipeReviewDTO;
import com.boot.dto.RecipeReviewSummaryDTO;
import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.ReviewImageDTO;

public interface RecipeReviewService {
	public void process_review_write(RecipeReviewWriteDTO dto);

	public void insert_review(RecipeReviewDTO dto);

	public void modify_review(RecipeReviewWriteDTO dto);

	public void update_review_image(ReviewImageDTO dto);

	public void delete_review(int review_id);

	public RecipeReviewDTO find_delete_review_data(int review_id);

	public List<RecipeReviewDTO> review_list();

	public RecipeReviewDTO select_review(int review_id);

//	이미지
	public void insert_review_image(ReviewImageDTO imageDTO);

	public void delete_review_image(int recipe_id);

	public String review_image_path(int recipe_id);

	public List<ReviewImageDTO> review_image_list(@Param("recipe_id") int recipe_id, @Param("sort") String sort);

	// 리뷰 별점
	public void insert_review_summary(RecipeReviewSummaryDTO dto);

	public RecipeReviewSummaryDTO review_summary_list(int review_id);

	public void update_review_summary(RecipeReviewSummaryDTO dto);

	public void delete_review_summary(RecipeReviewSummaryDTO dto);
}