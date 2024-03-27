package com.yoyak.yoyak.challenge.domain;

import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static com.yoyak.yoyak.challenge.domain.QChallenge.challenge;
import static com.yoyak.yoyak.challenge.domain.QChallengeArticle.challengeArticle;
import static com.yoyak.yoyak.challenge.domain.QCheer.cheer;

public class ChallengeCustomRepositoryImpl implements ChallengeCustomRepository{

    private final JPAQueryFactory queryFactory;

    public ChallengeCustomRepositoryImpl(EntityManager em){
        this.queryFactory = new JPAQueryFactory(em);
    }

    @Override
    @Transactional
    public void deleteAllConnectionByUserSeq(Long userSeq) {
        List<Challenge> challenges = queryFactory.selectFrom(challenge)
            .where(challenge.user.seq.eq(userSeq))
            .fetch();

        challenges.forEach(challenge->{
            queryFactory.selectFrom(challengeArticle)
                    .where(challengeArticle.challenge.seq.eq(challenge.getSeq()))
                    .fetch()
                    .forEach(challengeArticle->{
                        queryFactory.delete(cheer)
                                .where(cheer.challengeArticle.seq.eq(challengeArticle.getSeq()))
                                .execute();
                        queryFactory.delete(cheer)
                                .where(cheer.user.seq.eq(userSeq))
                                .execute();

                        QChallengeArticle article1 = new QChallengeArticle("article1");
                        queryFactory.delete(article1)
                                .where(article1.seq.eq(challengeArticle.getSeq()))
                                .execute();
                    });

            QChallenge challenge1 = new QChallenge("challenge1");
            queryFactory.delete(challenge1)
                    .where(challenge1.seq.eq(challenge.getSeq()))
                    .execute();

        });
    }
}
