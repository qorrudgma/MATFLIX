package com.boot.service;

import com.boot.dto.TeamDTO;

public interface KakaoUserService {
	void register(TeamDTO dto);

	TeamDTO findById(String mf_id);
}
