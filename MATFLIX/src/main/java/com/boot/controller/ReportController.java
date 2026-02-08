package com.boot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.dto.ReportDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.ReportService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ReportController {
	@Autowired
	private ReportService reportService;

	@PostMapping("/insert_report")
	public String insert_report(ReportDTO reportDTO, HttpSession session, RedirectAttributes redirect_attributes) {
		log.info("insert_report() => " + reportDTO);
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			redirect_attributes.addFlashAttribute("report_exists", "로그인 후 이용 가능합니다.");
			return "redirect:/login";
		}
		int mf_no = user.getMf_no();

		if (reportService.report_exists(reportDTO) == 1) {
			log.info("reportService.report_exists(reportDTO) => " + reportService.report_exists(reportDTO));
			redirect_attributes.addFlashAttribute("report_exists", "이미 신고 이력이있습니다.");
			return "redirect:/recipe_content_view?recipe_id=" + reportDTO.getTarget_id();
		}

		reportDTO.setReporter_mf_no(mf_no);
		reportService.insert_report(reportDTO);
		redirect_attributes.addFlashAttribute("report_exists", "신고가 접수되었습니다.");

		return "redirect:/recipe_content_view?recipe_id=" + reportDTO.getTarget_id();
	}

	@GetMapping("/report_exists")
	@ResponseBody
	public Map<String, Object> report_exists(int target_id, HttpSession session) {
		log.info("report_exists()");
		Map<String, Object> result = new HashMap<>();

		TeamDTO user = (TeamDTO) session.getAttribute("user");
		if (user == null) {
			result.put("ok", false);
			result.put("code", "NOT_LOGIN");
			result.put("message", "로그인 후 이용 가능합니다.");
			return result;
		}

		int mf_no = user.getMf_no();

		ReportDTO reportDTO = new ReportDTO();
		reportDTO.setReporter_mf_no(mf_no);
		reportDTO.setTarget_type("RECIPE");
		reportDTO.setTarget_id(target_id);

		int exists = reportService.report_exists(reportDTO);

		if (exists == 1) {
			result.put("ok", false);
			result.put("code", "ALREADY_REPORTED");
			result.put("message", "이미 신고 이력이있습니다.");
			return result;
		}

		result.put("ok", true);
		result.put("code", "OK");
		return result;
	}
}