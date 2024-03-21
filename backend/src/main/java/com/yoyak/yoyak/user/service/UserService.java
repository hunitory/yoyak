package com.yoyak.yoyak.user.service;

import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.domain.UserPlatform;
import com.yoyak.yoyak.user.domain.UserRepository;
import com.yoyak.yoyak.user.domain.UserRole;
import com.yoyak.yoyak.user.dto.DupIdRequestDto;
import com.yoyak.yoyak.user.dto.DupNicknameRequestDto;
import com.yoyak.yoyak.user.dto.FindIdRequestDto;
import com.yoyak.yoyak.user.dto.FindIdResponseDto;
import com.yoyak.yoyak.user.dto.FindPwRequestDto;
import com.yoyak.yoyak.user.dto.LoginRequestDto;
import com.yoyak.yoyak.user.dto.SignInRequestDto;
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
            .build();

        return jwtUtil.createAccessToken(userInfoDto);
    }

    // 일반 회원가입
    public void signIn(SignInRequestDto signInRequestDto) {
        User user = User.builder()
            .userId(signInRequestDto.getUserId())
            .password(signInRequestDto.getPassword())
            .name(signInRequestDto.getName())
            .nickname(signInRequestDto.getNickname())
            .gender(signInRequestDto.getGender())
            .birth(signInRequestDto.getBirth())
            .platform(UserPlatform.ORIGIN)
            .role(UserRole.USER)
            .build();

        userRepository.save(user);
    }

    // 일반 아이디 찾기
    public FindIdResponseDto findId(FindIdRequestDto findIdRequestDto) {
        String id = userRepository.findByNameAndBirth(findIdRequestDto.getName(),
                findIdRequestDto.getBirth())
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.USER_NOTFOUND));

        return FindIdResponseDto.builder().userId(id).build();
    }

    // 일반 비밀번호 찾기
    public void findPw(FindPwRequestDto findPwRequestDto) {
        User user = userRepository.findByIdAndName(findPwRequestDto.getUserId(),
                findPwRequestDto.getName())
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.USER_NOTFOUND));

        user.setPassword("yoyak123!!");
    }

    // 아이디 중복체크
    public void dupId(DupIdRequestDto dupIdRequestDto) {
        userRepository.findByUserId(dupIdRequestDto.getUserId())
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.ID_AVAILABLE));

        throw new CustomException(CustomExceptionStatus.ID_DUPLICATION);
    }

    // 닉네임 중복체크
    public void dupNickname(DupNicknameRequestDto dupNicknameRequestDto) {
        userRepository.findByNickname(dupNicknameRequestDto.getNickname())
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.NICKNAME_AVAILABLE));

        throw new CustomException(CustomExceptionStatus.NICKNAME_DUPLICATION);
    }

    public User findById(Long seq) {
        return userRepository.findById(seq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.USER_INVALID));
    }
}
