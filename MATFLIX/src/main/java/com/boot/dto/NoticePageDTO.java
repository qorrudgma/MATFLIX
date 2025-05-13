package com.boot.dto;

import lombok.Data;

@Data
//@AllArgsConstructor
//@NoArgsConstructor
public class NoticePageDTO {
	private int notice_startPage; // 시작페이지 : 1, 11
	private int notice_endPage; // 끝페이지 : 10, 20
	private boolean notice_prev, notice_next;
	private int notice_total;
	private NoticeCriteria notice_cri;

	public NoticePageDTO(int notice_total, NoticeCriteria notice_cri) {
		this.notice_total = notice_total;
		this.notice_cri = notice_cri;

//		ex> 3페이지 = 3/10 -> 0.3 -> 1*10 = 10(끝페이지)
//		ex> 11페이지 = 11/10 -> 1.1 -> 2*10 = 20(끝페이지)
		this.notice_endPage = (int) Math.ceil((notice_cri.getNotice_pageNum() / 10.0)) * 10;

//		ex> 10-9 = 1페이지
//		ex> 20-9 = 11페이지
		this.notice_startPage = this.notice_endPage - 9;

//		ex> total : 300, 현재 페이지 : 3 -> endPage : 10 => 300 * 1.0 / 10 => 30페이지
//		ex> total : 70, 현재 페이지 : 3 -> endPage : 10 => 70 * 1.0 / 10 => 7페이지
		int realEnd = (int) Math.ceil((notice_total * 1.0) / notice_cri.getNotice_amount());
		if (realEnd <= this.notice_endPage) {
			this.notice_endPage = realEnd;
		}

//		1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
		this.notice_prev = this.notice_startPage > 1;

//		ex>10페이지 < 30페이지
		this.notice_next = this.notice_endPage < realEnd;
	}

}
