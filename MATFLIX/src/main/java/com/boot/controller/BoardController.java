package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.dto.RecommendDTO;
import com.boot.service.BoardService;
import com.boot.service.CommentService;
import com.boot.service.EmailService;
import com.boot.service.RecommendService;
import com.boot.service.UploadService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {
	@Autowired
	private BoardService service;

	@Autowired
	private CommentService commentService;

	@Autowired
	private UploadService uploadService;

	@Autowired
	private RecommendService recommendService;

	@Autowired
	private EmailService emailService;

//	@RequestMapping("/main")
//	public String main() {
//		log.info("@# main()");
//		return "main";
//	}

//	@RequestMapping("/main")
//	public String list(Model model) {
//		log.info("@# main()");
//
//		ArrayList<BoardDTO> list = service.list();
//		model.addAttribute("list", list);
//
//		return "main";
//	}

	@RequestMapping("/write")
	public String write(BoardDTO boardDTO) {
		log.info("@# write()");
		log.info("@# boardDTO=>" + boardDTO);

		if (boardDTO.getAttachList() != null) {
			boardDTO.getAttachList().forEach(attach -> log.info("@# attach=>" + attach));
		}

		service.write(boardDTO);
		// 여기다가 메일 보내는거 적기
//		emailService.

		return "redirect:list";
	}

	@RequestMapping("/write_view")
	public String write_view() {
		log.info("@# write_view()");

		return "write_view";
	}

	@RequestMapping("/content_view")
	public String content_view(@RequestParam HashMap<String, String> param, Model model) {
		log.info("@# content_view()");
		log.info("@# param=>" + param);

		BoardDTO dto = service.contentView(param);
		model.addAttribute("content_view", dto);
		service.hitUp(param);

		model.addAttribute("pageMaker", param);

		// 추천
		RecommendDTO Rdto = new RecommendDTO();
		log.info("param in boardNo => " + param.get("boardNo"));
		log.info("param in mf_no => " + param.get("mf_no"));

		int total_recommend = recommendService.total_recommend(Integer.parseInt(param.get("boardNo")));
		int count = commentService.count(Integer.parseInt(param.get("boardNo")));

		ArrayList<CommentDTO> commentList = commentService.findAll(param);
		if (param.get("mf_no") != null) {
			try {
				Rdto.setBoardNo(Integer.parseInt(param.get("boardNo")));
				Rdto.setMf_no(Integer.parseInt(param.get("mf_no")));
				int recommend = recommendService.check_recommend(Rdto);
				model.addAttribute("recommend", recommend);
			} catch (Exception e) {
				log.info("mf_no => null");
			}
		}
		model.addAttribute("count", count);
		model.addAttribute("commentList", commentList);
		model.addAttribute("total_recommend", total_recommend);

		log.info("model => " + model);
		return "content_view";
	}

	@RequestMapping("/modify")
	public String modify(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
		log.info("@# modify()");
		log.info("@# param=>" + param);

		service.modify(param);

		rttr.addAttribute("pageNum", param.get("pageNum"));
		rttr.addAttribute("amount", param.get("amount"));

		return "redirect:list";
	}

	@RequestMapping("/delete")
	public String delete(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
		log.info("@# delete()");
		log.info("@# param=>" + param);
		log.info("@# boardNo=>" + param.get("boardNo"));

		List<BoardAttachDTO> fileList = uploadService.getFileList(Integer.parseInt(param.get("boardNo")));
		log.info("@# fileList=>" + fileList);

		service.delete(param);
		uploadService.deleteFiles(fileList);
		commentService.boardCommentDelete(param);
		recommendService.delete_board(Integer.parseInt(param.get("boardNo")));

		rttr.addAttribute("pageNum", param.get("pageNum"));
		rttr.addAttribute("amount", param.get("amount"));

		return "redirect:list";
	}
}