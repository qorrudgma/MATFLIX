package com.boot.dto;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeReviewWriteDTO {
	private int review_id;
	private int recipe_id;
	private int mf_no;
	private Integer rating;
	private int deleted;
	private String content;
	private LocalDateTime created_at;
	private LocalDateTime updated_at;

	// 화면용
	private String display_updated_at;

	// 이미지
	private int image_id;
	private String image_path;
	private MultipartFile image_file;
	private Integer old_rating;
}