package com.yoyak.yoyak.user.controller;

import com.yoyak.yoyak.account.domain.AccountRole;
import com.yoyak.yoyak.account.dto.AccountRegistDto;
import com.yoyak.yoyak.account.service.AccountService;
import com.yoyak.yoyak.user.dto.DupIdRequestDto;
import com.yoyak.yoyak.user.dto.DupNicknameRequestDto;
import com.yoyak.yoyak.user.dto.FindIdRequestDto;
import com.yoyak.yoyak.user.dto.FindIdResponseDto;
import com.yoyak.yoyak.user.dto.FindPwRequestDto;
import com.yoyak.yoyak.user.dto.LoginRequestDto;
import com.yoyak.yoyak.user.dto.SignInRequestDto;
import com.yoyak.yoyak.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final AccountService accountService;

    // 일반 로그인
    @PostMapping("/login/origin")
    public ResponseEntity<String> loginUser(@RequestBody LoginRequestDto loginRequestDto) {
        log.info("loginUser : {}", loginRequestDto);
        String token = userService.login(loginRequestDto);

        return ResponseEntity.ok().body(token);
    }

    // 일반 회원가입
    @PostMapping("/signin")
    public ResponseEntity<Object> signinUser(@RequestBody SignInRequestDto signInRequestDto) {
        Long seq = userService.signIn(signInRequestDto);

        AccountRegistDto accountRegistDto = AccountRegistDto.builder()
            .name(signInRequestDto.getName())
            .nickname(signInRequestDto.getNickname())
            .gender(signInRequestDto.getGender())
            .birth(signInRequestDto.getBirth())
            .disease(null)
            .profileImg(0)
            .build();
        accountService.createAccount(seq, accountRegistDto, AccountRole.ADMIN);

        return ResponseEntity.ok().build();
    }

    // 일반 아이디 찾기
    @PostMapping("/findid")
    public ResponseEntity<FindIdResponseDto> findId(
        @RequestBody FindIdRequestDto findIdRequestDto) {
        FindIdResponseDto findIdResponseDto = userService.findId(findIdRequestDto);

        return ResponseEntity.ok().body(findIdResponseDto);
    }

    // 일반 비밀번호 찾기
    @PostMapping("/findpw")
    public ResponseEntity<Object> findPw(@RequestBody FindPwRequestDto findPwRequestDto) {
        userService.findPw(findPwRequestDto);

        return ResponseEntity.ok().build();
    }

    // 아이디 중복체크
    @PostMapping("/dupid")
    public ResponseEntity<String> dupId(@RequestBody DupIdRequestDto dupIdRequestDto) {
        userService.dupId(dupIdRequestDto);

        return ResponseEntity.ok().build();
    }

    // 닉네임 중복체크
    @PostMapping("/dupnickname")
    public ResponseEntity<Object> dupNickname(
        @RequestBody DupNicknameRequestDto dupNicknameRequestDto) {
        userService.dupNickname(dupNicknameRequestDto);

        return ResponseEntity.ok().build();
    }

    // 회원탈퇴
    @DeleteMapping("/withdraw")
    public ResponseEntity<Object> withdrawUser() {
        userService.withdraw();

        return ResponseEntity.ok().build();
    }
}