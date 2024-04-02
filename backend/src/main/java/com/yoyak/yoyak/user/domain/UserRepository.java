package com.yoyak.yoyak.user.domain;

import java.time.LocalDate;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, Long> {

    @Query("select u.userId from User u where u.name=:name and u.birth=:birth")
    Optional<String> findByNameAndBirth(String name, LocalDate birth);

    @Query("select u from User u where u.userId=:userId and u.name=:name")
    Optional<User> findByIdAndName(String userId, String name);

    @Query("select u from User u where u.userId = :userId")
    Optional<User> findByUserId(String userId);

    @Query("select u from User u where u.nickname = :nickname")
    Optional<User> findByNickname(String nickname);

}
