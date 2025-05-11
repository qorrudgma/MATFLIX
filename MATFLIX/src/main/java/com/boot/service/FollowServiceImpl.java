package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.FollowDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FollowServiceImpl implements FollowService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_follow(String following_id, String follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.add_follow(following_id, follower_id);
	}
}