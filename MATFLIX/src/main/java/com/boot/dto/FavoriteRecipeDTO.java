package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FavoriteRecipeDTO {
	private int favorite_no;
	private int recipe_id;
	private int mf_no;
	private LocalDateTime created_at;

	// 프로필용
	private String display_time;
	private String category;
	private String title;
	private String mf_nickname;
	private String image_path;
	private int star;
	private int review_count;
}