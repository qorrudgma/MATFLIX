package com.boot.dao;

import java.util.ArrayList;

import com.boot.dto.RecipeAttachDTO;

public interface RecipeAttachDAO {
//	파일업로드는 파라미터를 DTO 사용
	public void deleteFile(String rc_recipe_id);

	public void insertFile(RecipeAttachDTO filedto);

	public int getMaxId();

	public RecipeAttachDTO get_upload_by_id(int rc_recipe_id);

//	모든 파일 정보 리스트
	public ArrayList<RecipeAttachDTO> get_upload_all();

}
