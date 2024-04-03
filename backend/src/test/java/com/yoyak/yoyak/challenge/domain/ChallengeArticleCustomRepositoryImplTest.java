package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

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
    public void findExceptUserSeq(){
        Long userSeq = 7L;
        List<ChallengeArticleResponseDto> list =  challengeArticleRepository.findAllArticlesExceptUserSeq(userSeq);
        assertThat(list.size()).isEqualTo(28);

    }

    @Test
    public void findAllArticlesTest(){
        challengeArticleRepository.findAllArticlesExceptUserSeq(1L).forEach(challengeArticleResponseDto -> {
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

        challengeArticleRepository.findAllArticlesExceptUserSeq(1L).forEach(challengeArticleResponseDto -> {
            System.out.println("challengeArticleResponseDto.getArticleSeq() = " + challengeArticleResponseDto.getArticleSeq());
            System.out.println("challengeArticleResponseDto.isCheered() = " + challengeArticleResponseDto.isCheered());
        });

        
    }
}