package com.yoyak.yoyak.account.domain;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AccountRepository extends JpaRepository<Account, Long> {

    @Query("select a from Account a where a.user.seq = :userSeq")
    List<Account> findAllByUser(Long userSeq);

    @Query("select count(a.user.seq) from Account a where a.user.seq = :userSeq")
    int countByUserId(Long userSeq);

    @Query("select a from Account a where a.user.seq = :userSeq and a.seq = :accountSeq")
    Optional<Account> findByUserSeqAndId(Long userSeq, Long accountSeq);
}
