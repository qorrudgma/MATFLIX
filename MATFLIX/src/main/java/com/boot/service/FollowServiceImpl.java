package com.boot.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.FollowDAO;
import com.boot.dao.NotifSettingDAO;
import com.boot.dao.NotificationDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("FollowService")
public class FollowServiceImpl implements FollowService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_follow(int following_id, int follower_id, String follower_email) {
		// following_id => mf_no
		log.info("FollowServiceImpl 테이블에 넣으러 옴");
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		NotifSettingDAO NSdao = sqlSession.getMapper(NotifSettingDAO.class);
		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
		log.info("!@#$" + following_id + "!@#" + follower_id + "!@#" + follower_email);
		dao.add_follow(following_id, follower_id, follower_email);
		log.info("여기는 도착?");
		int result = NSdao.check_notif_setting(following_id, "follow");
		log.info("!@#$" + result);
		if (result == 1) {
			log.info("여기는 도착?2");
			Ndao.add_notification(follower_id, following_id, 0, 3);
		}
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
	public List<Integer> user_follower_list(int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<Integer> user_follower_list = dao.user_follower_list(follower_id);
		return user_follower_list;
	}

	@Override
	public int check_follow(int follower_id, int following_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		int check_follow = dao.check_follow(follower_id, following_id);

		return check_follow;
	}

	@Override
	public void delete_follow(int following_id, int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.delete_follow(following_id, follower_id);
	}

	@Override
	public void mf_delete_follow(int mf_no) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		dao.mf_delete_follow(mf_no);
	}

	@Override
	public List<Integer> follower_id_list(int following_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<Integer> follower_id_list = dao.follower_id_list(following_id);
		return follower_id_list;
	}

	// 유저 랭킹
	@Override
	public List<Map<String, Object>> user_rank() {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		List<Map<String, Object>> user_rank = dao.user_rank();

		return user_rank;
	}

	@Override
	public int user_follow_count(int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		int user_follow_count = dao.user_follow_count(follower_id);
		return user_follow_count;
	}

	@Override
	public int user_follower_count(int follower_id) {
		FollowDAO dao = sqlSession.getMapper(FollowDAO.class);
		int user_follower_count = dao.user_follower_count(follower_id);
		return user_follower_count;
	}
}