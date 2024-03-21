package com.yoyak.yoyak.notification.domain;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.notification.dto.NotificationModifyDto;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
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
@Table(name = "notification")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private LocalDate startDate;

    @Column(nullable = false)
    private LocalDate endDate;

    @Column(nullable = false)
    private List<DayOfWeek> period;

    @Column(nullable = false)
    private List<LocalTime> time;

    @Column(nullable = false)
    private LocalDateTime createDate;

    @Column(nullable = true)
    private LocalDateTime modifyDate;

    @ManyToOne
    @JoinColumn(name = "account_seq", nullable = false)
    private Account account;

    public void modifyNotification(NotificationModifyDto notificationModifyDto) {
        this.name = notificationModifyDto.getName();
        this.endDate = notificationModifyDto.getEndDate();
        this.period = notificationModifyDto.getPeriod();
        this.time = notificationModifyDto.getTime();
        this.modifyDate = LocalDateTime.now();
    }
}
