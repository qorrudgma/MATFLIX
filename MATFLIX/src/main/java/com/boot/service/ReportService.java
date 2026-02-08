package com.boot.service;

import com.boot.dto.ReportDTO;
import com.boot.dto.ReportImageDTO;

public interface ReportService {
	public void insert_report(ReportDTO reportDTO);

	public void save_report_image(ReportImageDTO reportImageDTO);

	public void report_list(int mf_no);

	public int report_exists(ReportDTO reportDTO);
}