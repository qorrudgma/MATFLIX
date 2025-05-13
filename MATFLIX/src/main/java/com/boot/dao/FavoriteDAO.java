package com.boot.dao;

import com.boot.dto.FavoriteDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FavoriteDAO {
    // 즐겨찾기 추가
    int addFavorite(FavoriteDTO favoriteDTO) throws Exception;

    // 즐겨찾기 삭제 (PK 기준)
    int removeFavoriteById(@Param("favoriteId") long favoriteId) throws Exception;

    // 즐겨찾기 삭제 (사용자 번호와 레시피 ID 기준)
    int removeFavoriteByUserAndRecipe(@Param("mfNo") int mfNo, @Param("recipeId") int recipeId) throws Exception;

    // 특정 사용자의 즐겨찾기 목록 조회
    List<FavoriteDTO> getFavoritesByUserNo(@Param("mfNo") int mfNo) throws Exception;

    // 특정 레시피가 특정 사용자에 의해 즐겨찾기 되었는지 확인
    FavoriteDTO getFavoriteByUserAndRecipe(@Param("mfNo") int mfNo, @Param("recipeId") int recipeId) throws Exception;

    // 즐겨찾기 ID로 특정 즐겨찾기 정보 조회
    FavoriteDTO getFavoriteById(@Param("favoriteId") long favoriteId) throws Exception;

    // (선택 사항) 특정 사용자의 즐겨찾기 개수 조회
    int countFavoritesByUserNo(@Param("mfNo") int mfNo) throws Exception;
}