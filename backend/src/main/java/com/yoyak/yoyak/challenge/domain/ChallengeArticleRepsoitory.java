package com.yoyak.yoyak.challenge.domain;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ChallengeArticleRepsoitory extends JpaRepository<ChallengeArticle, Long>, ChallengeArticleCustomRepository {

    List<ChallengeArticle> findByUserSeq(Long userSeq);
}
