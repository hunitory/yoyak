package com.yoyak.yoyak.challenge.domain;

import com.yoyak.yoyak.user.domain.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChallengeArticle {

    @Id
    @GeneratedValue
    private Long seq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "challenge_seq")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Challenge challenge;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "user_seq")
//    private User user;

    @Column(name = "img_url")
    private String imgUrl;

    @Column(name = "content")
    private String content;


    @OneToMany(mappedBy = "challengeArticle")
    @Builder.Default
    private List<Cheer> cheers = new ArrayList<>();

    public void changeCheers(Cheer cheer) {
        cheers.add(cheer);

    }

}
