package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReportDisplayDTO {
	private Long report_id; // 신고 PK
	private Integer reporter_mf_no; // 신고자 mf_no
	private String target_type; // USER / BOARD / COMMENT / RECIPE
	private Long target_id; // 대상 PK
	private Integer target_owner_mf_no; // 대상 작성자 mf_no
	private String report_title;
	private String report_reason; // 성적 / 욕설 / 비하 / 차별 / 스팸 등
	private String report_detail;
	private String status; // PENDING / DONE / REJECTED
	private LocalDateTime created_at;
	private LocalDateTime updated_at;

	// 시간
	private String display_created_at;
	private String display_updated_at;

	// 화면
	private int reporter_mf_id;
	private String reporter_mf_nickname;
}