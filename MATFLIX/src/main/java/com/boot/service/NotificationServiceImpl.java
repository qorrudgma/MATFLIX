package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NotificationDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("NotificationService")
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_notification(int following_id, int follower_id, int post_id) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		dao.add_notification(following_id, follower_id, post_id);
	}
}