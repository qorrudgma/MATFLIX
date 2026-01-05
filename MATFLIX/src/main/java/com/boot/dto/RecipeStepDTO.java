package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeStepDTO {
	private int step_id;
	private int recipe_id;
	private int step_no;
	private String step_content;
}