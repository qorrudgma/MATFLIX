package com.boot.service;

import com.boot.dto.RecipeWriteDTO;

public interface RecipeFileStorageService {
	public void save_image(int recipe_id, RecipeWriteDTO dto);
}