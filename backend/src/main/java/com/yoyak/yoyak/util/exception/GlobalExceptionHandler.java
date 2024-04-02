package com.yoyak.yoyak.util.exception;

import com.yoyak.yoyak.util.dto.StatusResponseDto;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.http.ResponseEntity;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<StatusResponseDto> handleUserNameNotFoundException(CustomException exception) {
        StatusResponseDto commonResponse = StatusResponseDto.builder()
                .code(exception.getStatus().getCode())
                .message(exception.getStatus().getMessage())
                .build();

        return ResponseEntity.badRequest()
                .body(commonResponse);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Object> handleRuntimeException(RuntimeException exception) {
        StatusResponseDto commonResponse = StatusResponseDto.builder()
                .code(9999)
                .message(exception.getMessage())
                .build();

        return ResponseEntity.badRequest()
                .body(commonResponse);
    }
}