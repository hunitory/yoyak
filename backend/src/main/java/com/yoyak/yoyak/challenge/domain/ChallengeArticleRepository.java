package com.yoyak.yoyak.challenge.domain;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface ChallengeArticleRepository extends JpaRepository<ChallengeArticle, Long>,
    ChallengeArticleCustomRepository {


    List<ChallengeArticle> findByChallengeSeq(Long challengeSeq);

    int deleteByChallengeSeq(Long challengeSeq);

    @Query("select a from ChallengeArticle a where a.seq = :challengeArticleSeq")
    @Transactional
    Optional<ChallengeArticle> findById(Long challengeArticleSeq);
}
