package com.boot.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NotifSettingDAO;
import com.boot.dao.NotificationDAO;
import com.boot.dto.NotificationDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("NotificationService")
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_notification(int following_id, int follower_id, int boardNo, int post_id) {
		// following_id => 알림 받는사람, post_id => 게시글(1),댓글(2),팔로우(3),레시피(4)
		NotifSettingDAO NSdao = sqlSession.getMapper(NotifSettingDAO.class);
		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
		String notifType = null;

		switch (post_id) {
		case 1:
			notifType = "board";
			break;
		case 2:
			notifType = "comment";
			break;
		case 3:
			notifType = "follow";
			break;
		case 4:
			notifType = "recipe";
			break;
		default:
			log.info("알수 없는 종류의 알림입니다.");
			return;
		}

		int yn = NSdao.check_notif_setting(following_id, notifType);
		if (yn == 1) {
			Ndao.add_notification(following_id, follower_id, boardNo, post_id);
		}
	}

	@Override
	public List<NotificationDTO> notification_list_n(int follower_id) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		List<NotificationDTO> notification_list_n = dao.notification_list_n(follower_id);

		log.info("!@#$" + notification_list_n);
		return notification_list_n;
	}

	@Override
	public void is_read_true(int notifications_id) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		dao.is_read_true(notifications_id);

	}

	@Override
	public int notification_count(int notifications_id) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		int notification_count = dao.notification_count(notifications_id);
		return notification_count;
	}

	@Override
	public void delete_notification(int mf_no) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		dao.delete_notification(mf_no);
	}
}