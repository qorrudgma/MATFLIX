package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.TeamDTO;

@Mapper
public interface KakaoUserDAO {
	void register(TeamDTO dto);

	TeamDTO findById(String mf_id);
}
