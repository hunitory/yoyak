package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import java.util.List;
import java.util.Optional;

public interface ChallengeArticleCustomRepository {
    List<ChallengeArticleResponseDto> findArticlesExceptUserSeq(Long userSeq);

    List<ChallengeArticleResponseDto> findMyArticles(Long userSeq);

}
