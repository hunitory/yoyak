package com.yoyak.yoyak.notification.domain;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    Optional<Notification> findBySeq(Long notiSeq);

    @Query("select n from Notification n where n.account.user.seq = :userSeq and n.seq = :notiSeq")
    Optional<Notification> findByIdAndUseSeq(Long userSeq, Long notiSeq);
}
