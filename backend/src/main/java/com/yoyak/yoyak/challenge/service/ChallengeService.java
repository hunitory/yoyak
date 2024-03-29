package com.yoyak.yoyak.challenge.service;

import com.yoyak.yoyak.challenge.domain.Challenge;
import com.yoyak.yoyak.challenge.domain.ChallengeRepository;
import com.yoyak.yoyak.challenge.dto.ChallengeCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeResponseDto;
import com.yoyak.yoyak.user.domain.User;
import java.time.LocalDate;
import java.time.Period;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cglib.core.Local;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChallengeService {

    private final ChallengeRepository challengeRepository;


    public void create(ChallengeCreateDto challengeCreateDto) {
        LocalDate startDate = LocalDate.parse(challengeCreateDto.getStartDate());
        LocalDate endDate = LocalDate.parse(challengeCreateDto.getEndDate());
        User user = User.builder()
            .seq(challengeCreateDto.getUserSeq())
            .build();
        Challenge challenge = Challenge.builder()
            .user(user)
            .title(challengeCreateDto.getTitle())
            .startDate(startDate)
            .endDate(endDate)
            .build();

        challengeRepository.save(challenge);
    }

    public void deleteAllConnection(Long userSeq) {
        challengeRepository.deleteAllConnectionByUserSeq(userSeq);
    }

    public ChallengeResponseDto getEnrolledChallenge(Long userSeq){
        Challenge challenge = challengeRepository.findLastByUserSeq(userSeq);
        int articleSize = challenge.getChallengeArticles().size();
        LocalDate startDate = challenge.getStartDate();
        LocalDate endDate = challenge.getEndDate();

        Period period = Period.between(startDate, endDate);
        int day = period.getDays();

        return ChallengeResponseDto.builder()
            .title(challenge.getTitle())
            .startDate(startDate)
            .endDate(endDate)
            .day(day)
            .articleSize(articleSize)
            .build();
    }

}
