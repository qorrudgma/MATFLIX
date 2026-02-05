package com.boot.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AdminUserSearchDTO {
	private int pageSize = 2;
	private int page = 1;
	private String type;
	private String keyword;

	public int getOffset() {
		return (page - 1) * pageSize;
	}
}