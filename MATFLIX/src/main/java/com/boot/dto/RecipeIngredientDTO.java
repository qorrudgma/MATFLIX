package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeIngredientDTO {
	private int ingredient_id;
	private int recipe_id;
	private String ingredient_name;
	private String ingredient_amount;
}