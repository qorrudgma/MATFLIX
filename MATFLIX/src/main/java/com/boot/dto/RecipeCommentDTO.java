package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeCommentDTO {
	private int rc_commentNo;
	private String rc_commentWriter;
	private String rc_commentContent;
	private int rc_boardNo;
	private Timestamp rc_commentCreatedTime;
}
