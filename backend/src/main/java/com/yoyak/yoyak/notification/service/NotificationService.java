package com.yoyak.yoyak.notification.service;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.account.service.AccountService;
import com.yoyak.yoyak.notification.domain.Notification;
import com.yoyak.yoyak.notification.domain.NotificationRepository;
import com.yoyak.yoyak.notification.dto.NotificationFindDto;
import com.yoyak.yoyak.notification.dto.NotificationModifyDto;
import com.yoyak.yoyak.notification.dto.NotificationRegistDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import com.yoyak.yoyak.util.security.SecurityUtil;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
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
    private final SecurityUtil securityUtil;

    // 알람 등록
    public Notification addNotification(NotificationRegistDto notificationRegistDto) {
        Account account = accountService.findByIdAndUserSeq(securityUtil.getUserSeq(),
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
        Notification notification = findByIdAndUserSeq(securityUtil.getUserSeq(), notiSeq);

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
        Notification notification = findByIdAndUserSeq(securityUtil.getUserSeq(),
            notificationModifyDto.getNotiSeq());
        notification.modifyNotification(notificationModifyDto);

        return notification;
    }

    // 알람 삭제
    public void removeNotification(Long notiSeq) {
        Notification notification = findByIdAndUserSeq(securityUtil.getUserSeq(), notiSeq);
        notificationRepository.delete(notification);
    }

    // 알람 확인
    public Notification findByIdAndUserSeq(Long userSeq, Long notiSeq) {
        return notificationRepository.findByIdAndUseSeq(userSeq, notiSeq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.NOTI_AUTHORITY));
    }
}
