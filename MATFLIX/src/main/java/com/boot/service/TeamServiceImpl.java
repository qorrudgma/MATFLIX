package com.boot.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.boot.dao.FollowDAO;
import com.boot.dao.NotificationDAO;
import com.boot.dao.TeamDAO;
import com.boot.dto.ProfileDTO;
import com.boot.dto.TeamDTO;
import com.boot.dto.WithdrawDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TeamServiceImpl implements TeamService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private NotifSettingService notifSettingService;

	@Autowired
	private PasswordEncoder passwordEncoder;

	// 회원가입
	@Override
	public void recruit(HashMap<String, String> param) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		System.out.println(param);
		System.out.println(param.get("mf_id"));

		// 비번 꺼내기
		String raw_pw = param.get("mf_pw");
		// 해시 생성
		String encoded_pw = passwordEncoder.encode(raw_pw);
		// param에 다시 넣기
		param.put("mf_pw", encoded_pw);
		log.info(encoded_pw);
		dao.recruit(param);

		Object Omf_no = param.get("mf_no");
//		System.out.println(Omf_no);
		int mf_no = Integer.parseInt(Omf_no.toString());
		recruit_profile_image(mf_no);
		log.info("알림 on/off 시작");
		notifSettingService.add_notif_setting(mf_no);

	}

	@Override
	public void recruit_profile_image(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.recruit_profile_image(mf_no);
	}

	@Override
	public void modify_profile_image(int mf_no, String image_path) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.modify_profile_image(mf_no, image_path);
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

	@Override
	public int find_id(@Param("mf_id") String mf_id) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		int find_id = dao.find_id(mf_id);
		return find_id;
	}

	// 로그인
	@Override
	public TeamDTO login(@Param("mf_id") String mf_id, @Param("mf_pw") String mf_pw) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		TeamDTO teamDTO = dao.find_list(mf_id);

		if (teamDTO == null) {
			return null;
		}
		if (passwordEncoder.matches(mf_pw, teamDTO.getMf_pw())) {
			return teamDTO;
		}

		return null;
	}

	@Override
	public void update_ok(HashMap<String, String> param) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		// 비번 꺼내기
		String raw_pw = param.get("mf_pw");
		// 해시 생성
		String encoded_pw = passwordEncoder.encode(raw_pw);
		// param에 다시 넣기
		param.put("mf_pw", encoded_pw);
		dao.update_ok(param);
		log.info("@# update_ok2!!!!!!!!");
	}

	@Override
	public void delete_ok(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
		FollowDAO Fdao = sqlSession.getMapper(FollowDAO.class);
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

	@Override
	public ProfileDTO profile(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		ProfileDTO PDTO = dao.profile(mf_no);
		return PDTO;
	}

	@Override
	public String pw_check(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		String pw_check = dao.pw_check(mf_no);
		return pw_check;
	}

	@Override
	public void member_withdraw_reason(WithdrawDTO withdrawDTO) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.member_withdraw_reason(withdrawDTO);
	}

	@Override
	public void last_login_at(int mf_no) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		dao.last_login_at(mf_no);
	}
}