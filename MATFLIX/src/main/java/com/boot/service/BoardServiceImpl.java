package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dao.BoardDAO;
import com.boot.dto.BoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("BoardService")
public class BoardServiceImpl implements BoardService{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardDTO> list() {
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		ArrayList<BoardDTO> list = dao.list();
		return list;
	}

	@Override
//	public void write(HashMap<String, String> param) {
//	파일업로드는 파라미터를 DTO 사용
	public void write(BoardDTO boardDTO) {
		log.info("@# BoardServiceImpl boardDTO=>"+boardDTO);
		
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO adao=sqlSession.getMapper(BoardAttachDAO.class);
		
//		dao.write(param);
		dao.write(boardDTO);
		
//		첨부파일 있는지 체크
		log.info("@# getAttachList=>"+boardDTO.getAttachList());
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
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		BoardDTO dto = dao.contentView(param);
		
		return dto;
	}

	@Override
	public void modify(HashMap<String, String> param) {
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		log.info("@# delete param=>"+param);
		
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO attachDAO=sqlSession.getMapper(BoardAttachDAO.class);
		
//		게시글 삭제
		dao.delete(param);
//		댓글 삭제
		attachDAO.deleteFile(param.get("boardNo"));
	}

}













