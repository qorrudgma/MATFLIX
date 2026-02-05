package com.boot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.NotificationDTO;
import com.boot.service.BoardService;
import com.boot.service.NotificationService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NotificationController {

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private BoardService boardService;

	// 알림 리스트 가져오기
//	@RequestMapping("/notification_list")
//	@ResponseBody
//	public List<NotificationDTO> notification_list(@RequestParam("follower_id") int follower_id) {
//		List<NotificationDTO> notification_list = notificationService.notification_list(follower_id);
//		log.info("notification_list => " + notification_list);
//		return notification_list;
//	}

	@RequestMapping("/notification_list_n")
	@ResponseBody
	public List<NotificationDTO> notification_list_n(@RequestParam("receiver_id") int receiver_id) {
		List<NotificationDTO> notification_list_n = notificationService.notification_list_n(receiver_id);
		log.info("notification_list_n => " + notification_list_n);
		return notification_list_n;
	}

	// 알림 게시글 이동
//	@RequestMapping("/move_board")
//	@ResponseBody
//	public String move_board(@RequestParam("boardNo") int boardNo, Model model) {
//		log.info("move_board()");
//
//		HashMap<String, String> param = new HashMap<>();
//		String board_no = Integer.toString(boardNo);
//		param.put("boardNo", board_no);
//		BoardDTO dto = boardService.contentView(param);
//
//		return "content_view";
//	}

	// 알림 읽음 처리
	@RequestMapping("/is_read_true")
	@ResponseBody
	public void is_read_true(@RequestParam("notif_id") int notif_id) {
		log.info("is_read_true()");

		notificationService.is_read_true(notif_id);
	}

}