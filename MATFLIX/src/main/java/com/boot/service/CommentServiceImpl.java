package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardDAO;
import com.boot.dao.CommentDAO;
import com.boot.dto.CommentDTO;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service("CommentService")
public class CommentServiceImpl implements CommentService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void save(HashMap<String, String> param) {
		log.info("save => " + param);
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.save(param);
		BoardDAO Bdao = sqlSession.getMapper(BoardDAO.class);
		Bdao.add_comment_count(Integer.parseInt(param.get("boardNo")));
	}

	@Override
	public void save_comment(CommentDTO commentDTO) {
		log.info("save_comment => " + commentDTO);
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.save_comment(commentDTO);
		BoardDAO Bdao = sqlSession.getMapper(BoardDAO.class);
		Bdao.add_comment_count(commentDTO.getBoardNo());
	}

	@Override
	public ArrayList<CommentDTO> findAll(HashMap<String, String> param) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		ArrayList<CommentDTO> list = dao.findAll(param);
		log.info("댓글 리스트들 => " + list);
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

	@Override
	public void add_comment_count(int commentNo) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.add_comment_count(commentNo);
	}

	@Override
	public void minus_comment_count(int commentNo) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		dao.minus_comment_count(commentNo);
	}

	@Override
	public List<CommentDTO> recommended(int boardNo, int mf_no) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		List<CommentDTO> list = dao.recommended(boardNo, mf_no);
		return list;
	}

	@Override
	public int recommend_count(int commentNo) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		int recommend_count = dao.recommend_count(commentNo);
		return recommend_count;
	}

	@Override
	public int recommend_notify_step(int commentNo) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		int recommend_notify_step = dao.recommend_notify_step(commentNo);
		return recommend_notify_step;
	}

	@Override
	public void update_recommend_notify_step(int commentNo) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.update_recommend_notify_step(commentNo);
	}

	@Override
	public int commentNo_boardNo(int commentNo) {
		CommentDAO dao = sqlSession.getMapper(CommentDAO.class);
		int commentNo_boardNo = dao.commentNo_boardNo(commentNo);
		return commentNo_boardNo;
	}
}