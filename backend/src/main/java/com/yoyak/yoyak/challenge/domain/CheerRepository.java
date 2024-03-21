package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CheerRepository extends JpaRepository<Cheer, Long>{

    boolean existsByUserAndChallengeArticle(User user, ChallengeArticle challengeArticle);

}
