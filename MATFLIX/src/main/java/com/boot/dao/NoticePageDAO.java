package com.boot.dao;

import java.util.ArrayList;

import com.boot.dto.NoticeBoardDTO;
import com.boot.dto.NoticeCriteria;

public interface NoticePageDAO {
//	Criteria 객체를 이용해서 페이징 처리
	public ArrayList<NoticeBoardDTO> listWithPaging(NoticeCriteria cri);

	public int totalList(NoticeCriteria cri);
}
