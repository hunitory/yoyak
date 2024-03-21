package com.yoyak.yoyak.challenge.domain;

import static org.junit.jupiter.api.Assertions.*;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ChallengeArticleCustomRepositoryImplTest {
    @Autowired
    private EntityManager em;
//
    @Autowired
    private ChallengeArticleRepository challengeArticleRepsoitory;

    @Test
    public void excpetUserSeqTest(){
        challengeArticleRepsoitory.findArticlesExceptUserSeq(1L).forEach(System.out::println);
    }
}