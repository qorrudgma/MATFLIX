package com.boot.service;

import java.util.List;

import com.boot.dto.NotificationDTO;

public interface NotificationService {
	public void add_notification(NotificationDTO notificationDTO);

//	public List<NotificationDTO> notification_list(int follower_id);
	public List<NotificationDTO> notification_list_n(int follower_id);

	public void is_read_true(int notifications_id);

	public int notification_count(int notifications_id);

	public void delete_notification(int mf_no);
}