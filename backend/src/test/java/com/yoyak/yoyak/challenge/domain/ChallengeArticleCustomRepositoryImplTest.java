package com.yoyak.yoyak.challenge.domain;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ChallengeArticleCustomRepositoryImplTest {

    @Autowired
    private ChallengeArticleRepository challengeArticleRepository;
    
    @Test
    void isCheerTest(){
        Long userSeq = 7L;
        
        challengeArticleRepository.findMyArticles(userSeq).forEach(challengeArticleResponseDto -> {
            System.out.println("challengeArticleResponseDto.getArticleSeq() = " + challengeArticleResponseDto.getArticleSeq());
            System.out.println("challengeArticleResponseDto.isCheered() = " + challengeArticleResponseDto.isCheered());
        });

        challengeArticleRepository.findArticlesExceptUserSeq(userSeq).forEach(challengeArticleResponseDto -> {
            System.out.println("challengeArticleResponseDto.getArticleSeq() = " + challengeArticleResponseDto.getArticleSeq());
            System.out.println("challengeArticleResponseDto.isCheered() = " + challengeArticleResponseDto.isCheered());
        });

        
    }
}