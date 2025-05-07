package com.boot.service;

import java.util.List;

import com.boot.dto.BoardAttachDTO;

public interface UploadService {
	public List<BoardAttachDTO> getFileList(int boardNo);
	public void deleteFiles(List<BoardAttachDTO> fileList);
}
