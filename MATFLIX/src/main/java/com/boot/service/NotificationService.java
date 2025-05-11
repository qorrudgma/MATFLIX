package com.boot.service;

import org.apache.ibatis.annotations.Param;

public interface NotificationService {
	public void add_notification(@Param("following_id") int following_id, @Param("follower_id") int follower_id,
			@Param("post_id") int post_id);
}