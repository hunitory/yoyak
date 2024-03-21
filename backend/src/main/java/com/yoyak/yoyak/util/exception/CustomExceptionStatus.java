package com.yoyak.yoyak.util.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomExceptionStatus {
    // user 관련
    WRONG_ID(1001, "잘못된 아이디입니다"),
    WRONG_PW(1002, "잘못된 비밀번호입니다"),

    // alarm 관련
    NOTI_INVALID(6001, "존재하지 않는 알림입니다"),

    // account 관련
    ACCOUNT_INVALID(7001, "존재하지 않는 계정입니다"),

    ARTICLE_INVALID(8001, "존재하지 않는 게시글입니다"),

    CHEER_ALREADY_EXIST(9001, "이미 응원한 게시글입니다");


    //

    private final Integer code;
    private final String message;
}