package com.boot.service;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.boot.dao.AdminDAO;
import com.boot.dto.AdminUserDTO;
import com.boot.dto.AdminUserSearchDTO;
import com.boot.util.TimeUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminUserServiceImpl implements AdminUserService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private SessionRegistry sessionRegistry;

	@Override
	public List<AdminUserDTO> user_list(AdminUserSearchDTO adminUserSearchDTO) {
		AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		List<AdminUserDTO> user_list = dao.user_list(adminUserSearchDTO);
		for (AdminUserDTO c : user_list) {
			c.setDisplay_time_created(TimeUtil.formatDateTimeAll(c.getCreated_at()));
			c.setDisplay_time_last_login(TimeUtil.formatDateTimeAll(c.getLast_login_at()));
		}
		return user_list;
	}

	@Override
	public Map<String, Object> getUserListPage(AdminUserSearchDTO ASDTO) {
		// 유저 리스트
		List<AdminUserDTO> user_list = user_list(ASDTO);
		// 페이징
		int total = user_total_count(ASDTO);
		int page = ASDTO.getPage();
		int page_size = ASDTO.getPageSize();
		int page_block = 10;

		int total_pages = (int) Math.ceil((double) total / page_size);
		int start_page = ((page - 1) / page_block) * page_block + 1;
		int end_page = Math.min(start_page + page_block - 1, total_pages);

		// 접속자
		List<Object> principals = sessionRegistry.getAllPrincipals();
		Set<String> onlineUserIds = new HashSet<>();

		for (Object principal : principals) {
//			log.info("찾은 Principal 객체 타입: " + principal.getClass().getName());
//			log.info("객체 내용: " + principal.toString());
			List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);

			if (!sessions.isEmpty()) {
				if (principal instanceof UserDetails) {
					onlineUserIds.add(((UserDetails) principal).getUsername());
				} else if (principal instanceof com.boot.dto.TeamDTO) {
					onlineUserIds.add(((com.boot.dto.TeamDTO) principal).getMf_id());
				} else {
					onlineUserIds.add(principal.toString());
				}
			}
		}

		log.info("현재 온라인 유저 ID 목록: " + onlineUserIds);

		for (AdminUserDTO u : user_list) {
			u.setOnline(onlineUserIds.contains(u.getMf_id()));
		}

		Map<String, Object> result = new HashMap<>();
		result.put("user_list", user_list);
		result.put("start_page", start_page);
		result.put("end_page", end_page);
		result.put("has_prev", start_page > 1);
		result.put("has_next", end_page < total_pages);
		result.put("total_pages", total_pages);

		return result;
	}

	@Override
	public int user_total_count(AdminUserSearchDTO adminUserSearchDTO) {
		AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		int user_total_count = dao.user_total_count(adminUserSearchDTO);
		return user_total_count;
	}

	@Override
	public void user_status_active(int mf_no) {
		AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		dao.user_status_active(mf_no);
	}

	@Override
	public void user_status_banned(int mf_no) {
		AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		dao.user_status_banned(mf_no);
	}

	@Override
	public void user_status_suspended(int mf_no) {
		AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		dao.user_status_suspended(mf_no);
	}

	@Override
	public void user_status_update(int mf_no, String status) {
		AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		dao.user_status_update(mf_no, status);
	}
}