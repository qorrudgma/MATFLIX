package com.boot.service;

import org.springframework.stereotype.Service;

import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipeWriteDTO;

@Service
public class RecipeServiceImpl implements RecipeService {

	@Override
	public void save_recipe(RecipeWriteDTO dto) {
		RecipeDTO RDTO = new RecipeDTO();
		RDTO.setMf_no(dto.getMf_no());
		RDTO.setTitle(dto.getTitle());
		RDTO.setIntro(dto.getIntro());
		RDTO.setServings(dto.getServings());
		RDTO.setCook_time(dto.getCook_time());
		RDTO.setDifficulty(dto.getDifficulty());
		RDTO.setCategory(dto.getCategory());
		RDTO.setTip(dto.getTip());

	}
}