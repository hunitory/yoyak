package com.yoyak.yoyak.challenge.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChallengeRepository extends JpaRepository<Challenge, Long>{
    List<Challenge> findByUserSeq(Long userSeq);
    int deleteByUserSeq(Long userSeq);
}
