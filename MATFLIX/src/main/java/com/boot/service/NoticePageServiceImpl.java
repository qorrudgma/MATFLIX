package com.boot.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NoticePageDAO;
import com.boot.dto.NoticeBoardDTO;
import com.boot.dto.NoticeCriteria;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("NoticePageService")
public class NoticePageServiceImpl implements NoticePageService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<NoticeBoardDTO> listWithPaging(NoticeCriteria cri) {
		log.info("@# PageServiceImpl listWithPaging");
		log.info("@# cri" + cri);

		NoticePageDAO dao = sqlSession.getMapper(NoticePageDAO.class);
		ArrayList<NoticeBoardDTO> list = dao.listWithPaging(cri);

		return list;
	}

	@Override
	public int totalList(NoticeCriteria cri) {
		log.info("@# PageServiceImpl totalList");
		NoticePageDAO dao = sqlSession.getMapper(NoticePageDAO.class);
		int totalList = dao.totalList(cri);
		return totalList;
	}

}
