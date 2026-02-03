package com.boot.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.RankDTO;

public interface FollowService {
	// 팔로우
	public void add_follow(@Param("following_id") int following_id, @Param("follower_id") int follower_id,
			@Param("follower_email") String follower_email);

	public List<String> follower_list(int following_id);

	public List<Integer> user_follow_list(int follower_id);

	public List<Integer> user_follower_list(int follower_id);

	// 본인의 팔로우 리스트
	public int user_follow_count(int follower_id);

	// 본인의 팔로우 리스트
	public int user_follower_count(int follower_id);

	public List<Integer> follower_id_list(int following_id);

	public int check_follow(@Param("follower_id") int follower_id, @Param("following_id") int following_id);

	public void delete_follow(@Param("following_id") int following_id, @Param("follower_id") int follower_id);

	// 탈퇴로 인한 팔로우 정리
	public void mf_delete_follow(int mf_no);

	// 유저 랭킹
	public void update_user_ranking();

	public List<RankDTO> select_user_ranking();
}