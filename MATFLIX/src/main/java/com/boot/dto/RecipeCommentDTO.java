package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeCommentDTO {
	private int comment_no;
	private int recipe_id;
	private int mf_no;
	private String comment_content;
	private int parentCommentNo;
	private int deleted;
	private LocalDateTime created_at;
	private LocalDateTime updated_at;
	private int recommend_count;
	private int recommend_notify_step;

	// 화면에 보여지는 시간
	private LocalDateTime display_time;
}
