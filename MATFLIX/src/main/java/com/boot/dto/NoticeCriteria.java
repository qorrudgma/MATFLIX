package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
//@NoArgsConstructor
public class NoticeCriteria {
	private int notice_pageNum;// 페이지 번호
	private int notice_amount;// 페이지당 글 갯수

	private String notice_type;
	private String notice_keyword;

	public NoticeCriteria() {
		this(1, 10);
	}

	public NoticeCriteria(int notice_pageNum, int notice_amount) {
		super();
		this.notice_pageNum = notice_pageNum;
		this.notice_amount = notice_amount;
	}
}
