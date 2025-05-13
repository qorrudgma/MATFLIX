package com.boot.service;

import com.boot.dao.FavoriteDAO;
import com.boot.dto.FavoriteDTO;
import com.boot.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException; // 중복 키 예외 처리용
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("favoriteService")
@RequiredArgsConstructor
@Slf4j
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteDAO favoriteDAO;

    @Transactional
    @Override
    public FavoriteDTO addRecipeToFavorites(int mfNo, int recipeId) throws Exception {
        // 이미 즐겨찾기 되어 있는지 먼저 확인
        if (isRecipeFavoritedByUser(mfNo, recipeId)) {
            log.warn("Recipe (ID: {}) already favorited by user (No: {})", recipeId, mfNo);
            throw new IllegalArgumentException("이미 즐겨찾기에 추가된 레시피입니다.");
        }

        FavoriteDTO favoriteDTO = FavoriteDTO.builder()
                .mfNo(mfNo)
                .recipeId(recipeId)
                .build();
        try {
            favoriteDAO.addFavorite(favoriteDTO); // favoriteDTO에 favoriteId가 채워짐
            log.info("Recipe (ID: {}) added to favorites for user (No: {}). New favorite ID: {}", recipeId, mfNo, favoriteDTO.getFavoriteId());
            return favoriteDTO;
        } catch (DataIntegrityViolationException e) {
            log.error("Data integrity violation while adding favorite for mfNo: {}, recipeId: {}. Might be a duplicate.", mfNo, recipeId, e);
            // 이미 위에서 isRecipeFavoritedByUser로 체크했기 때문에 이 예외는 동시성 문제 등이 아니면 발생하기 어려움
            throw new IllegalArgumentException("이미 즐겨찾기에 추가된 레시피이거나 데이터 무결성 오류입니다.", e);
        }
    }

    @Transactional
    @Override
    public boolean removeRecipeFromFavoritesById(long favoriteId, int mfNo) throws Exception {
        // 삭제하려는 즐겨찾기가 본인의 것인지 확인
        FavoriteDTO existingFavorite = favoriteDAO.getFavoriteById(favoriteId);
        if (existingFavorite == null) {
            log.warn("Favorite (ID: {}) not found for removal attempt by user (No: {})", favoriteId, mfNo);
            return false;
        }
        if (existingFavorite.getMfNo() != mfNo) {
            log.warn("User (No: {}) attempted to remove favorite (ID: {}) not belonging to them.", mfNo, favoriteId);
            throw new SecurityException("자신의 즐겨찾기만 삭제할 수 있습니다.");
        }

        int result = favoriteDAO.removeFavoriteById(favoriteId);
        if (result > 0) {
            log.info("Favorite (ID: {}) removed by user (No: {})", favoriteId, mfNo);
        }
        return result > 0;
    }

    @Transactional
    @Override
    public boolean removeRecipeFromFavorites(int mfNo, int recipeId) throws Exception {
        int result = favoriteDAO.removeFavoriteByUserAndRecipe(mfNo, recipeId);
        if (result > 0) {
            log.info("Recipe (ID: {}) removed from favorites for user (No: {})", recipeId, mfNo);
        }
        return result > 0;
    }

    @Override
    public List<FavoriteDTO> getUserFavoriteRecipes(int mfNo) throws Exception {
        log.debug("Fetching favorite recipes for user (No: {})", mfNo);
        return favoriteDAO.getFavoritesByUserNo(mfNo);
    }

    @Override
    public boolean isRecipeFavoritedByUser(int mfNo, int recipeId) throws Exception {
        FavoriteDTO favorite = favoriteDAO.getFavoriteByUserAndRecipe(mfNo, recipeId);
        return favorite != null;
    }
}