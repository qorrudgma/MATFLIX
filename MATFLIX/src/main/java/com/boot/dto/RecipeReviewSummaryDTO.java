package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeReviewSummaryDTO {
	private int recipe_id;
	private int review_count;
	private int rating_sum;
	private int rating_5;
	private int rating_4;
	private int rating_3;
	private int rating_2;
	private int rating_1;
}