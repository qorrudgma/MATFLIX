package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotifSettingDTO {
	private int mf_no;
	private int follow_yn;
	private int board_comment_yn;
	private int board_reaction_yn;
	private int recipe_review_yn;
	private int recipe_comment_yn;
	private int recipe_reaction_yn;
	private int recomment_yn;
	private int comment_reaction_yn;
}