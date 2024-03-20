package com.yoyak.yoyak.challenge.domain;


import com.yoyak.yoyak.user.domain.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Getter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Challenge {
    @Id
    @GeneratedValue
    private Long seq;

    @ManyToOne(fetch = FetchType.LAZY)
    private User user;

    @Column(name="title", nullable = false)
    private String title;

    @Column(name="startDate", nullable = false)
    private LocalDate startDate;

    @Column(name="endDate", nullable = false)
    private LocalDate endDate;


}
