package com.yoyak.yoyak.challenge.dto;

import com.querydsl.core.annotations.QueryProjection;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor

public class ChallengeArticleResponseDto {
    private Long seq;
    private Long challengeSeq;
    private String imgUrl;
    private String content;
    private int cheer;

    private String userNickname;
    private Long userSeq;

}