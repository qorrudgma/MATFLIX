package com.boot.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class FrontController {

	@RequestMapping("/")
	public String main(@RequestParam HashMap<String, String> param, Model model) {
		System.out.println(model);
		if (param != null) {
			model.addAttribute("model", model);
		}
		return "front/index";
	}

	@RequestMapping("/front/content_main")
	public String content_main() {
		return "front/content_main";
	}

	@RequestMapping("/front/recipe_write")
	public String recipe_write() {
		return "front/recipe_write";
	}
}