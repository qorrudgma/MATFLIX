package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.NotificationDTO;

@Mapper
public interface NotificationDAO {
	// 알림 데이터 넣기
	public void add_notification(NotificationDTO notificationDTO);

	public List<NotificationDTO> notification_list_n(int receiver_id);

	public void is_read_true(int notifications_id);

	public int notification_count(int notifications_id);

	public void delete_notification(int mf_no);
}