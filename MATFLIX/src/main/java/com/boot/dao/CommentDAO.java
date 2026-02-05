package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.CommentDTO;

public interface CommentDAO {
	public void save(HashMap<String, String> param);

	public void save_comment(CommentDTO commentDTO);

	public void modify_comment(@Param("commentNo") int commentNo, @Param("commentContent") String commentContent);

	public ArrayList<CommentDTO> findAll(HashMap<String, String> param);

	public void boardCommentDelete(HashMap<String, String> param);

	public void userCommentDelete(HashMap<String, String> param);

	public int comment_count(int boardNo);

	public void add_comment_count(int commentNo);

	public void minus_comment_count(int commentNo);

	public List<CommentDTO> recommended(@Param("boardNo") int boardNo, @Param("mf_no") int mf_no);

	// 추천 수
	public int recommend_count(int commentNo);

	// 추천 알림 가져오기
	public int recommend_notify_step(int commentNo);

	// 추천 알림 업데이트
	public void update_recommend_notify_step(int commentNo);

	// 댓글로 게시글 위치 가져오기
	public int commentNo_boardNo(int commentNo);
}