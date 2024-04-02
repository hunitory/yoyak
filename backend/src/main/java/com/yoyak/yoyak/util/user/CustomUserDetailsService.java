package com.yoyak.yoyak.util.user;

import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.domain.UserRepository;
import com.yoyak.yoyak.util.dto.UserInfoDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String userSeq) throws UsernameNotFoundException {
        User user = userRepository.findById(Long.parseLong(userSeq))
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.USER_INVALID));

        UserInfoDto userInfoDto = UserInfoDto.builder()
            .userSeq(user.getSeq())
            .userId(user.getUserId())
            .password(user.getPassword())
            .name(user.getName())
            .nickname(user.getNickname())
            .gender(user.getGender())
            .birth(user.getBirth())
            .platform(user.getPlatform())
            .role(user.getRole())
            .build();

        return new CustomUserDetails(userInfoDto);
    }
}
