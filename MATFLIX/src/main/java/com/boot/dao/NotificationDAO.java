package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.NotificationDTO;

@Mapper
public interface NotificationDAO {
	// 알림 데이터 넣기
	public void add_notification(@Param("following_id") int following_id, @Param("follower_id") int follower_id,
			@Param("boardNo") int boardNo, @Param("post_id") int post_id);

	public List<NotificationDTO> notification_list(int follower_id);

	public void is_read_true(int notifications_id);
}