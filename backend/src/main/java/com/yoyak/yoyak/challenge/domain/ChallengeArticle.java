package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.user.domain.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChallengeArticle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "challenge_seq")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Challenge challenge;

    public void changeChallenge(Challenge challenge) {
        this.challenge = challenge;
    }


    @Column(name = "user_seq")
    private Long userSeq;

    @Column(name = "img_url")
    private String imgUrl;

    @Column(name = "content")
    private String content;


    @OneToMany(mappedBy = "challengeArticle", fetch = FetchType.EAGER)
    @Builder.Default
    private List<Cheer> cheers = new ArrayList<>();

    public void changeCheers(Cheer cheer) {
        cheers.add(cheer);

    }



}
