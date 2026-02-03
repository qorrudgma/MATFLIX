package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RankDTO {
	private int mf_no;
	private String mf_nickname;
	private int follower_count;
	private double avg_recipe_recommend;
	private double avg_recipe_star;
	private double avg_board_recommend;
	private double ranking_score;
	private LocalDateTime calculated_at;

	// 화면
	private String profile_image_path;
}