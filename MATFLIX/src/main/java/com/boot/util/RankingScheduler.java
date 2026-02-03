package com.boot.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.boot.service.FollowService;

@Component
public class RankingScheduler {
	@Autowired
	private FollowService followService;

	/**
	 * 매 1시간마다 실행
	 */
	@Scheduled(cron = "0 0 */1 * * *")
	public void run_user_ranking_job() {
		followService.update_user_ranking();
		System.out.println("[RANKING] user_ranking 테이블 갱신 완료");
	}
}