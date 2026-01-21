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

	private int follower_count;
	private int following_count;
	private int recipe_count;
}
