package com.yoyak.yoyak.challenge.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.yoyak.yoyak.challenge.domain.Challenge;
import com.yoyak.yoyak.challenge.domain.ChallengeRepository;

import java.util.List;

import com.yoyak.yoyak.user.domain.UserRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ChallengeArticleServiceTest {
    @Autowired
    private ChallengeArticleService challengeArticleService;

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private UserRepository userRepository;

    @Test
    public void deleteTest(){
        Long userSeq = 1L;

        userRepository.deleteById(userSeq);
    }
}