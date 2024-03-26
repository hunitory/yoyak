package com.yoyak.yoyak.challenge.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.yoyak.yoyak.challenge.domain.*;

import java.util.List;

import com.yoyak.yoyak.challenge.dto.CheerRequestDto;
import com.yoyak.yoyak.user.domain.UserRepository;
import com.yoyak.yoyak.user.service.UserService;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
class ChallengeArticleServiceTest {


    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EntityManager em;

    @Autowired
    private  CheerService cheerService;

    @Autowired
    private ChallengeArticleRepository challengeArticleRepository;

    @Autowired
    private CheerRepository cheerRepository;

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private UserService userService;



    @Test
    public void deleteTest(){
        Long userSeq = 1L;

        userRepository.deleteById(userSeq);
    }

    @Test
    public void cheerUpTest(){


        ChallengeArticle article = challengeArticleRepository.findById(1L).get();

        assertThat(article.getCheers().size()).isEqualTo(3);

    }

    @Test
    @DisplayName("챌린지 글 삭제 시 응원도 삭제")
    @Transactional
    public void articleDeleteTest(){
        Long articleSeq = 1L;


    }

    @Test
    @DisplayName("챌린지 삭제 시 챌린지 글과 응원도 삭제")
    @Transactional
    public void challengeDeleteTest(){

    }

    @Test
    @DisplayName("유저 삭제 시 챌린지, 챌린지 글, 응원 삭제")
//    @Transactional
    public void userDeleteTest(){


        CheerRequestDto dto = CheerRequestDto.builder()
                .challengeArticleSeq(1L)
                .userSeq(2L)
                .build();
        cheerService.addCheer(dto);

        dto = CheerRequestDto.builder()
                .challengeArticleSeq(1L)
                .userSeq(3L)
                .build();

        cheerService.addCheer(dto);

        Long articleSeq = 1L;
        ChallengeArticle article = challengeArticleRepository.findById(articleSeq).get();
        System.out.println("article.getCheers().size() = " + article.getCheers().size());

////        em.flush();
////        em.clear();
//        // 2번 유저가 삭제되면 2번 유저의 챌린지, 챌린지 글, 응원도 삭제
        Long userSeq = 2L;
        userService.withdraw(userSeq);

        article = challengeArticleRepository.findById(articleSeq).get();

        // challengeArticle 1의 응원이 줄어들어야함
        System.out.println("article.getCheers().size() = " + article.getCheers().size());



    }
}