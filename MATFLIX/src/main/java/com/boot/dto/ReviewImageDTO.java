package com.boot.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewImageDTO {
	private int image_id;
	private int review_id;
	private String image_path;
	private MultipartFile image_file;

	// 화면
	private int rating;
}