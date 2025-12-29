package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentDTO {
	private int commentNo;
	private String commentWriter;
	private String commentContent;
	private int boardNo;
	private int userNo;
	private LocalDateTime commentCreatedTime;
	private int deleted;
	private int parentCommentNo;
	private LocalDateTime updatedTime;
	private int recommend_count;
	private int recommend_notify_step;
	// 화면 표시용
	private String commentTime;
	private String comment_updatedTime;
	// 조회용
	private int recommended;
}