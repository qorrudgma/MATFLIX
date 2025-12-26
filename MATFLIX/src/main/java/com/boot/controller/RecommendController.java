package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.boot.dto.RecommendDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.BoardService;
import com.boot.service.NotifSettingService;
import com.boot.service.NotificationService;
import com.boot.service.RecommendService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RecommendController {

	@Autowired
	private RecommendService recommendService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private NotifSettingService notifSettingService;

	@PostMapping("/recommend")
	@ResponseBody
	public String recommend(@SessionAttribute("user") TeamDTO user, @RequestParam int boardNo,
			@RequestParam int board_mf_no) {
		log.info("recommend() => " + board_mf_no);
		RecommendDTO dto = new RecommendDTO();
		dto.setBoardNo(boardNo);
		dto.setMf_no(user.getMf_no());

		int check = recommendService.check_recommend(dto);

		if (check == 1) {
			recommendService.delete_recommend(dto);
//			boardService.hitDown(boardNo);
			boardService.minus_board_recommend(boardNo);
			log.info("tbl_board에 추천 -1");
			log.info("추천을 취소함");
			return "delete";
		} else {
//			boardService.hitDown(boardNo);
			// 추천누름
			recommendService.recommend(dto);
//			log.info("추천을 누름");
			// 추천 증가
			boardService.add_board_recommend(boardNo);
			log.info("tbl_board에 추천 +1");
			// 추천 알림 체크
			int recommend_count = boardService.board_recommend(boardNo);
			log.info("recommend_count => " + recommend_count);
			if (recommend_count % 50 == 0) {
				int recommend_notify_step_count = boardService.recommend_notify_step(boardNo);
				if (recommend_count != recommend_notify_step_count) {
					// 추천 알림 증가
					boardService.update_recommend_notify_step(boardNo);
					log.info("update_recommend_notify_step +50");
					// 추천 알림 주기
					int yn = notifSettingService.check_notif_setting(board_mf_no, "recommend");
					if (yn == 1) {
						log.info("알림이 가야하는데");
						notificationService.add_notification(user.getMf_no(), board_mf_no, boardNo, 4);
					}
				}
			}
			return "recommend";
		}

	}
}