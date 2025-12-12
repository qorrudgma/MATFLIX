package com.boot.service;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SseService {

	private static final Long TIMEOUT = 60L * 60 * 1000L; // 1시간 유지
	private final Map<Integer, SseEmitter> emitters = new ConcurrentHashMap<>();

	// 유저가 SSE 채널에 접속할 때 실행
	public SseEmitter subscribe(int mf_no) {
		log.info("접속 함");
		SseEmitter emitter = new SseEmitter(TIMEOUT);

		emitters.put(mf_no, emitter);

		emitter.onCompletion(() -> emitters.remove(mf_no));
		emitter.onTimeout(() -> emitters.remove(mf_no));
		emitter.onError((e) -> emitters.remove(mf_no));

		// 최초 연결 시 메시지 전달
		try {
			emitter.send(SseEmitter.event().name("connect").data("connected"));
		} catch (IOException e) {
			emitters.remove(mf_no);
		}

		return emitter;
	}

	// 특정 유저에게 알림 보내기
	public void send(int mf_no, String message) {
		log.info("mf_no => {}, message => {}", mf_no, message);
		SseEmitter emitter = emitters.get(mf_no);
		if (emitter == null) {
			log.info("mf_no={} 에 대한 활성화된 SSE 연결이 없습니다.", mf_no);
			return;
		}

		try {
			emitter.send(SseEmitter.event().name("alert").data(message));
		} catch (IOException e) {
			emitters.remove(mf_no);
		}
	}
}