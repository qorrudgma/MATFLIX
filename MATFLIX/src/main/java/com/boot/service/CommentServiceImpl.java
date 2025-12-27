package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardDAO;
import com.boot.dao.CommentDAO;
import com.boot.dto.CommentDTO;

@Service("CommentService")
public class CommentServiceImpl implements CommentService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void save(HashMap<String, String> param) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.save(param);
		BoardDAO Bdao = sqlSession.getMapper(BoardDAO.class);
		Bdao.add_comment_count(Integer.parseInt(param.get("boardNo")));
	}

	@Override
	public ArrayList<CommentDTO> findAll(HashMap<String, String> param) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		ArrayList<CommentDTO> list = dao.findAll(param);
		return list;
	}

	@Override
	public void boardCommentDelete(HashMap<String, String> param) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.boardCommentDelete(param);
	}

	@Override
	public void userCommentDelete(HashMap<String, String> param) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.userCommentDelete(param);
	}

	@Override
	public int comment_count(int boardNo) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		int count = dao.comment_count(boardNo);
		return count;
	}
}