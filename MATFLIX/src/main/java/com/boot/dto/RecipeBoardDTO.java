package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeBoardDTO {
	private int rc_boardNo;
	private String rc_boardName;
	private String rc_boardTitle;
	private String rc_boardContent;
	private Timestamp rc_boardDate;
	private int rc_boardHit;
	private int rc_recipe_id;
}
