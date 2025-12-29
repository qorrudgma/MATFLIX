package com.boot.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.BoardService;
import com.boot.service.CommentRecommendService;
import com.boot.service.CommentService;
import com.boot.service.NotificationService;
import com.boot.service.SseService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/comment")
public class CommentController {

	@Autowired
	private CommentService commentService;

	@Autowired
	private CommentRecommendService commentRecommendService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private final SseService sseService = new SseService();

	@RequestMapping("/save")
	@ResponseBody
	public ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param) {
		log.info("@# save()");
		log.info("@# param=>" + param);

		commentService.save(param);

		HashMap<String, String> boardNo = new HashMap<>();
		boardNo.put("boardNo", param.get("boardNo"));

		BoardDTO b_dto = boardService.contentView(boardNo);

		log.info("b_dto => " + b_dto);
		int mf_no = b_dto.getMf_no();
		int b_no = b_dto.getBoardNo();
		log.info("mf_no => " + mf_no);
		log.info("b_no => " + b_no);

		int userNo = Integer.parseInt(param.get("userNo"));

		// 팔로우 할때 메시지 다시 작성하기
		if (mf_no != userNo) {
			sseService.send(mf_no, userNo + "가 내 게시글에 댓글 작성함");
			notificationService.add_notification(userNo, mf_no, b_no, 3);
		}

		ArrayList<CommentDTO> commentList = commentService.findAll(param);
		return commentList;
	}

	@RequestMapping("/delete")
	@ResponseBody
	public void userCommentDelete(@RequestParam HashMap<String, String> param) {
		log.info("@# userCommentDelete()");
		log.info("@# param=>" + param);

		commentService.userCommentDelete(param);
	}

	@RequestMapping("/list")
	@ResponseBody
	public List<CommentDTO> recommend(@Param("boardNo") int boardNo, HttpSession session) {
		log.info("@# findAll()");
		int mf_no = 0;

		TeamDTO user = (TeamDTO) session.getAttribute("user");

		if (user != null) {
			mf_no = user.getMf_no();
		}

		List<CommentDTO> commentList = commentService.recommended(boardNo, mf_no);

		// 댓글 시간 조정
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("YYYY-MM-dd HH:mm");

		for (CommentDTO dto : commentList) {
			LocalDateTime CommentDTO = dto.getCommentCreatedTime();
			dto.setCommentTime(CommentDTO.format(timeFormatter));
		}
		log.info("@#!@#$" + commentList);

		return commentList;
	}
//	@RequestMapping("/list")
//	@ResponseBody
//	public ArrayList<CommentDTO> findAll(@RequestParam HashMap<String, String> param) {
//		log.info("@# findAll()");
//		log.info("@# param=>" + param);
//
//		ArrayList<CommentDTO> commentList = service.findAll(param);
//
//		// 댓글 시간 조정
//		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("YYYY-MM-dd HH:mm");
//
//		for (CommentDTO dto : commentList) {
//			LocalDateTime CommentDTO = dto.getCommentCreatedTime();
//			dto.setCommentTime(CommentDTO.format(timeFormatter));
//		}
//
//		return commentList;
//	}

	@RequestMapping("/comment_recommend")
	@ResponseBody
	public String comment_recommend(@Param("commentNo") int commentNo, HttpSession session) {
		log.info("@# comment_recommend()");
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		int mf_no = user.getMf_no();
		log.info("commentNo => {} mf_no => {} recommend => {}", commentNo, mf_no);

		int check = commentRecommendService.comment_yn(commentNo, mf_no);

		if (check == 1) {
			commentRecommendService.minus_comment_recommend(commentNo, mf_no);
			log.info("@# 댓글 추천 취소 성공");
			return "cancel";
		} else {
			commentRecommendService.add_comment_recommend(commentNo, mf_no);
			log.info("@# 댓글 추천 성공");
			return "recommend";
		}

	}
}