package com.yoyak.yoyak.util.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Builder
@Getter
@Setter
@ToString
@AllArgsConstructor
public class ErrorResponseDto {

    int httpStatus;
    String message;
    LocalDateTime dateTime;
}
