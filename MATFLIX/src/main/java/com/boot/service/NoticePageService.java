package com.boot.service;

import java.util.ArrayList;

import com.boot.dto.NoticeBoardDTO;
import com.boot.dto.NoticeCriteria;

public interface NoticePageService {
	public ArrayList<NoticeBoardDTO> listWithPaging(NoticeCriteria cri);

	public int totalList(NoticeCriteria cri);
}
