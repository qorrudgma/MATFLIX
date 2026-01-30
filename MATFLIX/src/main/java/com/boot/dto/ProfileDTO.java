package com.boot.dto;

import java.sql.Date;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProfileDTO {
	private int mf_no;
	private String mf_id;
	private String mf_pw;
	private String mf_pw_chk;
	private String mf_nickname;
	private String mf_name;
	private String mf_email;
	private String mf_phone;
	private Date mf_birth;
	private String mf_gender;
	private Date mf_regdate;
	private String mf_role;

	private LocalDateTime mf_nickname_updatetime;
	// 프로필 이미지
	private String profile_image_path;
	// 팔로우&팔로잉
	private int follower_count; // 나를 팔로우 하는 사람 수
	private int following_count; // 내가 팔로우 하는 사람 수
	private int recipe_count;
	// 레시피
	private int recipe_id;
	private String title;
	private LocalDateTime created_at;
	private String image_path;

}
