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
============================================================*/

package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.RecipeCommentDTO;
import com.boot.service.RecipeCommentService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/rc_comment")
public class RecipeCommentController {

	@Autowired
	private RecipeCommentService service;

	@RequestMapping("/save")
//	public String save(@RequestParam HashMap<String, String> param) {
//	public ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param) {
	public @ResponseBody ArrayList<RecipeCommentDTO> save(@RequestParam HashMap<String, String> param) {
		log.info("@# save()");
		log.info("@# param=>" + param);

		service.save(param);

		// 해당 게시글에 작성된 댓글 리스트를 가져옴
		ArrayList<RecipeCommentDTO> commentList = service.findAll(Integer.parseInt(param.get("rc_boardNo")));
//		return null;
		return commentList;
	}

}
