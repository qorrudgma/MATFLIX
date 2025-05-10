package com.boot.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.RecipeAttachDAO;
import com.boot.dto.RecipeAttachDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("RecipeUploadService")
public class RecipeUploadServiceImpl implements RecipeUploadService {
	@Autowired
	private SqlSession sqlSession;

	// 폴더에 저장된 파일들 삭제
	@Override
	public void deleteFiles(List<RecipeAttachDTO> fileList) {
		log.info("@# deleteFile fileList=>" + fileList);

		if (fileList == null || fileList.size() == 0) {
			return;
		}

		fileList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\develop\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_"
						+ attach.getFileName());
				Files.deleteIfExists(file);

//				썸네일 삭제(이미지인 경우)
				if (Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\develop\\upload\\" + attach.getUploadPath() + "\\s_"
							+ attach.getUuid() + "_" + attach.getFileName());
					Files.delete(thumbNail);
				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}

	@Override
	public void insertFile(RecipeAttachDTO filedto) {
		log.info("@# insertFile filedto=>" + filedto);

		RecipeAttachDAO dao = sqlSession.getMapper(RecipeAttachDAO.class);
		dao.insertFile(filedto);
	}

	@Override
	public int getMaxId() {
		RecipeAttachDAO dao = sqlSession.getMapper(RecipeAttachDAO.class);
		int maxId = dao.getMaxId();
		return maxId;
	}

	@Override
	public RecipeAttachDTO get_upload_by_id(int rc_recipe_id) {
		RecipeAttachDAO dao = sqlSession.getMapper(RecipeAttachDAO.class);
		RecipeAttachDTO dto = dao.get_upload_by_id(rc_recipe_id);
		return dto;
	}

	@Override
	public ArrayList<RecipeAttachDTO> get_upload_all() {
		RecipeAttachDAO dao = sqlSession.getMapper(RecipeAttachDAO.class);
		ArrayList<RecipeAttachDTO> list = dao.get_upload_all();
		return list;
	}

}
