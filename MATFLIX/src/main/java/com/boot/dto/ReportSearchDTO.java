package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReportSearchDTO {
	private int report_id; // 신고 PK
	private int reporter_mf_no; // 신고자 mf_no
	private String target_type; // USER / BOARD / COMMENT / RECIPE
	private int target_id; // 대상 PK
	private int target_owner_mf_no; // 대상 작성자 mf_no
	private String report_title;
	private String report_reason; // 성적 / 욕설 / 비하 / 차별 / 스팸 등
	private String report_detail;
	private String status; // PENDING / DONE / REJECTED
	private LocalDateTime created_at;
	private LocalDateTime updated_at;

	private int pageSize = 10;
	private int page = 1;
	private String type;
	private String keyword;

	public int getOffset() {
		return (page - 1) * pageSize;
	}

}