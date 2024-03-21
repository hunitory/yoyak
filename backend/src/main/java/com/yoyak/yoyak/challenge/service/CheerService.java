package com.yoyak.yoyak.challenge.service;


import com.yoyak.yoyak.challenge.domain.ChallengeArticle;
import com.yoyak.yoyak.challenge.domain.ChallengeArticleRepository;
import com.yoyak.yoyak.challenge.domain.Cheer;
import com.yoyak.yoyak.challenge.domain.CheerRepository;
import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.domain.UserRepository;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CheerService {
    private final CheerRepository cheerRepository;
    private final ChallengeArticleRepository challengeArticleRepository;
    private final UserRepository userRepository;


    // 응원하기 증가
    public void addCheer(Long userSeq, Long challengeArticleSeq){
        ChallengeArticle challengeArticle = challengeArticleRepository.findById(challengeArticleSeq).orElseThrow(()->new CustomException(
            CustomExceptionStatus.ARTICLE_INVALID));

        User user = userRepository.findById(userSeq).orElseThrow(()->new CustomException(
            CustomExceptionStatus.ACCOUNT_INVALID));

        if(cheerRepository.existsByUserAndChallengeArticle(user, challengeArticle)){
            throw new CustomException(CustomExceptionStatus.CHEER_ALREADY_EXIST);
        }

        Cheer cheer = Cheer.builder()
            .user(user)
            .challengeArticle(challengeArticle)
            .build();

        cheerRepository.save(cheer);

    }


}
