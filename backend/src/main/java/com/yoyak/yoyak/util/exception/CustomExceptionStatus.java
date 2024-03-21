package com.yoyak.yoyak.util.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomExceptionStatus {
    // user 관련
    USER_INVALID(1001, "존재하지 않는 사용자입니다"),
    LOGIN_WRONG(1002, "아이디 또는 비밀번호가 일치하지 않습니다"),

    // alarm 관련
    NOTI_INVALID(6001, "존재하지 않는 알림입니다"),

    // account 관련
    ACCOUNT_INVALID(7001, "존재하지 않는 계정입니다");


    //

    private final Integer code;
    private final String message;
}