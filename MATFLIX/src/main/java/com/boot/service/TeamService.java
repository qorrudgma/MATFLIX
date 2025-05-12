package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.TeamDTO;

public interface TeamService {
	// 회원가입
	public void recruit(HashMap<String, String> param);

	// 리스트 불러오기
	public ArrayList<TeamDTO> list();

	// 로그인 로직처리
	public int login(@Param("mf_id") String mfId, @Param("mf_pw") String mfPw);

	// id값으로 회원정보 부르기
	public TeamDTO find_list(String mf_id);

	// update 로직처리
	public void update_ok(HashMap<String, String> param);

	// delete 로직처리
	public void delete_ok(@Param("mf_id") String id);

	// nickname
	public void nickname(@Param("mf_nickname") String mf_nickname, @Param("mf_id") String mf_id);

	// 멤버넘버로 정보 추출
	public TeamDTO find_user_by_no(int mf_no);

	// 랭킹에있는 유저 정보 가져오기
	public Map<String, Object> rank_user(int mf_no);
}