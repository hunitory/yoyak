package com.yoyak.yoyak.challenge.domain;

import static com.yoyak.yoyak.challenge.domain.QChallengeArticle.challengeArticle;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;


@Slf4j
public class ChallengeArticleCustomRepositoryImpl implements ChallengeArticleCustomRepository {

    private final JPAQueryFactory queryFactory;

    public ChallengeArticleCustomRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    // 추후에 n+1 문제 고려해서 수정할 것
    @Override
    public List<ChallengeArticleResponseDto> findArticlesExceptUserSeq(Long userSeq) {
        List<ChallengeArticle> articles = queryFactory.select(challengeArticle)
            .from(challengeArticle)
            .where(challengeArticle.user.seq.ne(userSeq))
            .fetch();

        List<ChallengeArticleResponseDto> responseDtos = articles.stream().map((article) -> {
            int cheerCnt = article.getCheers().size();

            ChallengeArticleResponseDto responseDto = ChallengeArticleResponseDto.builder()
                .articleSeq(article.getSeq())
                .challengeSeq(article.getChallenge().getSeq())
                .imgUrl(article.getImgUrl())
                .content(article.getContent())
                .userNickname(article.getUser().getNickname())
                .userSeq(article.getUser().getSeq())
                .cheerCnt(cheerCnt)
                .build();

            return responseDto;
        }).collect(Collectors.toList());

        return responseDtos;

    }

    @Override
    public List<ChallengeArticleResponseDto> findMyArticles(Long userSeq) {

        List<ChallengeArticle> articles = queryFactory.select(challengeArticle)
            .from(challengeArticle)
            .where(challengeArticle.user.seq.eq(userSeq))
            .fetch();

        return articles.stream().map((article) -> {
            int cheerCnt = article.getCheers().size();

            ChallengeArticleResponseDto responseDto = ChallengeArticleResponseDto.builder()
                .articleSeq(article.getSeq())
                .challengeSeq(article.getChallenge().getSeq())
                .imgUrl(article.getImgUrl())
                .content(article.getContent())
                .userNickname(article.getUser().getNickname())
                .userSeq(article.getUser().getSeq())
                .cheerCnt(cheerCnt)
                .build();

            return responseDto;
        }).collect(Collectors.toList());

    }
}
