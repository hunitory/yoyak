package com.yoyak.yoyak.challenge.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import org.springframework.data.jpa.repository.Query;

public interface ChallengeRepository extends JpaRepository<Challenge, Long>, ChallengeCustomRepository{
    List<Challenge> findByUserSeq(Long userSeq);
    int deleteByUserSeq(Long userSeq);
    @Query(value = "select c from Challenge c where c.user = :userSeq order by c.updatedAt desc limit 1")
    Challenge findLastByUserSeq(Long userSeq);
}
