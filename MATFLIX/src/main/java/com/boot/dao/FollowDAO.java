package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface FollowDAO {
	// 팔로우
	public void add_follow(@Param("following_id") String following_id, @Param("follower_id") String follower_id);
}