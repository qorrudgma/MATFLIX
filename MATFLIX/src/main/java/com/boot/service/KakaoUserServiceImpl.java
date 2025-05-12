package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.KakaoUserDAO;
import com.boot.dto.TeamDTO;

@Service
public class KakaoUserServiceImpl implements KakaoUserService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void register(TeamDTO dto) {
		sqlSession.getMapper(KakaoUserDAO.class).register(dto);
	}

	@Override
	public TeamDTO findById(String mf_id) {
		return sqlSession.getMapper(KakaoUserDAO.class).findById(mf_id);
	}
}
