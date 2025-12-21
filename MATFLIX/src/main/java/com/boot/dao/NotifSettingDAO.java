package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface NotifSettingDAO {
	// 알림 데이터 넣기
	public void add_notif_setting(@Param("mf_no") int mf_no);
}