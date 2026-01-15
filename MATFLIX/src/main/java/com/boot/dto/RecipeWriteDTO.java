package com.boot.dto;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeWriteDTO {
	private int recipe_id;
	private int mf_no;
	private String title;
	private String intro;
	private int servings;
	private int cook_time;
	private String difficulty;
	private String category;
	private String tip;
	private int star;
	private LocalDateTime created_at;
	private LocalDateTime updated_at;

	// 화면용
	private String display_updated_at;

	// 재료
	private int[] ingredient_id;
	private String[] ingredient_name;
	private String[] ingredient_amount;

	// 순서
	private int[] step_id;
	private int[] step_no;
	private String[] step_content;

	// 태그
	private String[] tags;

	// 이미지
	private int[] image_id;
	private String[] image_type;
	private String[] image_path;
	private MultipartFile[] image_file;

	// 수정
	private String[] delete_image_path;
	private int[] image_step_no;
}