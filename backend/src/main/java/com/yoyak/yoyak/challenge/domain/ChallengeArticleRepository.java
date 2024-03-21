package com.yoyak.yoyak.challenge.domain;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChallengeArticleRepository extends JpaRepository<ChallengeArticle, Long>, ChallengeArticleCustomRepository {

    List<ChallengeArticle> findByUserSeq(Long userSeq);
}
