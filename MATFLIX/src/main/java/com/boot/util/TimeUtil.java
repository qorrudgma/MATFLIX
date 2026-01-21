package com.boot.util;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TimeUtil {
	private TimeUtil() {
	}

	/* LocalDateTime → "방금 전 / n분 전 / n시간 전 / n일 전 / n개월 전 / n년 전" */
	public static String timeAgo(LocalDateTime time) {

		if (time == null) {
			return "";
		}

		LocalDateTime now = LocalDateTime.now();
		Duration duration = Duration.between(time, now);

		long seconds = duration.getSeconds();

		if (seconds < 0) {
			return "방금 전";
		}
		if (seconds < 60) {
			return "방금 전";
		}

		long minutes = seconds / 60;
		if (minutes < 60) {
			return minutes + "분 전";
		}

		long hours = minutes / 60;
		if (hours < 24) {
			return hours + "시간 전";
		}

		long days = hours / 24;
		if (days < 30) {
			return days + "일 전";
		}

		long months = days / 30;
		if (months < 12) {
			return months + "개월 전";
		}

		long years = months / 12;
		return years + "년 전";
	}

	/* LocalDateTime => "yyyy-MM-dd" */
	public static String formatDate(LocalDateTime time) {

		if (time == null) {
			return "";
		}

		return time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}

	/* LocalDateTime => "yyyy-MM-dd HH:mm" */
	public static String formatDateTime(LocalDateTime time) {

		if (time == null) {
			return "";
		}

		return time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
	}
}