package com.boot.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FollowDTO {
	private int follow_id;
	private int follower_id;
	private int following_id;
	private String follower_email;
	private Date follow_time;
}
