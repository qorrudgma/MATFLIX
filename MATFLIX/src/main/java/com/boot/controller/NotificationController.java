package com.boot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.NotificationDTO;
import com.boot.service.NotificationService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NotificationController {

	@Autowired
	private NotificationService notificationService;

	// 알림 리스트 가져오기
	@RequestMapping("/notification_list")
	public List<NotificationDTO> notification_list(int follower_id) {
		List<NotificationDTO> notification_list = notificationService.notification_list(follower_id);
		return notification_list;
	}

}