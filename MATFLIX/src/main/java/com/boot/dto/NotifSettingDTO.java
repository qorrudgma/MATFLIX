package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotifSettingDTO {
	private int notif_id;
	private int mf_no;
	private String notif_type;
	private int yn;
}