package com.yoyak.yoyak.challenge.domain;

import static com.yoyak.yoyak.challenge.domain.QChallenge.challenge;
import static com.yoyak.yoyak.challenge.domain.QChallengeArticle.challengeArticle;
import static com.yoyak.yoyak.user.domain.QUser.*;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import com.yoyak.yoyak.user.domain.QUser;
import com.yoyak.yoyak.user.domain.User;
import jakarta.persistence.EntityManager;

import java.sql.Array;
import java.util.ArrayList;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;


@Slf4j
public class ChallengeArticleCustomRepositoryImpl implements ChallengeArticleCustomRepository {

    private final JPAQueryFactory queryFactory;

    public ChallengeArticleCustomRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }

    // 추후에 n+1 문제 고려해서 수정할 것
    @Override
    @Transactional
    public List<ChallengeArticleResponseDto> findArticlesExceptUserSeq(Long userSeq) {
        List<Challenge> challenges = queryFactory.select(challenge)
                                    .from(challenge)
                                    .where(challenge.user.seq.ne(userSeq))
                                    .fetch();
        List<ChallengeArticleResponseDto> ret = new ArrayList<>();

        challenges.forEach(challenge->{
            queryFactory.select(challengeArticle)
                    .from(challengeArticle)
                    .where(challengeArticle.challenge.seq.eq(challenge.getSeq()))
                    .fetch()
                    .forEach(article->{
                        int cheerCnt = 0;
                        if(article.getCheers() != null)
                            cheerCnt = article.getCheers().size();

                        ret.add(ChallengeArticleResponseDto.builder()
                                .articleSeq(article.getSeq())
                                .challengeSeq(article.getChallenge().getSeq())
                                .imgUrl(article.getImgUrl())
                                .content(article.getContent())
                                .userNickname(challenge.getUser().getNickname())
                                .userSeq(challenge.getUser().getSeq())
                                .cheerCnt(cheerCnt)
                                .build());
                    });
        });

        return ret;

//        List<ChallengeArticle> articles = queryFactory.select(challengeArticle)
//            .from(challengeArticle)
//            .where(challengeArticle.user.seq.ne(userSeq))
//            .fetch();
//
//
//
//
//        return articles.stream().map(article -> {
//            int cheerCnt = article.getCheers().size();
//
//            return ChallengeArticleResponseDto.builder()
//                .articleSeq(article.getSeq())
//                .challengeSeq(article.getChallenge().getSeq())
//                .imgUrl(article.getImgUrl())
//                .content(article.getContent())
//                .userNickname(article.getChallenge().getUser().getNickname())
//                .userSeq(article.getChallenge().getUser().getSeq())
//                .cheerCnt(cheerCnt)
//                .build();
//
//        }).toList();

    }

    @Override
    @Transactional
    public List<ChallengeArticleResponseDto> findMyArticles(Long userSeq) {
        List<Challenge> challenges = queryFactory.select(challenge)
                .from(challenge)
                .where(challenge.user.seq.eq(userSeq))
                .fetch();
        List<ChallengeArticleResponseDto> ret = new ArrayList<>();

        challenges.forEach(challenge->{
            queryFactory.select(challengeArticle)
                    .from(challengeArticle)
                    .where(challengeArticle.challenge.seq.eq(challenge.getSeq()))
                    .fetch()
                    .forEach(article->{
                        int cheerCnt = article.getCheers().size();
                        ret.add(ChallengeArticleResponseDto.builder()
                                .articleSeq(article.getSeq())
                                .challengeSeq(article.getChallenge().getSeq())
                                .imgUrl(article.getImgUrl())
                                .content(article.getContent())
                                .userNickname(challenge.getUser().getNickname())
                                .userSeq(challenge.getUser().getSeq())
                                .cheerCnt(cheerCnt)
                                .build());
                    });
        });

        return ret;

//        List<ChallengeArticle> articles = queryFactory.select(challengeArticle)
//            .from(challengeArticle)
//            .where(challengeArticle.user.seq.eq(userSeq))
//            .fetch();
//
//        return articles.stream().map(article -> {
//            int cheerCnt = article.getCheers().size();
//
//            return ChallengeArticleResponseDto.builder()
//                .articleSeq(article.getSeq())
//                .challengeSeq(article.getChallenge().getSeq())
//                .imgUrl(article.getImgUrl())
//                .content(article.getContent())
//                .userNickname(article.getChallenge().getUser().getNickname())
//                .userSeq(article.getChallenge().getUser().getSeq())
//                .cheerCnt(cheerCnt)
//                .build();
//
//        }).toList();

    }
}
