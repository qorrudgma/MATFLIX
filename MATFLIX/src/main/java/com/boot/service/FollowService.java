package com.boot.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface FollowService {
	// 팔로우
	public void add_follow(@Param("following_id") int following_id, @Param("follower_id") int follower_id,
			@Param("follower_email") String follower_email);

	public List<String> follower_list(int following_id);

	public List<Integer> user_follow_list(int follower_id);

	public List<Integer> follower_id_list(int following_id);

	public void follow_unfollow(@Param("following_id") int following_id, @Param("follower_id") int follower_id);

	public void delete_follow(@Param("following_id") int following_id, @Param("follower_id") int follower_id);
}