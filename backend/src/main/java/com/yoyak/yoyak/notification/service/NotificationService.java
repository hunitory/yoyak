package com.yoyak.yoyak.notification.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.account.service.AccountService;
import com.yoyak.yoyak.deviceToken.domain.DeviceToken;
import com.yoyak.yoyak.notification.domain.Notification;
import com.yoyak.yoyak.notification.domain.NotificationRepository;
import com.yoyak.yoyak.notification.dto.NotificationFindDto;
import com.yoyak.yoyak.notification.dto.NotificationModifyDto;
import com.yoyak.yoyak.notification.dto.NotificationRegistDto;
import com.yoyak.yoyak.notificationTime.domain.NotificationTime;
import com.yoyak.yoyak.notificationTime.domain.NotificationTimeRepository;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import com.yoyak.yoyak.util.security.SecurityUtil;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class NotificationService {

    private final AccountService accountService;
    private final NotificationRepository notificationRepository;
    private final NotificationTimeRepository notificationTimeRepository;

    private final FirebaseMessaging firebaseMessaging;


    // 알람 등록
    public Notification addNotification(NotificationRegistDto notificationRegistDto) {
        Account account = accountService.findByIdAndUserSeq(SecurityUtil.getUserSeq(),
            notificationRegistDto.getAccountSeq());

        Notification notification = Notification.builder()
            .name(notificationRegistDto.getName())
            .startDate(notificationRegistDto.getStartDate())
            .endDate(notificationRegistDto.getEndDate())
            .period(notificationRegistDto.getPeriod())
            .time(notificationRegistDto.getTime())
            .createDate(LocalDateTime.now())
            .account(account)
            .build();

        return notificationRepository.save(notification);
    }

    // 알림 상세 보기
    public NotificationFindDto findNotification(Long notiSeq) {
        Notification notification = findByIdAndUserSeq(SecurityUtil.getUserSeq(), notiSeq);

        return NotificationFindDto.builder()
            .accountSeq(notification.getAccount().getSeq())
            .notiSeq(notification.getSeq())
            .name(notification.getName())
            .startDate(notification.getStartDate())
            .endDate(notification.getEndDate())
            .period(notification.getPeriod())
            .time(notification.getTime())
            .build();

    }

    // 알람 수정
    public Notification modifyNotification(NotificationModifyDto notificationModifyDto) {
        Notification notification = findByIdAndUserSeq(SecurityUtil.getUserSeq(),
            notificationModifyDto.getNotiSeq());
        notification.modifyNotification(notificationModifyDto);

        return notification;
    }

    // 알람 삭제
    public void removeNotification(Long notiSeq) {
        Notification notification = findByIdAndUserSeq(SecurityUtil.getUserSeq(), notiSeq);
        notificationRepository.delete(notification);
    }

    // 알람 확인
    public Notification findByIdAndUserSeq(Long userSeq, Long notiSeq) {
        return notificationRepository.findByIdAndUseSeq(userSeq, notiSeq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.NOTI_AUTHORITY));
    }

    public void sendFCM() {
        LocalDateTime now = LocalDateTime.now();
        now = now.withSecond(0).withNano(0);

        List<NotificationTime> notificationTimes = notificationTimeRepository.findByTime(now);

        for (NotificationTime notiTime : notificationTimes) {

            Notification notification = notiTime.getNotification();
            String accountName = notification.getAccount().getName();
            List<DeviceToken> deviceTokens = notification.getAccount().getUser().getDeviceTokens();

            if (deviceTokens.isEmpty()) {
                continue;
            }

            for (DeviceToken deviceToken : deviceTokens) {
                // FCM 전송
                // FCM 메시지 생성 (알림 메시지
                String message = String.format("%s 님! %s 시간이에요!", accountName, notification.getName());
                Message fcmMessage = Message.builder()
                    .setNotification(getNotification(message))
                    .setToken(deviceToken.getToken())
                    .build();

                try {
                    firebaseMessaging.send(fcmMessage);
                } catch (FirebaseMessagingException e) {
                    log.error("FCM 전송 실패", e);
                }

            }

        }
    }

    private com.google.firebase.messaging.Notification getNotification(String message) {
        return com.google.firebase.messaging.Notification.builder()
            .setTitle("Yoyak 알림")
            .setBody(message)
            .build();
    }

}
