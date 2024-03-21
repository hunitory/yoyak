package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import java.util.List;

public interface ChallengeArticleCustomRepository {
    List<ChallengeArticleResponseDto> findArticlesExceptUserSeq(Long userSeq);

}
