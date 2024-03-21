package com.yoyak.yoyak.challenge.domain;

import static com.yoyak.yoyak.challenge.domain.QChallengeArticle.challengeArticle;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import jakarta.persistence.EntityManager;
import java.util.List;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;


@Slf4j
@RequiredArgsConstructor
public class ChallengeArticleCustomRepositoryImpl implements ChallengeArticleCustomRepository {

    private final JPAQueryFactory queryFactory;

    public ChallengeArticleCustomRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    @Override
    public List<ChallengeArticleResponseDto> findArticlesExceptUserSeq(Long userSeq) {
        return queryFactory.select(Projections.bean(ChallengeArticleResponseDto.class,
              challengeArticle.seq,
              challengeArticle.challenge.seq,
              challengeArticle.imgUrl,
              challengeArticle.content,
                challengeArticle.user.seq,
                challengeArticle.user.nickname
              ))
              .from(challengeArticle)
                .where(challengeArticle.user.seq.ne(userSeq))
              .fetch();

    }
}
