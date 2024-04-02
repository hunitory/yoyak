package com.yoyak.yoyak.notificationTime.domain;

import com.yoyak.yoyak.notification.domain.Notification;
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
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Getter
@Setter
@Table(name = "notification_time")
public class NotificationTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long seq;

    @Column(nullable = false)
    private LocalDateTime time;


    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private NotificationTimeTaken taken;

    @Column(nullable = true)
    private LocalDateTime takenTime;

    @ManyToOne
    @JoinColumn(name = "notification_seq", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Notification notification;

    public void takenNotificationTime(LocalDateTime takenTime) {
        this.taken = NotificationTimeTaken.TAKEN;
        this.takenTime = takenTime;
    }

    public void notNotificationTime() {
        this.taken = NotificationTimeTaken.NOT_TAKEN;
        this.takenTime = null;
    }

    public void yetNotificationTime() {
        this.taken = NotificationTimeTaken.YET_TAKEN;
        this.takenTime = null;
    }

}
