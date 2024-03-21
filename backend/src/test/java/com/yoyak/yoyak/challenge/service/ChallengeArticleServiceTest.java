package com.yoyak.yoyak.challenge.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

import com.yoyak.yoyak.challenge.domain.ChallengeArticle;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ChallengeArticleServiceTest {
    @Autowired
    private ChallengeArticleService challengeArticleService;
    @Test
    public void getArticleTest(){
//        List<ChallengeArticleResponseDto> challengeArticles = challengeArticleService.getArticles();
//        assertThat(challengeArticles.size()).isEqualTo(1);
    }

    @Test
    public void getMyArticleTest(){
        challengeArticleService.getMyChallengeArticles(1L).forEach(System.out::println);

    }
}