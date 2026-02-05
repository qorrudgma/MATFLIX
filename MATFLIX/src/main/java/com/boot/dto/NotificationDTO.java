package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotificationDTO {
	private int notif_id;
	private int receiver_id; // 알림 받는 사람
	private int sender_id; // 알림 발생 시킨 사람
	private String notif_type; // 'FOLLOW', 'CREATE', 'COMMENT', 'LIKE'
	private String target_type; // 'USER', 'BOARD', 'COMMENT', 'RECIPE', 'REVIEW'
	private int target_id; // 어디서 알림 발생했나
	private int is_read;
	private LocalDateTime created_at;

	// 화면
	private String mf_nickname;
}