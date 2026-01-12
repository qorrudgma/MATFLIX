package com.boot.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	private RecipeFileStorageService recipeFileStorageService;

	@Override
	public void process_recipe_write(RecipeReviewWriteDTO dto) {
		log.info("process_recipe_write()");
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
		RRSDTO.setRating_sum(dto.getRating());
		dao.insert_review_summary(RRSDTO);
	}

	@Override
	public void insert_review(RecipeReviewDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.insert_review(dto);
	}

	@Override
	public void modify_review(RecipeReviewDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.modify_review(dto);
	}

	@Override
	public void delete_review(int recipe_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		dao.delete_review(recipe_id);
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
		RecipeReviewDTO review_detail = new RecipeReviewDTO();
		review_detail = dao.select_review(review_id);
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
}