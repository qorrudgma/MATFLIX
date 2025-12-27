package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.boot.dto.BoardDTO;

public interface BoardDAO {
	public ArrayList<BoardDTO> list();

	public void write(BoardDTO boardDTO);

	public BoardDTO contentView(HashMap<String, String> param);

	// 팔로우 게시글들
	public List<BoardDTO> follow_board_list(int mf_no);

	public void modify(HashMap<String, String> param);

	public void delete(HashMap<String, String> param);

	public void hitUp(HashMap<String, String> param);

	public void hitDown(int boardNo);

	// 추천수 가져오기
	public int board_recommend(int boardNo);

	// 추천수 플러스
	public void add_board_recommend(int boardNo);

	// 추천수 마이너스
	public void minus_board_recommend(int boardNo);

	// 추천 알림 가져오기
	public int recommend_notify_step(int boardNo);

	// 추천 알림 업데이트
	public void update_recommend_notify_step(int boardNo);

	// 유저가 작성한 게시글
	public List<Map<String, Object>> profile_board_list(int mf_no);

	// 댓글 수 +
	public void add_comment_count(int boardNo);
}
