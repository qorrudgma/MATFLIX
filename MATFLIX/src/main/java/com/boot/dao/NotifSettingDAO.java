package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.NotifSettingDTO;

@Mapper
public interface NotifSettingDAO {
	// 알림 on/off 설정
	public void add_notif_setting(@Param("mf_no") int mf_no);

	// 알림 on/off 수정
	public void update_notif_setting(NotifSettingDTO notifSettingDTO);

	// 알림 on/off 확인
	public int check_notif_setting(@Param("mf_no") int mf_no, @Param("notif_type") String notif_type);

	// 사용자의 모든 알림 on/off 확인
	public NotifSettingDTO mf_no_notif_setting(@Param("mf_no") int mf_no);
}