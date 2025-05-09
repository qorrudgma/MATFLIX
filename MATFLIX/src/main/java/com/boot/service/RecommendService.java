package com.boot.service;

import com.boot.dto.RecommendDTO;

public interface RecommendService {
	public void recommend(RecommendDTO recomemdDTO);

	public int check_recommend(RecommendDTO recomemdDTO);

	public void delete_recommend(RecommendDTO recomemdDTO);

	public void delete_board(int boardNo);
}