package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.ReportDAO;
import com.boot.dto.ReportDTO;
import com.boot.dto.ReportImageDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ReportServiceImpl implements ReportService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private FileStorageService fileStorageService;

	@Override
	public void insert_report(ReportDTO reportDTO) {
		ReportDAO dao = sqlSession.getMapper(ReportDAO.class);
		// 신고 정보 DB 저장
		dao.insert_report(reportDTO);

		int report_id = reportDTO.getReport_id();
		log.info("report_id => " + report_id);
		// 신고 이미지 저장
		String result = fileStorageService.save_report(reportDTO);
		if (result.equals("success")) {
			log.info("이미지 저장성공");
		} else {
			log.info("이미지 저장 실패");
		}
	}

	@Override
	public void save_report_image(ReportImageDTO reportImageDTO) {
		ReportDAO dao = sqlSession.getMapper(ReportDAO.class);
		dao.save_report_image(reportImageDTO);
	}

	@Override
	public void report_list(int mf_no) {
		ReportDAO dao = sqlSession.getMapper(ReportDAO.class);
		dao.report_list(mf_no);
	}

	@Override
	public int report_exists(ReportDTO reportDTO) {
		ReportDAO dao = sqlSession.getMapper(ReportDAO.class);
		int report_exists = dao.report_exists(reportDTO);
		return report_exists;
	}
}