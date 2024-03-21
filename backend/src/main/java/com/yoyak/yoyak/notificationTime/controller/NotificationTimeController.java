package com.yoyak.yoyak.notificationTime.controller;

import com.yoyak.yoyak.notification.dto.NotificationListDto;
import com.yoyak.yoyak.notificationTime.dto.MedicationDto;
import com.yoyak.yoyak.notificationTime.service.NotificationTimeService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/noti/time")
public class NotificationTimeController {

    private final NotificationTimeService notificationTimeService;

    // 알림 목록
    @GetMapping("/{userSeq}")
    public ResponseEntity<Object> notificationList(
        @PathVariable Long userSeq) {
        List<NotificationListDto> notificationListDtos = notificationTimeService.findNotification(
            userSeq);

        return ResponseEntity.ok().body(notificationListDtos);
    }

    // 알림 삭제
    @DeleteMapping("/{notiSeq}")
    public ResponseEntity<Object> notificationRemove(@PathVariable Long notiSeq) {
        notificationTimeService.removeNotification(notiSeq);

        return ResponseEntity.ok().build();
    }

    // 복용 먹음 등록
    @PutMapping("/taken")
    public ResponseEntity<Object> addMedication(
        @RequestBody MedicationDto medicationDto) {
        notificationTimeService.addMedication(medicationDto);

        return ResponseEntity.ok().build();
    }

    // 복용 먹지 않음 등록
    @PutMapping("/not/{notiTimeSeq}")
    public ResponseEntity<Object> addNotMedication(@PathVariable Long notiTimeSeq) {
        notificationTimeService.addNotMedication(notiTimeSeq);

        return ResponseEntity.ok().build();
    }

    // 복용 안 먹음 등록
    @PutMapping("/yet/{notiTimeSeq}")
    public ResponseEntity<Object> addYetMedication(@PathVariable Long notiTimeSeq) {
        notificationTimeService.addYetMedication(notiTimeSeq);

        return ResponseEntity.ok().build();
    }

}