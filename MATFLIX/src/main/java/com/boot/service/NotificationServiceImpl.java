package com.boot.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NotificationDAO;
import com.boot.dto.NotificationDTO;

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

	@Override
	public List<NotificationDTO> notification_list(int follower_id) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		List<NotificationDTO> notification_list = dao.notification_list(follower_id);
		return notification_list;
	}
}