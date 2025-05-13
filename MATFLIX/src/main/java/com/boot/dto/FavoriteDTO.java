package com.boot.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.time.LocalDateTime;
import java.time.ZoneId; // ZoneId 임포트 추가
import java.util.Date;    // java.util.Date 임포트 추가

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FavoriteDTO {
	 private Long favoriteId;        // 즐겨찾기 ID (PK, favorite_id 컬럼)
	 private Integer mfNo;           // 사용자 번호 (FK, mf_no 컬럼)
	 private Integer recipeId;       // 레시피 ID (FK, rc_recipe_id 컬럼)
	 private LocalDateTime createdAt;   // 즐겨찾기 추가 일시 (created_at 컬럼)
	 
	 
	// JSP에서 <fmt:formatDate>와 함께 사용하기 위해 추가하는 메소드
	    public Date getCreatedAtAsDate() {
	        if (this.createdAt == null) {
	            return null;
	        }
	        // LocalDateTime을 시스템 기본 시간대의 ZonedDateTime으로 변환 후 Instant를 거쳐 Date로 변환
	        return Date.from(this.createdAt.atZone(ZoneId.systemDefault()).toInstant());
	    }
}