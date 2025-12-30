package com.boot.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.dto.Criteria;

public interface PageDAO {
	public ArrayList<BoardDTO> listWithPaging(@Param("cri") Criteria cri);

	public ArrayList<BoardDTO> f_listWithPaging(@Param("cri") Criteria cri, @Param("mf_no") int mf_no);

	public int getTotalCount(@Param("cri") Criteria cri);

	public int f_getTotalCount(@Param("cri") Criteria cri, @Param("mf_no") int mf_no);

	public ArrayList<CommentDTO> listWithPagingComment(@Param("cri") Criteria cri);

	public int getTotalCommentCount(@Param("cri") Criteria cri);
}