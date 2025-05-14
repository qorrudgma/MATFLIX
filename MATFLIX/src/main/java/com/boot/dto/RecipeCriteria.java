package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
//@NoArgsConstructor
public class RecipeCriteria {
	private int rc_pageNum;// 페이지 번호
	private int rc_amount;// 페이지당 글 갯수

	private String rc_type;
	private String rc_keyword;

	public RecipeCriteria() {
		this(1, 12);
	}

	public RecipeCriteria(int rc_pageNum, int rc_amount) {
		super();
		this.rc_pageNum = rc_pageNum;
		this.rc_amount = rc_amount;
	}
}
