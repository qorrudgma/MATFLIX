package com.boot.controller;

import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
// import javax.servlet.http.HttpSession; // 세션 사용 시
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.FavoriteDTO;
import com.boot.dto.TeamDTO;
// import com.boot.dto.UserSessionDTO; // 세션에서 사용자 정보를 가져오기 위한 DTO (예시)
import com.boot.service.FavoriteService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/favorites/recipe") // 레시피 즐겨찾기 관련 경로
@RequiredArgsConstructor
@Slf4j
public class FavoriteController {

    private final FavoriteService favoriteService;

    // 현재 로그인한 사용자 번호를 가져오는 메소드임
    private Integer getCurrentUserNo(HttpSession session) {
        TeamDTO user = (TeamDTO) session.getAttribute("user");
    	 if (user == null) {
    	        return null; // 로그인 안 된 상태
    	    }
    	    return user.getMf_no(); // 로그인된 사용자의 번호 반환
    }

    // 레시피 즐겨찾기 추가
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addRecipeFavorite(@RequestBody Map<String, Integer> payload , HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Integer mfNo = getCurrentUserNo(session);
        Integer recipeId = payload.get("recipeId");

        if (mfNo == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        if (recipeId == null) {
            response.put("success", false);
            response.put("message", "레시피 ID가 필요합니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        try {
            FavoriteDTO addedFavorite = favoriteService.addRecipeToFavorites(mfNo, recipeId);
            response.put("success", true);
            response.put("message", "레시피가 즐겨찾기에 추가되었습니다.");
            response.put("favoriteId", addedFavorite.getFavoriteId());
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
        } catch (Exception e) {
            log.error("Error adding recipe favorite for userNo: {}, recipeId: {}", mfNo, recipeId, e);
            response.put("success", false);
            response.put("message", "즐겨찾기 추가 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // 레시피 즐겨찾기 삭제
    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeRecipeFavorite(@RequestBody Map<String, Integer> payload , HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Integer mfNo = getCurrentUserNo(session);
        Integer recipeId = payload.get("recipeId"); // recipeId로 받아서 삭제

        if (mfNo == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        if (recipeId == null) {
            response.put("success", false);
            response.put("message", "레시피 ID가 필요합니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        try {
            boolean removed = favoriteService.removeRecipeFromFavorites(mfNo, recipeId);
            if (removed) {
                response.put("success", true);
                response.put("message", "레시피가 즐겨찾기에서 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "즐겨찾기에서 삭제할 레시피를 찾지 못했거나 이미 삭제되었습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
        } catch (Exception e) {
            log.error("Error removing recipe favorite for userNo: {}, recipeId: {}", mfNo, recipeId, e);
            response.put("success", false);
            response.put("message", "즐겨찾기 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // 사용자의 즐겨찾기 레시피 목록 페이지
    @GetMapping("/my-list")
    public String myFavoriteRecipes(Model model , HttpSession session) {
        Integer mfNo = getCurrentUserNo(session);
        if (mfNo == null) {
            return "redirect:/login"; 
        }

        try {
            List<FavoriteDTO> favorites = favoriteService.getUserFavoriteRecipes(mfNo);
            model.addAttribute("favorites", favorites);
            // 이 목록을 사용하여 레시피 정보를 추가로 조회
            // 예: List<RecipeDTO> favoriteRecipes = recipeService.getRecipesByIds(favorites.stream().map(FavoriteDTO::getRecipeId).collect(Collectors.toList()));
            // model.addAttribute("favoriteRecipes", favoriteRecipes);

        } catch (Exception e) {
            log.error("Error fetching user's favorite recipes for mfNo: {}", mfNo, e);
            model.addAttribute("error", "즐겨찾기 목록을 불러오는 중 오류가 발생했습니다.");
            // 에러 페이지로 이동하거나 현재 페이지에 오류 메시지 표시
        }
        return "myFavoriteRecipes";
    }

    // 레시피가 현재 사용자의 즐겨찾기인지 확인
    @GetMapping("/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getFavoriteStatus(@RequestParam("recipeId") int recipeId , HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Integer mfNo = getCurrentUserNo(session);

        if (mfNo == null) {
            response.put("isFavorited", false); // 로그인 안했으면 즐겨찾기 아님
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response); // 혹은 UNAUTHORIZED
        }

        try {
            boolean isFavorited = favoriteService.isRecipeFavoritedByUser(mfNo, recipeId);
            response.put("isFavorited", isFavorited);
            response.put("recipeId", recipeId);
            response.put("mfNo", mfNo); // 디버깅용
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error checking favorite status for mfNo: {}, recipeId: {}", mfNo, recipeId, e);
            response.put("error", true);
            response.put("message", "상태 확인 중 오류 발생");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
//    @GetMapping("/myFavoriteRecipes")
//    public String myFavoriteRecipes(HttpSession session, Model model) throws Exception {
//        TeamDTO loginUser = (TeamDTO) session.getAttribute("user");
//
//        if (loginUser == null) {
//            return "redirect:/login";
//        }
//
//        int mfNo = loginUser.getMf_no();
//
//        List<FavoriteDTO> favoriteList = favoriteService.getUserFavoriteRecipes(mfNo);
//        model.addAttribute("favorites", favoriteList);
//        return "myFavoriteRecipes";
//    }
    
    @GetMapping("/myFavoriteRecipes") // 또는 사용 중인 다른 경로 (예: "/my-list")
    public String myFavoriteRecipes(HttpSession session, Model model) throws Exception {
        TeamDTO loginUser = (TeamDTO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login";
        }

        int mfNo = loginUser.getMf_no();

        // 1. 서비스로부터 원본 FavoriteDTO 리스트를 가져옵니다.
        List<FavoriteDTO> originalFavoriteList = favoriteService.getUserFavoriteRecipes(mfNo);

        // 2. JSP에서 사용하기 좋게 데이터를 가공할 새로운 리스트를 준비합니다.
        List<Map<String, Object>> favoritesForView = new ArrayList<>();

        // 3. 원본 리스트를 순회하며 데이터를 가공합니다.
        for (FavoriteDTO dto : originalFavoriteList) {
            Map<String, Object> favoriteMap = new HashMap<>();
            favoriteMap.put("favoriteId", dto.getFavoriteId());
            favoriteMap.put("mfNo", dto.getMfNo()); // 필요하다면 JSP에서 사용하기 위해 유지
            favoriteMap.put("recipeId", dto.getRecipeId()); // 레시피 상세 페이지 링크 등에 필요

            // LocalDateTime을 java.util.Date로 변환하여 Map에 추가
            if (dto.getCreatedAt() != null) {
                Date createdAtAsDate = Date.from(dto.getCreatedAt().atZone(ZoneId.systemDefault()).toInstant());
                favoriteMap.put("createdAt", createdAtAsDate); // JSP에서 ${fav.createdAt}으로 접근
            } else {
                favoriteMap.put("createdAt", null);
            }

            // 만약 JSP에서 레시피 이름 등 FavoriteDTO에 없는 추가 정보가 필요하다면,
            // 여기서 해당 정보를 조회하여 favoriteMap에 추가할 수 있습니다.
            // 예: favoriteMap.put("recipeName", recipeService.getRecipeNameById(dto.getRecipeId()));

            favoritesForView.add(favoriteMap);
        }

        // 4. 가공된 리스트를 모델에 추가합니다.
        model.addAttribute("favorites", favoritesForView);

        return "myFavoriteRecipes"; // 뷰 이름 (/WEB-INF/views/myFavoriteRecipes.jsp)
    }
}