package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeImageDTO {
	private int image_id;
	private int recipe_id;
	private String image_type;
	private int step_no;
	private String image_path;
}