package com.boot.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface FollowDAO {
	// 팔로우
	public void add_follow(@Param("following_id") int following_id, @Param("follower_id") int follower_id,
			@Param("follower_email") String follower_email);

	// 팔로우 한 사람들 메일
	public List<String> follower_list(int following_id);

	// 본인의 팔로우 리스트
	public List<Integer> user_follow_list(int follower_id);

	// 본인의 팔로우 리스트
	public List<Integer> user_follower_list(int follower_id);

	// 본인의 팔로우 리스트
	public int user_follow_count(int follower_id);

	// 본인의 팔로우 리스트
	public int user_follower_count(int follower_id);

	// 팔로우 한 사람들 아이디
	public List<Integer> follower_id_list(int following_id);

	// 팔로우 유/무
	public int check_follow(@Param("follower_id") int follower_id, @Param("following_id") int following_id);

	// 팔로우 취소
	public void delete_follow(@Param("following_id") int following_id, @Param("follower_id") int follower_id);

	// 탈퇴로 인한 팔로우 정리
	public void mf_delete_follow(int mf_no);

	// 유저 랭킹
	public List<Map<String, Object>> user_rank();
}