package com.boot.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dao.RecipeDAO;
import com.boot.dao.RecipeReviewDAO;
import com.boot.dao.TeamDAO;
import com.boot.dto.ProfileImageDTO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeReviewWriteDTO;
import com.boot.dto.RecipeWriteDTO;
import com.boot.dto.ReviewImageDTO;

import lombok.extern.log4j.Log4j2;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Log4j2
@Service("RecipeFileStorageService")
public class FileStorageServiceImpl implements FileStorageService {
	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private TeamService teamService;

	@Override
	public void save_image(int recipe_id, RecipeWriteDTO dto) {
		log.info("save_image 옴");
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);

		MultipartFile[] files = dto.getImage_file();
		String[] types = dto.getImage_type();
		int[] step_no = dto.getStep_no();

		String base_dir = "C:/matflix_upload/recipe";
		for (int i = 0; i < files.length; i++) {

			MultipartFile file = files[i];
			if (file == null || file.isEmpty()) {
				continue;
			}

			try {
				// 파일명 생성
				String originalName = file.getOriginalFilename();
				String ext = "";
				log.info("originalName => " + originalName);

				if (originalName != null && originalName.lastIndexOf(".") != -1) {
					ext = originalName.substring(originalName.lastIndexOf("."));
				}

				String save_file_name = UUID.randomUUID().toString() + ext;

				// 타입별 폴더 분리
				String type = types[i];
				String type_dir = type.toLowerCase();

				File save_dir = new File(base_dir + "/" + type_dir);
				if (!save_dir.exists()) {
					save_dir.mkdirs();
				}

				File saveFile = new File(save_dir, save_file_name);

				// 파일 저장
				file.transferTo(saveFile);
				log.error("이미지 저장");

				// DB 저장
				RecipeImageDTO img = new RecipeImageDTO();
				img.setRecipe_id(recipe_id);
				img.setImage_type(type);
				img.setStep_no(step_no[i]);
				img.setImage_path("/recipe/" + type_dir + "/" + save_file_name);

				dao.insert_recipe_image(img);

			} catch (Exception e) {
				log.error("이미지 저장 실패", e);
				throw new RuntimeException("이미지 저장 중 오류 발생");
			}
		}
	}

	@Override
	public void delete_image(List<RecipeImageDTO> dto) {
		String delete_base_dir = "C:/matflix_upload";
		List<RecipeImageDTO> image_list = dto;

		if (image_list != null && !image_list.isEmpty()) {
			for (RecipeImageDTO image_dto : image_list) {
				String image_path = image_dto.getImage_path();
				if (image_path == null || image_path.trim().isEmpty()) {
					continue;
				}
				File file = new File(delete_base_dir + image_path);
				if (file.exists() && file.isFile()) {
					boolean deleted = file.delete();
					if (deleted) {
						log.info("이미지 파일 삭제 완료: {}", file.getAbsolutePath());
					} else {
						log.warn("이미지 파일 삭제 실패: {}", file.getAbsolutePath());
					}
				} else {
					log.warn("삭제 대상 파일 없음: {}", file.getAbsolutePath());
				}
			}
		}
	}

	@Override
	public void modify_recipe_image(int recipe_id, RecipeWriteDTO dto) {
		log.info("save_image 옴");
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);

		MultipartFile[] files = dto.getImage_file();
		String[] types = dto.getImage_type();
		String[] image_path = dto.getImage_path();
		int[] step_no = dto.getStep_no();
		log.info("step_no.length => {}\nimage_path.length => {}\nfiles.length => {}", step_no.length, image_path.length,
				files.length);
		log.info("!@#$!@$# => " + image_path);

		String base_dir = "C:/matflix_upload/recipe";
		for (int i = 0; i < step_no.length; i++) {
			MultipartFile file = files[i];
			if (image_path[i].isEmpty()) {
				if (file == null || file.isEmpty()) {
					log.info("이미지가 반드시 필요합니다. step => " + step_no[i]);
					throw new IllegalStateException("이미지가 반드시 필요합니다. step=" + step_no[i]);
				}
				try {
					// 파일명 생성
					String originalName = file.getOriginalFilename();
					String ext = "";
					log.info("originalName => " + originalName);

					if (originalName != null && originalName.lastIndexOf(".") != -1) {
						ext = originalName.substring(originalName.lastIndexOf("."));
					}

					String save_file_name = UUID.randomUUID().toString() + ext;

					// 타입별 폴더 분리
					String type = types[i];
					String type_dir = type.toLowerCase();

					File save_dir = new File(base_dir + "/" + type_dir);
					if (!save_dir.exists()) {
						save_dir.mkdirs();
					}

					File saveFile = new File(save_dir, save_file_name);

					// 파일 저장
					file.transferTo(saveFile);
					log.error("이미지 저장");

					// DB 저장
					RecipeImageDTO img = new RecipeImageDTO();
					img.setRecipe_id(recipe_id);
					img.setImage_type(type);
					img.setStep_no(step_no[i]);
					img.setImage_path("/recipe/" + type_dir + "/" + save_file_name);

					dao.insert_recipe_image(img);

				} catch (Exception e) {
					log.error("이미지 저장 실패", e);
					throw new RuntimeException("이미지 저장 중 오류 발생");
				}
			} else {
				RecipeImageDTO img = new RecipeImageDTO();
				String type = types[i];
				img.setRecipe_id(recipe_id);
				img.setImage_type(type);
				img.setStep_no(step_no[i]);
				img.setImage_path(image_path[i]);

				dao.insert_recipe_image(img);
			}
		}

		// 파일 삭제
		String delete_base_dir = "C:/matflix_upload";
		String[] delete_image_path = dto.getDelete_image_path();
		log.info("delete_image_path => " + delete_image_path);

		if (delete_image_path != null && delete_image_path.length > 0) {
			for (String path : delete_image_path) {
				if (path == null || path.trim().isEmpty()) {
					continue;
				}
				log.info(delete_base_dir + path);
				File file = new File(delete_base_dir + path);

				if (file.exists() && file.isFile()) {
					boolean deleted = file.delete();
					if (!deleted) {
						log.warn("이미지 파일 삭제 실패: " + file.getAbsolutePath());
					} else {
						log.info("이미지 파일 삭제 완료: " + file.getAbsolutePath());
					}
				} else {
					log.warn("삭제 대상 파일 없음: " + file.getAbsolutePath());
				}
			}
		}
	}

	@Override
	public String save_review_image(ReviewImageDTO dto) {
		MultipartFile file = dto.getImage_file();

		String baseDir = "C:/matflix_upload/review";

		try {
			String original_name = file.getOriginalFilename();
			String ext = "";

			if (original_name != null && original_name.lastIndexOf(".") != -1) {
				ext = original_name.substring(original_name.lastIndexOf("."));
			}

			String save_file_name = UUID.randomUUID() + ext;

			File dir = new File(baseDir);
			if (!dir.exists()) {
				dir.mkdirs();
			}

			File save_file = new File(dir, save_file_name);
			file.transferTo(save_file);

			log.info("리뷰 이미지 저장 완료: {}", save_file.getAbsolutePath());
			return "/review/" + save_file_name;
		} catch (Exception e) {
			log.error("리뷰 이미지 저장 실패", e);
			throw new RuntimeException("이미지 저장 중 오류 발생");
		}
	}

	@Override
	public void modify_revoiw_image(RecipeReviewWriteDTO dto) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		MultipartFile file = dto.getImage_file();

		String base_dir = "C:/matflix_upload/review";

		if (file != null && !file.isEmpty()) {
			try {
				String old_image_path = "C:/matflix_upload" + dto.getImage_path();
				File old_file = new File(old_image_path);

				if (old_file.exists()) {
					boolean deleted = old_file.delete();
					log.info("기존 리뷰 이미지 삭제 => {} / 성공여부 = {}", old_file.getAbsolutePath(), deleted);
				}

				String original_name = file.getOriginalFilename();
				String ext = "";

				if (original_name != null && original_name.lastIndexOf(".") != -1) {
					ext = original_name.substring(original_name.lastIndexOf("."));
				}

				String save_file_name = UUID.randomUUID() + ext;

				File dir = new File(base_dir);
				if (!dir.exists()) {
					dir.mkdirs();
				}

				File save_file = new File(dir, save_file_name);
				file.transferTo(save_file);

				ReviewImageDTO RIDTO = new ReviewImageDTO();
				RIDTO.setReview_id(dto.getReview_id());
				RIDTO.setImage_path("/review/" + save_file_name);
				dao.update_review_image(RIDTO);
				log.info("리뷰 이미지 수정 완료: {}", save_file.getAbsolutePath());
			} catch (Exception e) {
				log.error("리뷰 이미지 수정 실패", e);
				throw new RuntimeException("리뷰 이미지 수정 중 오류 발생");
			}
		}
	}

	@Override
	public void delete_revoiw_image(int review_id) {
		RecipeReviewDAO dao = sqlSession.getMapper(RecipeReviewDAO.class);
		String image_path = dao.review_image_path(review_id);

		try {
			File delete_image_path = new File("C:/matflix_upload", image_path);

			if (delete_image_path.exists()) {
				boolean deleted = delete_image_path.delete();
				log.info("기존 리뷰 이미지 삭제 => {} / 성공여부 = {}", delete_image_path.getAbsolutePath(), deleted);
			}

			dao.delete_review_image(review_id);
			log.info("리뷰 이미지 삭제 완료: {}", delete_image_path.getAbsolutePath());
		} catch (Exception e) {
			log.error("리뷰 이미지 삭제 실패", e);
			throw new RuntimeException("리뷰 이미지 삭제 중 오류 발생");
		}
	}

	@Override
	public void modify_profile_image(ProfileImageDTO dto) {
		TeamDAO dao = sqlSession.getMapper(TeamDAO.class);
		MultipartFile file = dto.getImage_file();
		log.info("ProfileImageDTO => " + dto);
		String base_dir = "C:/matflix_upload/profile";

		if (file != null && !file.isEmpty()) {
			try {
				if (dto.getProfile_image_path() != null && !dto.getProfile_image_path().isBlank()) {
					String old_image_path = "C:/matflix_upload" + dto.getProfile_image_path();
					File old_file = new File(old_image_path);
					log.info("old_image_path => " + old_image_path);

					if (old_file.exists()) {
						boolean deleted = old_file.delete();
						log.info("기존 프로필 이미지 삭제 => {} / 성공여부 = {}", old_file.getAbsolutePath(), deleted);
					} else {
						log.warn("삭제 대상 파일이 존재하지 않음");
					}
				}

				String original_name = file.getOriginalFilename();
				String ext = "";

				if (original_name != null && original_name.lastIndexOf(".") != -1) {
					ext = original_name.substring(original_name.lastIndexOf("."));
				}

				String save_file_name = UUID.randomUUID() + ext;

				File dir = new File(base_dir);
				if (!dir.exists()) {
					dir.mkdirs();
				}

				File save_file = new File(dir, save_file_name);
				file.transferTo(save_file);

				teamService.modify_profile_image(dto.getMf_no(), "/profile/" + save_file_name);
				log.info(dto.getMf_no() + "!@#" + save_file_name);
				log.info("프로필 이미지 수정 완료: {}", save_file.getAbsolutePath());
			} catch (Exception e) {
				log.error("프로필 이미지 수정 실패", e);
				throw new RuntimeException("프로필 이미지 수정 중 오류 발생");
			}
		}
	}
}