package com.yoyak.yoyak.challenge.domain;

import static com.yoyak.yoyak.challenge.domain.QChallengeArticle.challengeArticle;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import com.yoyak.yoyak.user.domain.QUser;
import com.yoyak.yoyak.user.domain.User;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Slf4j
public class ChallengeArticleCustomRepositoryImpl implements ChallengeArticleCustomRepository {

    private final JPAQueryFactory queryFactory;

    public ChallengeArticleCustomRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    // n+1 문제 고려
    @Override
    public List<ChallengeArticleResponseDto> findArticlesExceptUserSeq(Long userSeq) {

        return queryFactory.select(Projections.fields(ChallengeArticleResponseDto.class,
              challengeArticle.seq,
              challengeArticle.challenge.seq.as("challengeSeq"),
              challengeArticle.imgUrl,
              challengeArticle.content,
                challengeArticle.user.seq.as("userSeq"),
                challengeArticle.user.nickname.as("userNickname")
              ))
              .from(challengeArticle)
                .where(challengeArticle.user.seq.ne(userSeq))
              .fetch();

    }

    @Override
    public List<ChallengeArticleResponseDto> findMyArticles(Long userSeq) {
        return queryFactory.select(Projections.fields(ChallengeArticleResponseDto.class,
            challengeArticle.seq,
            challengeArticle.challenge.seq.as("challengeSeq"),
            challengeArticle.imgUrl,
            challengeArticle.content,
            challengeArticle.user.seq.as("userSeq"),
            challengeArticle.user.nickname.as("userNickname")
        ))
            .from(challengeArticle)
            .where(challengeArticle.user.seq.eq(userSeq))
            .fetch();
    }
}
