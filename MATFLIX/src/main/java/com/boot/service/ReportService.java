package com.boot.service;

import java.util.List;

import com.boot.dto.RecipeReportDTO;
import com.boot.dto.ReportDTO;
import com.boot.dto.ReportImageDTO;
import com.boot.dto.SearchDTO;

public interface ReportService {
	public void insert_report(ReportDTO reportDTO);

	public void save_report_image(ReportImageDTO reportImageDTO);

	public List<RecipeReportDTO> recipe_report_list(SearchDTO searchDTO);

	public int report_exists(ReportDTO reportDTO);
}