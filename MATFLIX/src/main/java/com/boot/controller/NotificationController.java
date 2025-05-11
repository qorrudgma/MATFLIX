/*==========================================================
* 파일명     : TeamController.java
* 작성자     : 손병관
* 작성일자   : 2025-05-09
* 설명       : 이 클래스는 [로그인, 회원가입, 회원 정보 수정, 닉네임 변경, 회원 삭제까지 구현한 controller 입니다.]


* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-07   손병관       최초 생성
* 2025-05-07   손병관       로그인 및 회원가입 구현
* 2025-05-08   손병관       마이페이지 동작
* 2025-05-08   손병관       회원 정보 수정 구현
* 2025-05-09   손병관       회원 탈퇴 및 닉네임 변경 구현
============================================================*/

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