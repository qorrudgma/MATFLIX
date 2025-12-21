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
		log.info("!@#$ 1234");
		dao.add_notif_setting(mf_no);
		log.info("!@#$");
	}
}