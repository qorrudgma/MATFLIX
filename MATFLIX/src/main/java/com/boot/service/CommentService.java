package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.CommentDTO;

public interface CommentService {
	public void save(HashMap<String, String> param);

	public ArrayList<CommentDTO> findAll(HashMap<String, String> param);

	public void boardCommentDelete(HashMap<String, String> param);

	public void userCommentDelete(HashMap<String, String> param);

	public int comment_count(int boardNo);
}