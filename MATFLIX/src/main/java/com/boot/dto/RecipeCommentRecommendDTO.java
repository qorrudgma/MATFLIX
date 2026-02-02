package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeCommentRecommendDTO {
	private int recipe_comment_recommend_id;
	private int comment_no;
	private int mf_no;
	private LocalDateTime updated_at;

	// 화면에 보여지는 시간
	private LocalDateTime display_time;
	private int recommended;
}