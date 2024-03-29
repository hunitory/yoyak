package com.yoyak.yoyak.challenge.dto;

import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@Builder
@ToString
public class ChallengeResponseDto {
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private int day;
    private int articleSize;
}
