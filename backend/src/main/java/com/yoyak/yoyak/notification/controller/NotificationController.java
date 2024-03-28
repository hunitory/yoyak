package com.yoyak.yoyak.notification.controller;

import com.yoyak.yoyak.notification.domain.Notification;
import com.yoyak.yoyak.notification.dto.NotificationFindDto;
import com.yoyak.yoyak.notification.dto.NotificationModifyDto;
import com.yoyak.yoyak.notification.dto.NotificationRegistDto;
import com.yoyak.yoyak.notification.service.NotificationService;
import com.yoyak.yoyak.notificationTime.service.NotificationTimeService;
import java.time.LocalDate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/noti")
public class NotificationController {

    private final NotificationService notificationService;
    private final NotificationTimeService notificationTimeService;

    // 알림 등록
    @PostMapping()
    public ResponseEntity<Object> notificationAdd(
        @RequestBody NotificationRegistDto notificationRegistDto) {
        Notification notification = notificationService.addNotification(notificationRegistDto);
        notificationTimeService.addNotification(notificationRegistDto, notification);

        return ResponseEntity.ok().build();
    }

    // 알림 상세
    @GetMapping("/{notiSeq}")
    public ResponseEntity<Object> notificationDetail(@PathVariable Long notiSeq) {
        NotificationFindDto notificationFindDto = notificationService.findNotification(notiSeq);

        return ResponseEntity.ok().body(notificationFindDto);
    }

    // 알림 수정
    @PutMapping()
    public ResponseEntity<Object> notificationModify(
        @RequestBody NotificationModifyDto notificationModifyDto) {
        Notification notification = notificationService.modifyNotification(notificationModifyDto);

        NotificationRegistDto notificationRegistDto = new NotificationRegistDto();
        notificationRegistDto.setName(notification.getName());
        notificationRegistDto.setStartDate(LocalDate.now());
        notificationRegistDto.setEndDate(notification.getEndDate());
        notificationRegistDto.setPeriod(notification.getPeriod());
        notificationRegistDto.setTime(notification.getTime());

        notificationTimeService.removeNotification(notificationModifyDto.getNotiSeq());
        notificationTimeService.modifyNotification(notificationRegistDto, notification);

        return ResponseEntity.ok().build();
    }

    // 알림 삭제
    @DeleteMapping("/{notiSeq}")
    public ResponseEntity<Object> notificationRemove(@PathVariable Long notiSeq) {
        notificationTimeService.removeNotification(notiSeq);

        return ResponseEntity.ok().build();
    }

    @Scheduled(cron = "0 * * * * ?")
    public ResponseEntity<Object> pushNotification() {
        log.info("알림 발송");
        notificationService.sendFCM();
        return ResponseEntity.ok().build();
    }
}
