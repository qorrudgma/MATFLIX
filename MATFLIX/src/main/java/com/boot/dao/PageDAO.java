package com.boot.dao;

import java.util.ArrayList;

import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.dto.Criteria;

public interface PageDAO {
	public ArrayList<BoardDTO> listWithPaging(Criteria cri);

	public int getTotalCount(Criteria cri);

	public ArrayList<CommentDTO> listWithPagingComment(Criteria cri);

	public int getTotalCommentCount(Criteria cri);
}