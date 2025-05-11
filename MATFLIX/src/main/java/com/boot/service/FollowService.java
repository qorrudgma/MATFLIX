package com.boot.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface FollowService {
	// 팔로우
	public void add_follow(@Param("following_id") String following_id, @Param("follower_id") String follower_id,
			@Param("follower_email") String follower_email);

	public List<String> follower_list(int following_id);
}