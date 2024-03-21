package com.yoyak.yoyak.challenge.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@AllArgsConstructor
@Builder
@Setter
public class CheerRequestDto {
    private Long userSeq;
    private Long challengeArticleSeq;
}
