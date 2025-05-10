package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RcCourseDTO {
	private int rc_course_id;
	private int rc_recipe_id;
	private String rc_course_description;
	private String rc_course_img;
}
