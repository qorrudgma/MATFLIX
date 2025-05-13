package com.boot.service;

import com.boot.dto.FavoriteDTO;

import java.util.List;

public interface FavoriteService {
    // 즐겨찾기 추가
    FavoriteDTO addRecipeToFavorites(int mfNo, int recipeId) throws Exception;

    // 즐겨찾기 삭제 (PK 기준, 본인 확인 로직 추가 가능)
    boolean removeRecipeFromFavoritesById(long favoriteId, int mfNo) throws Exception;

    // 즐겨찾기 삭제 (사용자 번호와 레시피 ID 기준)
    boolean removeRecipeFromFavorites(int mfNo, int recipeId) throws Exception;

    // 특정 사용자의 즐겨찾기 레시피 목록 조회
    List<FavoriteDTO> getUserFavoriteRecipes(int mfNo) throws Exception;

    // 특정 레시피가 사용자의 즐겨찾기인지 확인
    boolean isRecipeFavoritedByUser(int mfNo, int recipeId) throws Exception;
}