package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.TeamDTO;

@Mapper
public interface TeamDAO {
	public void recruit(HashMap<String, String> param);

	public ArrayList<TeamDTO> list();

	public int login(@Param("mf_id") String id, @Param("mf_pw") String pw);

	public TeamDTO find_list(@Param("mf_id") String mf_id);

	public void update_ok(HashMap<String, String> param);

	public void delete_ok(@Param("mf_id") String id);

	public void nickname(@Param("mf_nickname") String mf_nickname, @Param("mf_id") String mf_id);

	public TeamDTO find_user_by_no(int mf_no);
}