package com.yoyak.yoyak.user.controller;

import com.yoyak.yoyak.user.dto.LoginRequestDto;
import com.yoyak.yoyak.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = "*")
public class UserController {

    private final UserService userService;

    // 일반 로그인
    @PostMapping("/login/origin")
    public ResponseEntity<String> loginUser(@RequestBody LoginRequestDto loginRequestDto) {
        log.info("loginUser : {}", loginRequestDto);
        String token = userService.login(loginRequestDto);

        return ResponseEntity.ok().body(token);
    }
}
