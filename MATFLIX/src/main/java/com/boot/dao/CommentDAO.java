package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.CommentDTO;

public interface CommentDAO {
	public void save(HashMap<String, String> param);

	public void save_comment(CommentDTO commentDTO);

	public ArrayList<CommentDTO> findAll(HashMap<String, String> param);

	public void boardCommentDelete(HashMap<String, String> param);

	public void userCommentDelete(HashMap<String, String> param);

	public int comment_count(int boardNo);

	public void add_comment_count(int commentNo);

	public void minus_comment_count(int commentNo);

	public List<CommentDTO> recommended(@Param("boardNo") int boardNo, @Param("mf_no") int mf_no);
}