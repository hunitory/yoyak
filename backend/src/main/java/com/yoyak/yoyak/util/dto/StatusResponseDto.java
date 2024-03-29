package com.yoyak.yoyak.util.dto;

import lombok.*;

@Builder
@Getter
@Setter
@ToString
@AllArgsConstructor
public class StatusResponseDto {
    private int code;
    private String message;
}
