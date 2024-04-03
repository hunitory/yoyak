package com.yoyak.yoyak.challenge.domain;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;

@SpringBootTest
class ChallengeArticleCustomRepositoryImplTest {

    @Autowired
    private ChallengeArticleRepository challengeArticleRepository;

    @Autowired
    private ChallengeRepository challengeRepository;

    @Test
    public void deleteChallengePerMinuteTest(){
        LocalDate now = LocalDate.now();
        challengeRepository.deleteAfterEndDate(now);
    }

    @Test
    public void findAllArticlesTest(){
        challengeArticleRepository.findAllArticles(1L).forEach(challengeArticleResponseDto -> {
            System.out.println("challengeArticleResponseDto.getArticleSeq() = " + challengeArticleResponseDto.getArticleSeq());

        });
    }

    @Test
    void isCheerTest(){
        Long userSeq = 7L;
        
        challengeArticleRepository.findMyArticles(userSeq).forEach(challengeArticleResponseDto -> {
            System.out.println("challengeArticleResponseDto.getArticleSeq() = " + challengeArticleResponseDto.getArticleSeq());
            System.out.println("challengeArticleResponseDto.isCheered() = " + challengeArticleResponseDto.isCheered());
        });

        challengeArticleRepository.findAllArticles(1L).forEach(challengeArticleResponseDto -> {
            System.out.println("challengeArticleResponseDto.getArticleSeq() = " + challengeArticleResponseDto.getArticleSeq());
            System.out.println("challengeArticleResponseDto.isCheered() = " + challengeArticleResponseDto.isCheered());
        });

        
    }
}