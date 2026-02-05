package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdminUserDTO {
	private int mf_no;
	private String mf_id;
	private String mf_name;
	private String mf_nickname;
	private LocalDateTime created_at;
	private LocalDateTime last_login_at;
	private String status; // ACTIVE / SUSPENDED / BANNED

	// 시간
	private String display_time_created;
	private String display_time_last_login;
	// 접속
	private boolean online;
}