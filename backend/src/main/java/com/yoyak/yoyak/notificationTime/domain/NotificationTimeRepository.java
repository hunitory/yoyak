package com.yoyak.yoyak.notificationTime.domain;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface NotificationTimeRepository extends JpaRepository<NotificationTime, Long> {

    @Query("select n from NotificationTime n where n.notification.account.user.seq = :userSeq and n.time between :startDate and :endDate")
    List<NotificationTime> findAllByAccountSeqAndTime(Long userSeq, LocalDateTime startDate,
        LocalDateTime endDate);

    @Query("select n from NotificationTime n where n.notification.seq = :seq and n.time > :dateTime")
    List<NotificationTime> findAllByNotificationSeq(Long seq, LocalDateTime dateTime);


}
