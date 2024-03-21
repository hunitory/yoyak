package com.yoyak.yoyak.account.domain;

import com.yoyak.yoyak.account.dto.AccountModifyDto;
import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.domain.UserGender;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Getter
@Table(name = "account")
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @Column(nullable = false, length = 32)
    private String name;

    @Column(nullable = false, length = 32)
    private String nickname;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private UserGender gender;

    @Column(nullable = false)
    private LocalDate birth;

    @Column(nullable = true)
    private String disease;

    @Column(nullable = false)
    private int profileImg;

    @Column(nullable = false)
    private AccountRole role;

    @ManyToOne
    @JoinColumn(name = "user_seq", nullable = false)
    private User user;

    public void modifyAccount(AccountModifyDto accountModifyDto) {
        this.nickname = accountModifyDto.getNickname();
        this.gender = accountModifyDto.getGender();
        this.birth = accountModifyDto.getBirth();
        this.disease = accountModifyDto.getDisease();
        this.profileImg = accountModifyDto.getProfileImg();
    }
}
