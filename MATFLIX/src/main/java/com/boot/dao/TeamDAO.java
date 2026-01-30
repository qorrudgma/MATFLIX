package com.boot.dao;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.ProfileDTO;
import com.boot.dto.TeamDTO;

@Mapper
public interface TeamDAO {
	public void recruit(HashMap<String, String> param);

	public void recruit_profile_image(int mf_no);

	public void modify_profile_image(@Param("mf_no") int mf_no, @Param("image_path") String image_path);

	public ArrayList<TeamDTO> list();

	public int login(@Param("mf_id") String id, @Param("mf_pw") String pw);

	public TeamDTO find_list(@Param("mf_id") String mf_id);

	public ProfileDTO profile(int mf_no);

	public void update_ok(HashMap<String, String> param);

	public void delete_ok(@Param("mf_no") int mf_no);

	public LocalDateTime nickname_updatetime_check(int mf_no);

	public void nickname_updatetime_update(int mf_no);

	public int nickname_check(String mf_nickname);

	public void nickname(@Param("mf_nickname") String mf_nickname, @Param("mf_id") String mf_id);

	public TeamDTO find_user_by_no(int mf_no);

	// 랭킹에있는 유저 정보 가져오기
	public Map<String, Object> rank_user(int mf_no);
}