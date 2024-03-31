package com.yoyak.yoyak.challenge.domain;

import static com.yoyak.yoyak.challenge.domain.QChallenge.challenge;
import static com.yoyak.yoyak.challenge.domain.QChallengeArticle.challengeArticle;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import jakarta.persistence.EntityManager;

import java.time.LocalDate;
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
        return makeChallengeArticleResponseDto(challenges, userSeq);


    }

    @Override
    @Transactional
    public List<ChallengeArticleResponseDto> findMyArticles(Long userSeq) {
        List<Challenge> challenges = queryFactory.select(challenge)
            .from(challenge)
            .where(challenge.user.seq.eq(userSeq))
            .fetch();
        return makeChallengeArticleResponseDto(challenges, userSeq);

    }

    @Override
    public boolean existsBySameCreateDateAndSameUser(LocalDate createDate, Long userSeq) {

         List<ChallengeArticle> articles = queryFactory.select(challengeArticle)
            .from(challengeArticle)
            .where(challengeArticle.createdDate.eq(createDate)
                .and(challengeArticle.userSeq.eq(userSeq)))
            .fetch();

         return !(articles.isEmpty() || articles == null);
    }


    private List<ChallengeArticleResponseDto> makeChallengeArticleResponseDto(List<Challenge> challenges, Long userSeq){
        List<ChallengeArticleResponseDto> ret = new ArrayList<>();

        for(Challenge challenge1 : challenges){
            List<ChallengeArticle> articles = queryFactory.select(challengeArticle)
                .from(challengeArticle)
                .where(challengeArticle.challenge.seq.eq(challenge1.getSeq()))
                .fetch();

            for(ChallengeArticle article : articles){
                int cheerCnt = 0;
                boolean isCheered = false;
                
                if (article.getCheers() != null) {
                    cheerCnt = article.getCheers().size();
                    for(Cheer cheer: article.getCheers()){
                        if(cheer.getUser().getSeq() == userSeq){
                            isCheered = true;
                            break;
                        }
                    }
                }


                ret.add(ChallengeArticleResponseDto.builder()
                    .articleSeq(article.getSeq())
                    .challengeSeq(article.getChallenge().getSeq())
                    .imgUrl(article.getImgUrl())
                    .title(article.getContent())
                    .userNickname(challenge1.getUser().getNickname())
                    .userSeq(challenge1.getUser().getSeq())
                    .cheerCnt(cheerCnt)
                    .isCheered(isCheered)
                    .createdDate(article.getCreatedDate())
                    .build());
            }
        }



        return ret;
    }


}
