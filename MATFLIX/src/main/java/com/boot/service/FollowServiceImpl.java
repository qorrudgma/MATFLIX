package com.boot.service;

import java.util.List;

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
	public void add_follow(String following_id, String follower_id, String follower_email) {
		log.info("테이블에 넣으러 옴");
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.add_follow(following_id, follower_id, follower_email);
	}

	@Override
	public List<String> follower_list(int following_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<String> follower_list = dao.follower_list(following_id);
		return follower_list;
	}
}