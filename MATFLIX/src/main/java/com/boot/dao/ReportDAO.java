package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.ReportDTO;
import com.boot.dto.ReportImageDTO;

@Mapper
public interface ReportDAO {
	public void insert_report(ReportDTO reportDTO);

	public void save_report_image(ReportImageDTO reportImageDTO);

	public void report_list(int mf_no);

	public int report_exists(ReportDTO reportDTO);
}