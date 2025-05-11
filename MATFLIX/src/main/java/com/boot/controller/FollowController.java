package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.service.FollowService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class FollowController {

	@Autowired
	private FollowService followService;

	// 팔로우 하기
	@RequestMapping("/add_follow")
	@ResponseBody
	public void add_follow(@RequestParam("following_id") String following_id,
			@RequestParam("follower_id") String follower_id, @RequestParam("follower_email") String follower_email) {
		log.info("add_follow()");
		log.info("following_id => " + following_id);
		log.info("follower_id => " + follower_id);
		log.info("follower_email => " + follower_email);
		followService.add_follow(following_id, follower_id, follower_email);
	}

	// 팔로우 취소 하기
	@RequestMapping("/delete_follow")
	@ResponseBody
	public void delete_follow(@RequestParam("following_id") int following_id,
			@RequestParam("follower_id") int follower_id) {
		log.info("delete_follow()");
		followService.delete_follow(following_id, follower_id);
	}
}