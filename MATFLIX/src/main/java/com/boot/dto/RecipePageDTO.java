package com.boot.dto;

import lombok.Data;

@Data
//@AllArgsConstructor
//@NoArgsConstructor
public class RecipePageDTO {
	private int rc_startPage; // 시작페이지 : 1, 11
	private int rc_endPage; // 끝페이지 : 10, 20
	private boolean rc_prev, rc_next;
	private int rc_total;
	private RecipeCriteria cri;

	public RecipePageDTO(int rc_total, RecipeCriteria cri) {
		this.rc_total = rc_total;
		this.cri = cri;

//		ex> 3페이지 = 3/10 -> 0.3 -> 1*10 = 10(끝페이지)
//		ex> 11페이지 = 11/10 -> 1.1 -> 2*10 = 20(끝페이지)
		this.rc_endPage = (int) Math.ceil((cri.getRc_pageNum() / 10.0)) * 10;

//		ex> 10-9 = 1페이지
//		ex> 20-9 = 11페이지
		this.rc_startPage = this.rc_endPage - 9;

//		ex> total : 300, 현재 페이지 : 3 -> rc_endPage : 10 => 300 * 1.0 / 10 => 30페이지
//		ex> total : 70, 현재 페이지 : 3 -> rc_endPage : 10 => 70 * 1.0 / 10 => 7페이지
		int realEnd = (int) Math.ceil((rc_total * 1.0) / cri.getRc_amount());
		if (realEnd <= this.rc_endPage) {
			this.rc_endPage = realEnd;
		}

//		1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
		this.rc_prev = this.rc_startPage > 1;

//		ex>10페이지 < 30페이지
		this.rc_next = this.rc_endPage < realEnd;
	}

}
