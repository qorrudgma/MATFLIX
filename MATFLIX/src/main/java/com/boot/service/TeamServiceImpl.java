package com.boot.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.FollowDAO;
import com.boot.dao.NotifSettingDAO;
import com.boot.dao.NotificationDAO;
import com.boot.dao.TeamDAO;
import com.boot.dto.TeamDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TeamServiceImpl implements TeamService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private NotifSettingService notifSettingService;

	// 회원가입
	@Override
	public void recruit(HashMap<String, String> param) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.recruit(param);
		System.out.println(param);
		System.out.println(param.get("mf_id"));
		// 기존에 HashMap<String, String> param 만들어서 오프젝트로 뽑아서 스트링으로 만들고 다시 인트로 만드는 과정 필요
		// 안하면 코드 다른것들 싹 고쳐야함
		Object Omf_no = param.get("mf_no");
//		System.out.println(Omf_no);
		int mf_no = Integer.parseInt(Omf_no.toString());

		log.info("알림 on/off 시작");
		notifSettingService.add_notif_setting(mf_no);

	}

	// 회원 리스트 all
	@Override
	public ArrayList<TeamDTO> list() {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		ArrayList<TeamDTO> list = dao.list();
		return list;
	}

	// 회원 찾기
	@Override
	public TeamDTO find_list(@Param("mf_id") String mf_id) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		TeamDTO find_list = dao.find_list(mf_id);
		return find_list;
	}

	// 로그인
	@Override
	public int login(@Param("mf_id") String mf_id, @Param("mf_pw") String mf_pw) {
		int re = -1;

		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		re = dao.login(mf_id, mf_pw);

		return re;
	}

	@Override
	public void update_ok(HashMap<String, String> param) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		System.out.println("@# update ok =>" + param);
		dao.update_ok(param);
		log.info("@# update_ok2!!!!!!!!");
	}

	@Override
	public void delete_ok(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		NotifSettingDAO NSdao = sqlSession.getMapper(NotifSettingDAO.class);
		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
		FollowDAO Fdao = sqlSession.getMapper(FollowDAO.class);
		// 알림 설정 삭제
		NSdao.delete_notif_setting(mf_no);
		// 알림 삭제
		Ndao.delete_notification(mf_no);
		// 팔로우 정리
		Fdao.mf_delete_follow(mf_no);
		// 회원삭제
		dao.delete_ok(mf_no);
	}

	@Override
	public LocalDateTime nickname_updatetime_check(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		return dao.nickname_updatetime_check(mf_no);
	}

	@Override
	public void nickname_updatetime_update(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.nickname_updatetime_update(mf_no);
	}

	@Override
	public int nickname_check(String mf_nickname) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		return dao.nickname_check(mf_nickname);
	}

	@Override
	public void nickname(@Param("mf_nickname") String mf_nickname, @Param("mf_id") String mf_id) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.nickname(mf_nickname, mf_id);
	}

	@Override
	public TeamDTO find_user_by_no(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		TeamDTO dto = dao.find_user_by_no(mf_no);
		return dto;
	}

	@Override
	public Map<String, Object> rank_user(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		Map<String, Object> rank_user = dao.rank_user(mf_no);
		return rank_user;
	}
}