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
    SIGNUP_NEEDED(1008, "카카오 회원가입이 필요합니다"),


    // medicine 검색 관련
    MEDICINE_NOT_FOUND(4001, "검색된 결과가 없습니다"),
    MEDICINE_NOT_EXIST(4002, "존재하지 않는 약입니다."),
    MEDICINE_NO_RECOGNITION(4003, "약을 인식할 수 없습니다"),

    // medicine 저장 관련
    ENVELOP_NOT_EXIST(5001, "존재하지 않는 약 봉투입니다."),
    ENVELOP_AUTHORITY(5002, "접근할 수 없는 약 봉투입니다."),
    ENVELOP_INVALID_REQUEST(5003, "요청값을 확인하세요"),

    // alarm 관련
    NOTI_INVALID(6001, "존재하지 않는 알림입니다"),
    NOTI_AUTHORITY(6002, "알림에 접근할 수 없습니다"),

    // account 관련
    ACCOUNT_INVALID(7001, "존재하지 않는 계정입니다"),
    ACCOUNT_MAXIMUM(7002, "계정을 더 이상 생성할 수 없습니다"),
    ACCOUNT_AUTHORITY(7003, "계정에 접근할 수 없습니다"),


    ARTICLE_INVALID(8001, "존재하지 않는 챌린지 글입니다"),
    CHEER_ALREADY_EXIST(8002, "이미 응원한 챌린지 글입니다"),
    NO_CHALLENGE(8003, "존재하지 않는 챌린지입니다"),
    FAILED_IMAGE_UPLOAD(8004, "이미지 업로드에 실패했습니다"),
    THERE_IS_NO_CHALLENGE(8005, "등록한 챌린지가 없습니다"),
    INVALID_CHALLENGE_REQUEST(8006, "잘못된 않는 챌린지 요청입니다"),
    ALREADY_POST(8007, "오늘의 챌린지를 이미 등록했습니다"),

    // security 관련
    NO_AUTHENTICATION(9001, "No authentication information"),

    // firebase 관련
    NO_FIREBASE_APP(10001, "FirebaseApp이 존재하지 않습니다");

    private final Integer code;
    private final String message;
}