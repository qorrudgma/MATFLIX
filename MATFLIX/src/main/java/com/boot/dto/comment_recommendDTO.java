package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class comment_recommendDTO {
	private int c_recommend_id;
	private int commentNo;
	private int mf_no;
	private LocalDateTime createdTime;
	private LocalDateTime updateTime;
	// 화면 표시용
	private String f_createdTime;
	private String f_updateTime;
}