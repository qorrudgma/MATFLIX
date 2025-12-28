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
	// 화면 표시용
	private String commentTime;
}