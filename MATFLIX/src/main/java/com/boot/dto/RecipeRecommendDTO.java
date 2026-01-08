package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeRecommendDTO {
	private int recommend_id;
	private int recipe_id;
	private int mf_no;
}