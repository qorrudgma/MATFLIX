package com.boot.dao;

import com.boot.dto.RecommendDTO;

public interface RecommendDAO {

	public void recommend(RecommendDTO recomemdDTO);

	public int check_recommend(RecommendDTO recomemdDTO);

	public int total_recommend(int boardNo);

	public void delete_recommend(RecommendDTO recomemdDTO);

	public void delete_board(int boardNo);
}