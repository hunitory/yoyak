package com.yoyak.yoyak.challenge.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@AllArgsConstructor
@Builder
@Setter
@ToString
public class CheerRequestDto {
    private Long userSeq;
    private Long challengeArticleSeq;
}
