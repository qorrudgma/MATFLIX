package com.boot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("EmailService")
public class EmailServiceImpl implements EmailService {
	@Autowired
	private JavaMailSender mailSender;

	@Override
	public String sendEmail(String mf_email) {
		log.info("sendEmail() 도착");
		String code = randomCode(); // 인증번호 생성
		log.info(code);

		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(mf_email); // 받는 사람
		message.setSubject("이메일 인증번호"); // 제목
		message.setText("인증번호는 " + code + "입니다."); // 본문
		message.setFrom("matflix_owner@naver.com"); // 보내는 사람 (application.properties와 같아야 안전)
		log.info(message + "");

		mailSender.send(message);
		log.info("메일 보냄");

		return code;
	}

	private String randomCode() {
		log.info("randomCode() 도착");

		return String.valueOf((int) (Math.random() * 900000) + 100000); // 6자리 숫자
	}

	// 팔로우 리스트 메일 보내기
	@Override
	public void follower_list(String following_name, String follower_email) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(follower_email);
		message.setSubject(following_name + "님이 새로운 게시글을 작성 하였습니다.");
		message.setText("팔로우 하신" + following_name + "님이 새로운 게시글을 작성하였습니다.");
		message.setFrom("matflix_owner@naver.com");

		mailSender.send(message);
	}
}