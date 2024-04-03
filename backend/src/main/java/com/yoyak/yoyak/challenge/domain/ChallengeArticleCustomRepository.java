package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;

import java.time.LocalDate;
import java.util.List;

public interface ChallengeArticleCustomRepository {
    List<ChallengeArticleResponseDto> findAllArticles(Long userSeq);

    List<ChallengeArticleResponseDto> findMyArticles(Long userSeq);

    boolean existsBySameCreateDateAndSameUser(LocalDate createDate, Long userSeq);

}
