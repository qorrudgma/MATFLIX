package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReportImageDTO {
	private int report_id; // 신고 PK
	private String image_path;
	private String original_name;
	private int sort_no;
	private LocalDateTime created_at;
}