package com.yoyak.yoyak.notification.domain;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.notification.dto.NotificationModifyDto;
import com.yoyak.yoyak.notificationTime.domain.NotificationTime;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
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
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

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

    @Column(nullable = false, length = 24)
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
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Account account;

    @OneToMany(mappedBy = "notification", cascade = CascadeType.REMOVE, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<NotificationTime> notificationTimes;


    public void modifyNotification(NotificationModifyDto notificationModifyDto) {
        this.name = notificationModifyDto.getName();
        this.endDate = notificationModifyDto.getEndDate();
        this.period = notificationModifyDto.getPeriod();
        this.time = notificationModifyDto.getTime();
        this.modifyDate = LocalDateTime.now();
    }
}
