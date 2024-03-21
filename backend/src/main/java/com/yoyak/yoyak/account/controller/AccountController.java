package com.yoyak.yoyak.account.controller;

import com.yoyak.yoyak.account.domain.AccountRole;
import com.yoyak.yoyak.account.dto.AccountDetailDto;
import com.yoyak.yoyak.account.dto.AccountListDto;
import com.yoyak.yoyak.account.dto.AccountModifyDto;
import com.yoyak.yoyak.account.dto.AccountRegistDto;
import com.yoyak.yoyak.account.service.AccountService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/account")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    // 계정 등록
    @PostMapping()
    public ResponseEntity<Object> accountAdd(@RequestBody AccountRegistDto accountRegistDto) {
        accountService.addAccount(accountRegistDto, AccountRole.CARE);

        return ResponseEntity.ok().build();
    }

    // 계정 목록
    @GetMapping("/{userSeq}")
    public ResponseEntity<Object> accountList(@PathVariable Long userSeq) {
        List<AccountListDto> accountListDtos = accountService.findAccount(userSeq);

        return ResponseEntity.ok().body(accountListDtos);
    }

    // 계정 상세
    @GetMapping("/detail/{accountSeq}")
    public ResponseEntity<Object> accountDetail(@PathVariable Long accountSeq) {
        AccountDetailDto accountDetailDto = accountService.detailAccount(accountSeq);

        return ResponseEntity.ok().body(accountDetailDto);
    }

    // 계정 수정
    @PutMapping()
    public ResponseEntity<Object> accountModify(@RequestBody AccountModifyDto accountModifyDto) {
        accountService.modifyAccount(accountModifyDto);

        return ResponseEntity.ok().build();
    }

    // 계정 삭제
    @DeleteMapping("/{accountSeq}")
    public ResponseEntity<Object> accountRemove(@PathVariable Long accountSeq) {
        accountService.removeAccount(accountSeq);

        return ResponseEntity.ok().build();
    }
}
