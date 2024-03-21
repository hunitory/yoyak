package com.yoyak.yoyak.notification.dto;

import com.yoyak.yoyak.notificationTime.domain.NotificationTimeTaken;
import java.time.LocalDateTime;
import java.time.LocalTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationListDto {

    private Long notiTimeSeq;
    private String name;
    private LocalDateTime time;
    private NotificationTimeTaken taken;
    private LocalTime takenTime;
    private Long accountSeq;
    private Long notiSeq;
}
