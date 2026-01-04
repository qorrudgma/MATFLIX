package com.boot.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeUploadDTO {
	private int recipe_id;
	private String image_type;
	private int step_no;
	private MultipartFile file;
}