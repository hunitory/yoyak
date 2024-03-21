package com.yoyak.yoyak.notification.domain;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    Optional<Object> findBySeq(Long notiSeq);
}
