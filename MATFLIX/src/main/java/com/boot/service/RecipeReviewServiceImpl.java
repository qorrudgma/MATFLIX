package com.boot.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.dao.RecipeDAO;
import com.boot.dao.RecipeReviewDAO;
import com.boot.dto.RecipeReviewDTO;
import com.boot.dto.RecipeReviewSummaryDTO;
import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.ReviewImageDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipeReviewService")
public class RecipeReviewServiceImpl implements RecipeReviewService {
	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private FileStorageService recipeFileStorageService;

	@Transactional
	@Override
	public void process_review_write(RecipeReviewWriteDTO dto) {
		log.info("process_review_write => " + dto);
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		RecipeReviewDTO RRDTO = new RecipeReviewDTO();
		RRDTO.setRecipe_id(dto.getRecipe_id());
		RRDTO.setContent(dto.getContent());
		RRDTO.setMf_no(dto.getMf_no());
		RRDTO.setRating(dto.getRating());
		dao.insert_review(RRDTO);
		log.info("insert_review 저장");

		ReviewImageDTO RIDTO = new ReviewImageDTO();
		RIDTO.setReview_id(RRDTO.getReview_id());
		RIDTO.setImage_file(dto.getImage_file());
		log.info("리뷰 이미지 폴더 저장");

		String image_path = recipeFileStorageService.save_review_image(RIDTO);
		RIDTO.setImage_path(image_path);
		dao.insert_review_image(RIDTO);
		log.info("리뷰 이미지 디비 저장");

		RecipeReviewSummaryDTO RRSDTO = new RecipeReviewSummaryDTO();
		RRSDTO.setRecipe_id(dto.getRecipe_id());
		RRSDTO.setRating(dto.getRating());
		dao.insert_review_summary(RRSDTO);

		RecipeDAO Rdao = sqlSession.getMapper(RecipeDAO.class);
		Rdao.modify_recipe_star(dto.getRecipe_id());
		log.info("별점 디비 저장");
	}

	@Override
	public void insert_review(RecipeReviewDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.insert_review(dto);
	}

	@Override
	public void modify_review(RecipeReviewWriteDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.modify_review(dto);
		recipeFileStorageService.modify_revoiw_image(dto);
		RecipeReviewSummaryDTO RRSDTO = new RecipeReviewSummaryDTO();
		RRSDTO.setRecipe_id(dto.getRecipe_id());
		RRSDTO.setOld_rating(dto.getOld_rating());
		RRSDTO.setNew_rating(dto.getRating());
		dao.update_review_summary(RRSDTO);
		RecipeDAO Rdao = sqlSession.getMapper(RecipeDAO.class);
		Rdao.modify_recipe_star(dto.getRecipe_id());
	}

	@Transactional
	@Override
	public void delete_review(int review_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		// 별점 수정
		RecipeReviewDTO RRDTO = dao.find_delete_review_data(review_id);
		RecipeReviewSummaryDTO RRSDTO = new RecipeReviewSummaryDTO();
		RRSDTO.setRecipe_id(RRDTO.getRecipe_id());
		RRSDTO.setOld_rating(RRDTO.getRating());
		RRSDTO.setNew_rating(0);
		dao.delete_review_summary(RRSDTO);
		// 이미지 삭제
		recipeFileStorageService.delete_revoiw_image(review_id);
		// 리뷰 삭제
		dao.delete_review(review_id);
		RecipeDAO Rdao = sqlSession.getMapper(RecipeDAO.class);
		Rdao.modify_recipe_star(RRDTO.getRecipe_id());
	}

	@Override
	public List<RecipeReviewDTO> review_list() {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.review_list();
		return null;
	}

	@Override
	public RecipeReviewDTO select_review(int review_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		RecipeReviewDTO review_detail = dao.select_review(review_id);
		return review_detail;
	}

	@Override
	public void insert_review_image(ReviewImageDTO imageDTO) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.insert_review_image(imageDTO);
	}

	@Override
	public List<ReviewImageDTO> review_image_list(int recipe_id, String sort) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		List<ReviewImageDTO> review_image_list = new ArrayList<>();
		review_image_list = dao.review_image_list(recipe_id, sort);
		return review_image_list;
	}

	@Override
	public void insert_review_summary(RecipeReviewSummaryDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.insert_review_summary(dto);
	}

	@Override
	public RecipeReviewSummaryDTO review_summary_list(int review_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		RecipeReviewSummaryDTO review_summary_list = new RecipeReviewSummaryDTO();
		review_summary_list = dao.review_summary_list(review_id);
		log.info("review_summary_list => " + review_summary_list);
		return review_summary_list;
	}

	@Override
	public void delete_review_image(int recipe_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.delete_review_image(recipe_id);
	}

	@Override
	public String review_image_path(int recipe_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		return dao.review_image_path(recipe_id);
	}

	@Override
	public void update_review_image(ReviewImageDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.update_review_image(dto);
	}

	@Override
	public void update_review_summary(RecipeReviewSummaryDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.update_review_summary(dto);
	}

	@Override
	public void delete_review_summary(RecipeReviewSummaryDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.delete_review_summary(dto);
	}

	@Override
	public RecipeReviewDTO find_delete_review_data(int review_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		return dao.find_delete_review_data(review_id);
	}
}