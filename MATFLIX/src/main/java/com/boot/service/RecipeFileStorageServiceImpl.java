package com.boot.service;

import java.io.File;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dao.RecipeDAO;
import com.boot.dto.RecipeImageDTO;
import com.boot.dto.RecipeWriteDTO;

import lombok.extern.log4j.Log4j2;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Log4j2
@Service("RecipeFileStorageService")
public class RecipeFileStorageServiceImpl implements RecipeFileStorageService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void save_image(int recipe_id, RecipeWriteDTO dto) {
		log.info("save_image 옴");
		RecipeDAO dao = sqlSession.getMapper(RecipeDAO.class);

		MultipartFile[] files = dto.getImage_path();
		String[] types = dto.getImage_type();
		int[] step_no = dto.getStep_no();

		String baseDir = "C:/matflix_upload/recipe";
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

				File save_dir = new File(baseDir + "/" + type_dir);
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
				img.setImage_path("/upload/recipe/" + type_dir + "/" + save_file_name);

				dao.insert_recipe_image(img);

			} catch (Exception e) {
				log.error("이미지 저장 실패", e);
				throw new RuntimeException("이미지 저장 중 오류 발생");
			}
		}
	}
}