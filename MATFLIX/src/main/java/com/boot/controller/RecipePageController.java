/*==========================================================
* 파일명     : RecipePageController.java
* 작성자     : 임진우
* 작성일자   : 2025-05-07
* 설명       : recipe 게시판의 페이징 처리에 관한 클래스파일입니다.

* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-08   임진우       최초생성
============================================================*/
package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.RecipeCriteria;
import com.boot.service.RecipePageService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RecipePageController {
	@Autowired
	private RecipePageService service_page;

	@RequestMapping("/rc_list")
	public String list(RecipeCriteria cri, Model model) {

		return "recipe_board";
	}
}
