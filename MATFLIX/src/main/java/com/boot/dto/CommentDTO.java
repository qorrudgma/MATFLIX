package com.boot.dto;

import java.sql.Timestamp;

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
	private Timestamp commentCreatedTime;
}
