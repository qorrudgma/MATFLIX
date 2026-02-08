package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.RecipeReportDTO;
import com.boot.dto.ReportDTO;
import com.boot.dto.ReportImageDTO;
import com.boot.dto.SearchDTO;

@Mapper
public interface ReportDAO {
	public void insert_report(ReportDTO reportDTO);

	public void save_report_image(ReportImageDTO reportImageDTO);

	public List<RecipeReportDTO> recipe_report_list(SearchDTO searchDTO);

	public int report_exists(ReportDTO reportDTO);
}