package com.boot.service;

import java.util.ArrayList;
import java.util.List;

import com.boot.dto.RecipeAttachDTO;

public interface RecipeUploadService {
	public void insertFile(RecipeAttachDTO filedto);

	public void deleteFiles(List<RecipeAttachDTO> fileList);

	public int getMaxId();

	public RecipeAttachDTO get_upload_by_id(int rc_recipe_id);

//	모든 파일 정보 리스트
	public ArrayList<RecipeAttachDTO> get_upload_all();
}
