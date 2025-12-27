package com.boot.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardDTO {
	private int boardNo;
	private String boardName;
	private String boardTitle;
	private String boardContent;
	private LocalDateTime boardDate;
	// 화면 표시용 날짜
	private String displayDate;
	private int boardHit;
	private int mf_no;
	private int recommend_count;
	private int recommend_notify_step;
	private int comment_count;

	private List<BoardAttachDTO> attachList;
}