package com.boot.service;

import org.apache.ibatis.annotations.Param;

public interface EmailService {
	public String sendEmail(String mf_email);

	public void follower_list(@Param("following_name") String following_name,
			@Param("follower_email") String follower_email);
}