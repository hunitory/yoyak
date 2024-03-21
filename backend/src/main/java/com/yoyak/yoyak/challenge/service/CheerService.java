package com.yoyak.yoyak.challenge.service;


import com.yoyak.yoyak.challenge.domain.ChallengeArticle;
import com.yoyak.yoyak.challenge.domain.ChallengeArticleRepository;
import com.yoyak.yoyak.challenge.domain.CheerRepository;
import com.yoyak.yoyak.user.domain.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CheerService {
    private final CheerRepository cheerRepository;
    private final ChallengeArticleRepository challengeArticleRepository;
    private final UserRepository userRepository;

    public void addCheer(Long userSeq, Long challengeArticleSeq){
        ChallengeArticle challengeArticle = challengeArticleRepository.findById(challengeArticleSeq).orElseThrow();
    }


}
