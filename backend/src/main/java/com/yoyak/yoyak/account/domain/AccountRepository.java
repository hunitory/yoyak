package com.yoyak.yoyak.account.domain;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AccountRepository extends JpaRepository<Account, Long> {

    @Query("select a from Account a where a.user.seq = :userSeq")
    List<Account> findAllByUser(Long userSeq);
}
