package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NoticeBoardDAO;
import com.boot.dto.NoticeBoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("NoticeBoardService")
public class NoticeBoardServiceImpl implements NoticeBoardService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<NoticeBoardDTO> list() {
		NoticeBoardDAO dao = sqlSession.getMapper(NoticeBoardDAO.class);
		ArrayList<NoticeBoardDTO> list = dao.list();
		return list;
	}

	@Override
//	public void write(HashMap<String, String> param) {
//	파일업로드는 파라미터를 DTO 사용
	public void write(NoticeBoardDTO boardDTO) {
		log.info("@# BoardServiceImpl boardDTO=>" + boardDTO);

		NoticeBoardDAO dao = sqlSession.getMapper(NoticeBoardDAO.class);

		dao.write(boardDTO);
	}

	@Override
	public NoticeBoardDTO contentView(HashMap<String, String> param) {
		NoticeBoardDAO dao = sqlSession.getMapper(NoticeBoardDAO.class);
		NoticeBoardDTO dto = dao.contentView(param);

		return dto;
	}

	@Override
	public void modify(HashMap<String, String> param) {
		NoticeBoardDAO dao = sqlSession.getMapper(NoticeBoardDAO.class);
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		log.info("@# delete param=>" + param);

		NoticeBoardDAO dao = sqlSession.getMapper(NoticeBoardDAO.class);

		dao.delete(param);
	}

}
