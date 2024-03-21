package com.yoyak.yoyak.user.service;

import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.domain.UserRepository;
import com.yoyak.yoyak.user.dto.LoginRequestDto;
import com.yoyak.yoyak.util.dto.UserInfoDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import com.yoyak.yoyak.util.jwt.JwtUtil;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    // 일반 로그인
    public String login(LoginRequestDto loginRequestDto) {
        User user = userRepository.findByUserId(loginRequestDto.getUserId())
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.LOGIN_WRONG));

        if (!user.getPassword().equals(loginRequestDto.getPassword())) {
            throw new CustomException(CustomExceptionStatus.LOGIN_WRONG);
        }

        UserInfoDto userInfoDto = UserInfoDto.builder()
            .userSeq(user.getSeq())
            .userId(user.getUserId())
            .name(user.getName())
            .nickname(user.getNickname())
            .gender(user.getGender())
            .birth(user.getBirth())
            .platform(user.getPlatform())
            .build();

        return jwtUtil.createAccessToken(userInfoDto);
    }

    public User findById(Long seq) {
        return userRepository.findById(seq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.USER_INVALID));
    }
}
