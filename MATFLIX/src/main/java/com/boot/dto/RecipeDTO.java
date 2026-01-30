package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeDTO {
	private int recipe_id;
	private int mf_no;
	private String title;
	private String intro;
	private int servings;
	private int cook_time;
	private String difficulty;
	private String category;
	private String tip;
	private int star;
	private int recommend;
	private int recipe_favorite_count;
	private LocalDateTime created_at;
	private LocalDateTime updated_at;

	// 화면용
	private String display_updated_at;

	// 리스트용
	private String mf_nickname;
	private String image_path;
}