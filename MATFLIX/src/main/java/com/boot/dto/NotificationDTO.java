package com.boot.dto;

import java.sql.Date;

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
	private boolean is_read;
	private Date created_at;
}
