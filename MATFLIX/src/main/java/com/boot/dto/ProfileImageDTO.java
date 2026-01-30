package com.boot.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProfileImageDTO {
	private int image_no;
	private int mf_no;
	private String profile_image_path;
	private MultipartFile image_file;
}