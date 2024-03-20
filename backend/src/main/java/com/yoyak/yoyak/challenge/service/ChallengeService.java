package com.yoyak.yoyak.challenge.service;

import com.yoyak.yoyak.challenge.domain.Challenge;
import com.yoyak.yoyak.challenge.domain.ChallengeRepository;
import com.yoyak.yoyak.challenge.dto.ChallengeCreateDto;
import java.time.LocalDate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChallengeService {
    private final ChallengeRepository challengeRepository;

    public void create(ChallengeCreateDto challengeCreateDto) {
        LocalDate startDate = LocalDate.parse(challengeCreateDto.getStartDate());
        LocalDate endDate = LocalDate.parse(challengeCreateDto.getEndDate());
        Challenge challenge = Challenge.builder()
            .title(challengeCreateDto.getTitle())
            .startDate(startDate)
            .endDate(endDate)
            .build();

        challengeRepository.save(challenge);
    }
}
