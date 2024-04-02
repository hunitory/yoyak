package com.yoyak.yoyak.challenge.domain;

import java.time.LocalDate;

public interface ChallengeCustomRepository {
    void deleteAllConnectionByUserSeq(Long userSeq);

    void deleteAfterEndDate(LocalDate time);
}
