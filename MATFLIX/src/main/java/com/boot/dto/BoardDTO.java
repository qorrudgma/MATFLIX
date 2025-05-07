package com.boot.dto;

import java.sql.Timestamp;
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
	private Timestamp boardDate;
	private int boardHit;
	
	private List<BoardAttachDTO> attachList;
}











