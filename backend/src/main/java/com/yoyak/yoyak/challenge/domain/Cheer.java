package com.yoyak.yoyak.challenge.domain;


import com.yoyak.yoyak.user.domain.User;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;


@Entity
@Table(uniqueConstraints = @UniqueConstraint(columnNames = {"user_seq", "challenge_article_seq"}))
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Cheer {

    @Id
    @GeneratedValue
    private Long seq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_seq")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "challenge_article_seq")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private ChallengeArticle challengeArticle;


}
