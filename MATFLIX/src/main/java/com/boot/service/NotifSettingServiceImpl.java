package com.boot.service;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.NotifSettingDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NotifSettingServiceImpl implements NotifSettingService {

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void add_notif_setting(@Param("mf_no") int mf_no) {
		log.info("!@#$ add_notif_setting 도착 => " + mf_no);
		NotifSettingDAO dao = sqlSession.getMapper(NotifSettingDAO.class);
		dao.add_notif_setting(mf_no);
	}

	@Override
	public void update_notif_setting(int mf_no, String notif_type, int yn) {
		log.info("update_notif_setting 도착");
		log.info("mf_no => " + mf_no);
		log.info("notif_type => " + notif_type);
		log.info("yn => " + yn);
		NotifSettingDAO dao = sqlSession.getMapper(NotifSettingDAO.class);
		dao.update_notif_setting(mf_no, notif_type, yn);
	}

	@Override
	public void delete_notif_setting(int mf_no) {
		log.info("delete_notif_setting 도착 => " + mf_no);
		NotifSettingDAO dao = sqlSession.getMapper(NotifSettingDAO.class);
		dao.delete_notif_setting(mf_no);
	}

	@Override
	public int check_notif_setting(int mf_no, String notif_type) {
		log.info("check_notif_setting 도착");
		NotifSettingDAO dao = sqlSession.getMapper(NotifSettingDAO.class);
		int yn = dao.check_notif_setting(mf_no, notif_type);
		return yn;
	}
}