package com.boot.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.BoardDTO;
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
	@RequestMapping("/notification_list")
	@ResponseBody
	public List<NotificationDTO> notification_list(@RequestParam("follower_id") int follower_id) {
		List<NotificationDTO> notification_list = notificationService.notification_list(follower_id);
		log.info("notification_list()");
		log.info("notification_list => " + notification_list);
		return notification_list;
	}

	// 알림 게시글 이동
	@RequestMapping("/move_board")
	@ResponseBody
	public String move_board(@RequestParam("boardNo") int boardNo, Model model) {
		log.info("move_board()");

		HashMap<String, String> param = new HashMap<>();
		String board_no = Integer.toString(boardNo);
		param.put("boardNo", board_no);
		BoardDTO dto = boardService.contentView(param);

		return "content_view";
	}
}