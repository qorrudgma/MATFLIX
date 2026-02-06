package com.boot.util;

import java.util.HashMap;
import java.util.Map;

public class CategoryUtil {

	private static final Map<String, String> categoryMap = new HashMap<>();

	static {
		categoryMap.put("KOREAN", "한식");
		categoryMap.put("CHINESE", "중식");
		categoryMap.put("JAPANESE", "일식");
		categoryMap.put("WESTERN", "양식");
		categoryMap.put("DESSERT", "디저트");
	}

	public static String toKorean(String category) {
		if (category == null) {
			return "";
		}
		// 대소문자 구분 없이 매칭되도록 대문자로 변환 후 조회
		return categoryMap.getOrDefault(category.toUpperCase(), category);
	}
}