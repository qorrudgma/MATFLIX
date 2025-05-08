package com.boot.dao;

import java.util.List;

import com.boot.dto.BoardAttachDTO;

public interface BoardAttachDAO {
	public void insertFile(BoardAttachDTO vo);

	public List<BoardAttachDTO> getFileList(int boardNo);

	public void deleteFile(String boardNo);
}