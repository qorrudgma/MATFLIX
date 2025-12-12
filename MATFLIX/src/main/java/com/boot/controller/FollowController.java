package com.boot.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.service.FollowService;
import com.boot.service.SseService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class FollowController {

	@Autowired
	private FollowService followService;
	@Autowired
	private final SseService sseService = new SseService();

	// 팔로우 하기
	@RequestMapping("/add_follow")
	@ResponseBody
	public void add_follow(@RequestParam("following_id") int following_id, @RequestParam("follower_id") int follower_id,
			@RequestParam("follower_email") String follower_email, HttpServletRequest request) {
//		log.info("add_follow()");
//		log.info("following_id => " + following_id);
//		log.info("follower_id => " + follower_id);
//		log.info("follower_email => " + follower_email);
		followService.add_follow(following_id, follower_id, follower_email);
		log.info("테이블에 넣음");

		sseService.send(following_id, "팔로우함");

		HttpSession session = request.getSession();

		List<Integer> user_follow_list = followService.user_follow_list(follower_id);
		session.removeAttribute("user_follow_list");
		if (user_follow_list != null) {
			session.setAttribute("user_follow_list", user_follow_list);
			log.info("@# session user_follow_list => " + session.getAttribute("user_follow_list"));
		}
	}

	// 팔로우 취소 하기
	@RequestMapping("/delete_follow")
	@ResponseBody
	public void delete_follow(@RequestParam("following_id") int following_id,
			@RequestParam("follower_id") int follower_id, HttpServletRequest request) {
		log.info("delete_follow()");
		followService.delete_follow(following_id, follower_id);

		HttpSession session = request.getSession();

		List<Integer> user_follow_list = followService.user_follow_list(follower_id);
		session.removeAttribute("user_follow_list");
		if (user_follow_list != null) {
			session.setAttribute("user_follow_list", user_follow_list);
			log.info("@# session user_follow_list => " + session.getAttribute("user_follow_list"));
		}
	}
}