package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NoticeBoardDTO {
	private int notice_boardNo;
	private String notice_boardName;
	private String notice_boardTitle;
	private String notice_boardContent;
	private Timestamp notice_boardDate;
	private int notice_boardHit;
	private int mf_no;
}
