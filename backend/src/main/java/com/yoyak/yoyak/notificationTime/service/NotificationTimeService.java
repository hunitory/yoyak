package com.yoyak.yoyak.notificationTime.service;

import com.yoyak.yoyak.notification.domain.Notification;
import com.yoyak.yoyak.notification.dto.NotificationListDto;
import com.yoyak.yoyak.notification.dto.NotificationRegistDto;
import com.yoyak.yoyak.notification.service.NotificationService;
import com.yoyak.yoyak.notificationTime.domain.NotificationTime;
import com.yoyak.yoyak.notificationTime.domain.NotificationTimeRepository;
import com.yoyak.yoyak.notificationTime.domain.NotificationTimeTaken;
import com.yoyak.yoyak.notificationTime.dto.MedicationDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import com.yoyak.yoyak.util.security.SecurityUtil;
import jakarta.transaction.Transactional;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class NotificationTimeService {

    private final NotificationTimeRepository notificationTimeRepository;
    private final NotificationService notificationService;

    // 알림 등록
    public void addNotification(NotificationRegistDto notificationRegistDto,
        Notification notification) {
        LocalDate startDate = notificationRegistDto.getStartDate();
        LocalDate endDate = notificationRegistDto.getEndDate();
        LocalDate currentDate = startDate;
        List<DayOfWeek> period = notificationRegistDto.getPeriod();
        List<LocalTime> time = notificationRegistDto.getTime();

        while (!currentDate.isAfter(endDate)) { // 날짜 확인
            if (period.contains(currentDate.getDayOfWeek())) { // 요일 확인
                for (LocalTime t : time) {
                    LocalDateTime localDateTime = LocalDateTime.of(currentDate, t);
                    NotificationTime notificationTime = NotificationTime.builder()
                        .time(localDateTime)
                        .taken(NotificationTimeTaken.YET_TAKEN)
                        .notification(notification)
                        .build();
                    notificationTimeRepository.save(notificationTime);
                }
            }
            currentDate = currentDate.plusDays(1);
        }
    }

    // 알람 수정
    public void modifyNotification(NotificationRegistDto notificationRegistDto,
        Notification notification) {
        LocalDate startDate = notificationRegistDto.getStartDate();
        LocalDate endDate = notificationRegistDto.getEndDate();
        LocalDate currentDate = startDate;
        List<DayOfWeek> period = notificationRegistDto.getPeriod();
        List<LocalTime> time = notificationRegistDto.getTime();

        while (!currentDate.isAfter(endDate)) { // 날짜 확인
            if (period.contains(currentDate.getDayOfWeek())) { // 요일 확인
                for (LocalTime t : time) {
                    LocalDateTime localDateTime = LocalDateTime.of(currentDate, t);
                    if (localDateTime.isAfter(LocalDateTime.now())) { // 시간 확인
                        NotificationTime notificationTime = NotificationTime.builder()
                            .time(localDateTime)
                            .taken(NotificationTimeTaken.YET_TAKEN)
                            .notification(notification)
                            .build();
                        notificationTimeRepository.save(notificationTime);
                    }
                }
            }
            currentDate = currentDate.plusDays(1);
        }
    }

    // 알람 목록
    public List<NotificationListDto> findNotification() {
        List<NotificationListDto> notificationListDtos = new ArrayList<>();

        LocalDateTime currentDate = LocalDateTime.now();
        LocalDateTime startDate = currentDate.minusWeeks(3).with(DayOfWeek.MONDAY);
        LocalDateTime endDate = currentDate.plusWeeks(3).with(DayOfWeek.SATURDAY);

        List<NotificationTime> notificationTimes = notificationTimeRepository
            .findAllByAccountSeqAndTime(SecurityUtil.getUserSeq(), startDate, endDate);

        for (NotificationTime notificationTime : notificationTimes) {
            NotificationListDto notificationListDto = NotificationListDto.builder()
                .notiTimeSeq(notificationTime.getSeq())
                .name(notificationTime.getNotification().getName())
                .time(notificationTime.getTime())
                .taken(notificationTime.getTaken())
                .takenTime(notificationTime.getTakenTime())
                .accountSeq(notificationTime.getNotification().getAccount().getSeq())
                .notiSeq(notificationTime.getNotification().getSeq())
                .build();
            notificationListDtos.add(notificationListDto);
        }

        return notificationListDtos;
    }

    // 알람 삭제
    public void removeNotification(Long notiSeq) {
        notificationService.findByIdAndUserSeq(SecurityUtil.getUserSeq(), notiSeq);
        LocalDateTime localDateTime = LocalDateTime.now();
        localDateTime = localDateTime.withHour(0).withMinute(0);

        List<NotificationTime> notificationTimes = notificationTimeRepository
            .findAllByNotificationSeq(notiSeq, localDateTime);

        for (NotificationTime notificationTime : notificationTimes) {
            notificationTimeRepository.delete(notificationTime);
        }
    }

    // 복용 먹음 등록
    public void addMedication(MedicationDto medicationDto) {
        NotificationTime notificationTime = findByIdAndNotiTimeSeq(SecurityUtil.getUserSeq(),
            medicationDto.getNotiTimeSeq());

        notificationTime.takenNotificationTime(medicationDto.getTakenTime());
    }

    // 복용 먹지 않음 등록
    public void addNotMedication(Long notiTimeSeq) {

        NotificationTime notificationTime = findByIdAndNotiTimeSeq(SecurityUtil.getUserSeq(),
            notiTimeSeq);

        notificationTime.notNotificationTime();
    }

    // 복용 안 먹음 등록
    public void addYetMedication(Long notiTimeSeq) {
        NotificationTime notificationTime = findByIdAndNotiTimeSeq(SecurityUtil.getUserSeq(),
            notiTimeSeq);

        notificationTime.yetNotificationTime();
    }

    // 알람 세부 조회
    public NotificationTime findByIdAndNotiTimeSeq(Long userSeq, Long notiTimeSeq) {
        return notificationTimeRepository.findByIdAndNotiTimeSeq(userSeq, notiTimeSeq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.NOTI_INVALID));
    }
}
