package com.boot.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeDTO {
	private int rc_recipe_id;
	private String rc_name;
	private String rc_description;
	private int rc_category1_id;
	private String rc_category2_id;
	private int rc_cooking_time;
	private String rc_difficulty;
	private Date rc_created_at;
	private String rc_img;
	private String rc_tip;
	private String rc_tag;
}
