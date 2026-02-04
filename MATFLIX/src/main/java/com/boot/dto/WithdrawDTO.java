package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WithdrawDTO {
	private int withdraw_id;
	private int mf_no;
	private String reason_type;
	private String reason_detail;
	private LocalDateTime withdraw_date;

	private String mf_pw;
}