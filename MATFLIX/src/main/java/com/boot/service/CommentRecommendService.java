package com.boot.service;

import org.apache.ibatis.annotations.Param;

public interface CommentRecommendService {
	public void add_comment_recommend(@Param("commentNo") int commentNo, @Param("mf_no") int mf_no);

	public void minus_comment_recommend(@Param("commentNo") int commentNo, @Param("mf_no") int mf_no);

	public void delete_comment(@Param("commentNo") int commentNo);

	public int comment_yn(@Param("commentNo") int commentNo, @Param("mf_no") int mf_no);

	public void delete_board_comment(@Param("boardNo") int boardNo);
}