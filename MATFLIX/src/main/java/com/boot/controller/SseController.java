package com.boot.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.boot.service.SseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@RequestMapping("/sse")
@Slf4j
public class SseController {

	private final SseService sseService;

	// 유저별 SSE 구독
	@GetMapping("/subscribe/{mf_no}")
	public SseEmitter subscribe(@PathVariable int mf_no) {
		log.info("SSE SUBSCRIBE mf_no = {}", mf_no);
		return sseService.subscribe(mf_no);
	}
}