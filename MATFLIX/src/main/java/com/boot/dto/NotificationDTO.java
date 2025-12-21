package com.boot.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotificationDTO {
	private int notifications_id;
	private int follower_id;
	private int following_id;
	private int boardNo;
	private int post_id;
	private int is_read;
	private LocalDateTime created_at;
	private String nickname;
	private String board_title;
}