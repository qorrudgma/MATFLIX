package com.boot.service;

import org.apache.ibatis.annotations.Param;

public interface NotifSettingService {
	public void add_notif_setting(@Param("mf_no") int mf_no);
}