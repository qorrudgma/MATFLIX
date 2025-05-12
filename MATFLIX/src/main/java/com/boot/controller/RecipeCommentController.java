/*==========================================================
* 파일명     : RecipeCommentController.java
* 작성자     : 임진우
* 작성일자   : 2025-05-07
* 설명       : recipe 뷰의 댓글기능에 관한 클래스 파일입니다.

* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-08   임진우       최초생성
* 2025-05-08   임진우       댓글 기능 완
* 2025-05-12   임진우       댓글 작성자 별점기능 추가
============================================================*/

package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.RecipeCommentDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.RecipeCommentService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/rc_comment")
public class RecipeCommentController {

	@Autowired
	private RecipeCommentService service;

	@RequestMapping("/save")
	public @ResponseBody ArrayList<RecipeCommentDTO> save(@RequestParam HashMap<String, String> param,
			HttpServletRequest request) {
		log.info("@# save()");
		log.info("@# param=>" + param);

		HttpSession session = request.getSession();
		TeamDTO dto = (TeamDTO) session.getAttribute("user");
		int mf_no = dto.getMf_no();
		log.info("@# mf_no => " + mf_no);
		log.info("@# rc_board =>" + Integer.parseInt(param.get("rc_boardNo")));
		log.info("여기까지 됨");

		int result = service.count_comment_by_id(mf_no, Integer.parseInt(param.get("rc_boardNo")));

		log.info("@#user Session =>" + dto);
		log.info("@# result =>" + result);
		ArrayList<RecipeCommentDTO> commentList = new ArrayList<>();

		if (result == 0) {
			service.save(param, mf_no);
			commentList = service.findAll(Integer.parseInt(param.get("rc_boardNo")));
		}
		// 해당 게시글에 작성된 댓글 리스트를 가져옴

//		return null;
		return commentList;
	}

}
