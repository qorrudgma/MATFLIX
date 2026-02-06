package com.boot.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NotifSettingDAO;
import com.boot.dao.NotificationDAO;
import com.boot.dto.NotifSettingDTO;
import com.boot.dto.NotificationDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("NotificationService")
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private final SseService sseService = new SseService();

	@Override
	public void add_notification(NotificationDTO notificationDTO) {
		log.info("add_notification() => " + notificationDTO);
		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
		NotifSettingDAO NSdao = sqlSession.getMapper(NotifSettingDAO.class);
		NotifSettingDTO setting = NSdao.mf_no_notif_setting(notificationDTO.getReceiver_id());

		boolean isAllowed = false;

		switch (notificationDTO.getNotif_type()) {

		case "FOLLOW":
			isAllowed = setting.getFollow_yn() == 1;
			break;

		case "CREATE":
			if ("REVIEW".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getRecipe_review_yn() == 1;
			}
			break;

		case "COMMENT":
			if ("BOARD".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getBoard_comment_yn() == 1;
				log.info("Board_comment_yn() => " + setting.getBoard_comment_yn());
				log.info("isAllowed => " + isAllowed);
			} else if ("RECIPE".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getRecipe_comment_yn() == 1;
			} else if ("COMMENT".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getRecomment_yn() == 1;
			}
			break;

		case "LIKE":
			if ("BOARD".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getBoard_reaction_yn() == 1;
			} else if ("RECIPE".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getRecipe_reaction_yn() == 1;
			} else if ("COMMENT".equals(notificationDTO.getTarget_type())) {
				isAllowed = setting.getComment_reaction_yn() == 1;
			}
			break;
		}

		if (isAllowed) {
			log.info("알림 저장");
			Ndao.add_notification(notificationDTO);
			sseService.send(notificationDTO.getReceiver_id());
		}
	}

//	@Override
//	public void add_notification(NotificationDTO notificationDTO) {
//		NotifSettingDAO NSdao = sqlSession.getMapper(NotifSettingDAO.class);
//		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
//		
//		switch (post_id) {
//		case 1:
//			notifType = "follow";
//			break;
//		case 2:
//			notifType = "board";
//			break;
//		case 3:
//			notifType = "comment";
//			break;
//		case 4:
//			notifType = "board_recommend";
//			break;
//		case 5:
//			notifType = "comment_recommend";
//			break;
//		default:
//			log.info("알수 없는 종류의 알림입니다.");
//			return;
//		}
//		
//		int yn = NSdao.check_notif_setting(following_id, notifType);
//		if (yn == 1) {
//			Ndao.add_notification(notificationDTO);
//		}
//	}

	@Override
	public List<NotificationDTO> notification_list_n(int receiver_id) {
		NotificationDAO dao = sqlSession.getMapper(NotificationDAO.class);
		List<NotificationDTO> notification_list_n = dao.notification_list_n(receiver_id);

//		log.info("!@#$" + notification_list_n);
		if (notification_list_n == null) {
			log.info("없음");
			return new ArrayList<>();
		}
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