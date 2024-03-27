package com.yoyak.yoyak.challenge.domain;

public interface ChallengeCustomRepository {
    void deleteAllConnectionByUserSeq(Long userSeq);
}
