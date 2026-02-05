package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.AdminUserDTO;
import com.boot.dto.AdminUserSearchDTO;

@Mapper
public interface AdminDAO {
	public List<AdminUserDTO> user_list(AdminUserSearchDTO adminUserSearchDTO);

	public int user_total_count(AdminUserSearchDTO adminUserSearchDTO);

	public void user_status_active(int mf_no);

	public void user_status_banned(int mf_no);

	public void user_status_suspended(int mf_no);

	public void user_status_update(@Param("mf_no") int mf_no, @Param("status") String status);
}