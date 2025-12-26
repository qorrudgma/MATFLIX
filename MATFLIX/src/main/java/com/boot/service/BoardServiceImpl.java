package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dao.BoardDAO;
import com.boot.dto.BoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("BoardService")
public class BoardServiceImpl implements BoardService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardDTO> list() {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		ArrayList<BoardDTO> list = dao.list();
		return list;
	}

	@Override
	public void write(BoardDTO boardDTO) {
		log.info("@# BoardServiceImpl boardDTO=>" + boardDTO);

		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO adao = sqlSession.getMapper(BoardAttachDAO.class);

//		dao.write(param);
		dao.write(boardDTO);

//		첨부파일 있는지 체크
		log.info("@# getAttachList=>" + boardDTO.getAttachList());
		if (boardDTO.getAttachList() == null || boardDTO.getAttachList().size() == 0) {
			log.info("@# null");
			return;
		}

//		첨부파일이 있는 경우 처리
		boardDTO.getAttachList().forEach(attach -> {
			attach.setBoardNo(boardDTO.getBoardNo());
			adao.insertFile(attach);
		});
	}

	@Override
	public BoardDTO contentView(HashMap<String, String> param) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardDTO dto = dao.contentView(param);

		return dto;
	}

	@Override
	public void modify(HashMap<String, String> param) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		log.info("@# delete param=>" + param);

		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO attachDAO = sqlSession.getMapper(BoardAttachDAO.class);

		dao.delete(param);
		attachDAO.deleteFile(param.get("boardNo"));
	}

	@Override
	public void hitUp(HashMap<String, String> param) {
		log.info("@# delete param=>" + param);

		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);

		dao.hitUp(param);
	}

	@Override
	public void hitDown(int boardNo) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);

		dao.hitDown(boardNo);
	}

	@Override
	public List<Map<String, Object>> profile_board_list(int mf_no) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		List<Map<String, Object>> profile_board_list = dao.profile_board_list(mf_no);

		return profile_board_list;
	}

	@Override
	public int board_recommend(int boardNo) {
		log.info("board_recommend 도착");
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		int board_recommend = dao.board_recommend(boardNo);
		return board_recommend;
	}

	@Override
	public int recommend_notify_step(int boardNo) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		int recommend_notify_step = dao.recommend_notify_step(boardNo);
		return recommend_notify_step;
	}

	@Override
	public void add_board_recommend(int boardNo) {
//		log.info("add_board_recommend 도착");
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.add_board_recommend(boardNo);
	}

	@Override
	public void minus_board_recommend(int boardNo) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.minus_board_recommend(boardNo);
	}

	@Override
	public void update_recommend_notify_step(int boardNo) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.update_recommend_notify_step(boardNo);
	}
}