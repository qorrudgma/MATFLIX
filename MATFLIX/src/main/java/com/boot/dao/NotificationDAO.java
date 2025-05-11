package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface NotificationDAO {
	// 알림 데이터 넣기
	public void add_notification(@Param("following_id") int following_id, @Param("follower_id") int follower_id,
			@Param("post_id") int post_id);
}