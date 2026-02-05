package com.boot.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.AdminUserDTO;
import com.boot.dto.AdminUserSearchDTO;

public interface AdminUserService {
	public List<AdminUserDTO> user_list(AdminUserSearchDTO adminUserSearchDTO);

	public int user_total_count(AdminUserSearchDTO adminUserSearchDTO);

	public void user_status_active(int mf_no);

	public void user_status_banned(int mf_no);

	public void user_status_suspended(int mf_no);

	public void user_status_update(@Param("mf_no") int mf_no, @Param("status") String status);

	public Map<String, Object> getUserListPage(AdminUserSearchDTO ASDTO);
}