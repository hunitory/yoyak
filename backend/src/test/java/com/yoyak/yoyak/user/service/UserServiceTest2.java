package com.yoyak.yoyak.user.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class UserServiceTest2 {
    @Autowired
    private UserService userService;

    @Test
    public void deleteTest(){
        Long userSeq = 1L;

        userService.withdraw(userSeq);
    }
}
