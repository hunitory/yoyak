package com.yoyak.yoyak.challenge.domain;

import java.time.LocalDate;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import org.springframework.data.jpa.repository.Query;

public interface ChallengeRepository extends JpaRepository<Challenge, Long>, ChallengeCustomRepository{
    List<Challenge> findByUserSeq(Long userSeq);
    int deleteByUserSeq(Long userSeq);
    @Query(value = "select c from Challenge c where c.user.seq = :userSeq order by c.updatedAt desc limit 1")
    Challenge findLastByUserSeq(Long userSeq);

    // 현재시간보다 endDate가 이전인 Challenge 삭제
    @Query(value = "delete from Challenge c where c.endDate < :time")
    void deleteAfterEndDate(LocalDate time);
}
