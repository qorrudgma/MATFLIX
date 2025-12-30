package com.boot.service;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.PageDAO;
import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.dto.Criteria;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("PageService")
public class PageServiceImpl implements PageService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardDTO> listWithPaging(@Param("cri") Criteria cri) {
		log.info("@# PageServiceImpl listWithPaging");
		log.info("@# cri" + cri);

		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		ArrayList<BoardDTO> list = dao.listWithPaging(cri);

		return list;
	}

	@Override
	public int getTotalCount(@Param("cri") Criteria cri) {
		log.info("@# PageServiceImpl getTotalCount");

		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		int total = dao.getTotalCount(cri);

		return total;
	}

	@Override
	public ArrayList<CommentDTO> listWithPagingComment(@Param("cri") Criteria cri) {
		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		ArrayList<CommentDTO> list = dao.listWithPagingComment(cri);

		return list;
	}

	@Override
	public int getTotalCommentCount(@Param("cri") Criteria cri) {
		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		int total = dao.getTotalCommentCount(cri);

		return total;
	}

	@Override
	public ArrayList<BoardDTO> f_listWithPaging(@Param("cri") Criteria cri, @Param("mf_no") int mf_no) {

		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		ArrayList<BoardDTO> f_list = dao.f_listWithPaging(cri, mf_no);

		return f_list;
	}

	@Override
	public int f_getTotalCount(@Param("cri") Criteria cri, @Param("mf_no") int mf_no) {
		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		int f_total = dao.f_getTotalCount(cri, mf_no);

		return f_total;
	}
}