package com.boot.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.FollowDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("FollowService")
public class FollowServiceImpl implements FollowService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_follow(int following_id, int follower_id, String follower_email) {
		log.info("FollowServiceImpl 테이블에 넣으러 옴");
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.add_follow(following_id, follower_id, follower_email);
		log.info("FollowServiceImpl 테이블에 데이터 넣음");
	}

	@Override
	public List<String> follower_list(int following_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<String> follower_list = dao.follower_list(following_id);
		return follower_list;
	}

	@Override
	public List<Integer> user_follow_list(int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<Integer> user_follow_list = dao.user_follow_list(follower_id);
		return user_follow_list;
	}

	@Override
	public void follow_unfollow(int following_id, int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.follow_unfollow(following_id, follower_id);
	}

	@Override
	public void delete_follow(int following_id, int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.delete_follow(following_id, follower_id);
	}

	@Override
	public List<Integer> follower_id_list(int following_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<Integer> follower_id_list = dao.follower_id_list(following_id);
		return follower_id_list;
	}
}