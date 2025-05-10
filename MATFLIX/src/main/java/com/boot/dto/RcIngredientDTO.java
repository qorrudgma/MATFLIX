package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RcIngredientDTO {
	private int rc_ingredient_id;
	private int rc_recipe_id;
	private String rc_ingredient_name;
	private String rc_ingredient_amount;
}
