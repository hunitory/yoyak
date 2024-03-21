package com.yoyak.yoyak.util.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomExceptionStatus {
    // user 관련
    USER_INVALID(1001, "존재하지 않는 사용자입니다"),
    LOGIN_WRONG(1002, "아이디 또는 비밀번호가 일치하지 않습니다"),
    ID_DUPLICATION(1003, "아이디가 중복입니다"),
    ID_AVAILABLE(1004, "아이디를 사용할 수 있습니다"),
    NICKNAME_DUPLICATION(1005, "닉네임이 중복입니다"),
    NICKNAME_AVAILABLE(1006, "닉네임을 사용할 수 있습니다"),
    USER_NOTFOUND(1007, "일치하는 사용자를 찾을 수 없습니다"),

    // alarm 관련
    NOTI_INVALID(6001, "존재하지 않는 알림입니다"),

    // account 관련
    ACCOUNT_INVALID(7001, "존재하지 않는 계정입니다"),

    // security 관련
    NO_AUTHENTICATION(9001, "No authentication information");

    private final Integer code;
    private final String message;
}