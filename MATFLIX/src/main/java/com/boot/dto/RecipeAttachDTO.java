package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecipeAttachDTO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean image;
	private int rc_recipe_id;
}
