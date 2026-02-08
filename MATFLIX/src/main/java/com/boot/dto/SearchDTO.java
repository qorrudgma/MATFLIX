package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SearchDTO {
	private int pageSize = 10;
	private int page = 1;
	private String type;
	private String keyword;

	public int getOffset() {
		return (page - 1) * pageSize;
	}
}