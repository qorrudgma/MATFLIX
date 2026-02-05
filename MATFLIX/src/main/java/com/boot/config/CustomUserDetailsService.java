package com.boot.config;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.boot.dao.TeamDAO;
import com.boot.dto.TeamDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

	private final TeamDAO teamDAO;

	@Override
	public UserDetails loadUserByUsername(String mf_id) throws UsernameNotFoundException {

		TeamDTO user = teamDAO.find_list(mf_id);

		if (user == null) {
			throw new UsernameNotFoundException("존재하지 않는 사용자");
		}

		return new CustomUserDetails(user);
	}
}
