package com.yoyak.yoyak.account.service;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.account.domain.AccountRepository;
import com.yoyak.yoyak.account.domain.AccountRole;
import com.yoyak.yoyak.account.dto.AccountDetailDto;
import com.yoyak.yoyak.account.dto.AccountListDto;
import com.yoyak.yoyak.account.dto.AccountModifyDto;
import com.yoyak.yoyak.account.dto.AccountRegistDto;
import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.service.UserService;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import com.yoyak.yoyak.util.security.SecurityUtil;
import jakarta.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class AccountService {

    private final AccountRepository accountRepository;
    private final UserService userService;
    private final SecurityUtil securityUtil;

    // 계정 등록
    public void addAccount(AccountRegistDto accountRegistDto, AccountRole accountRole) {
        int cnt = accountRepository.countByUserId(securityUtil.getUserSeq());
        if (cnt >= 3) {
            throw new CustomException(CustomExceptionStatus.ACCOUNT_MAXIMUM);
        }

        User user = userService.findById(securityUtil.getUserSeq());

        Account account = Account.builder()
            .name(accountRegistDto.getName())
            .nickname(accountRegistDto.getNickname())
            .gender(accountRegistDto.getGender())
            .birth(accountRegistDto.getBirth())
            .disease(accountRegistDto.getDisease())
            .profileImg(accountRegistDto.getProfileImg())
            .role(accountRole)
            .user(user)
            .build();

        accountRepository.save(account);
    }

    // 계정 목록
    public List<AccountListDto> findAccount() {
        List<AccountListDto> accountListDtos = new ArrayList<>();

        List<Account> accounts = accountRepository.findAllByUser(securityUtil.getUserSeq());
        for (Account account : accounts) {
            AccountListDto accountListDto = AccountListDto.builder()
                .seq(account.getSeq())
                .nickname(account.getNickname())
                .gender(account.getGender())
                .birth(account.getBirth())
                .profileImg(account.getProfileImg())
                .build();

            accountListDtos.add(accountListDto);
        }

        return accountListDtos;
    }

    // 계정 상세
    public AccountDetailDto detailAccount(Long accountSeq) {
        Account account = findByIdAndUserSeq(securityUtil.getUserSeq(), accountSeq);

        return AccountDetailDto.builder()
            .seq(account.getSeq())
            .name(account.getName())
            .nickname(account.getNickname())
            .gender(account.getGender())
            .birth(account.getBirth())
            .disease(account.getDisease())
            .profileImg(account.getProfileImg())
            .build();
    }

    // 계정 수정
    public void modifyAccount(AccountModifyDto accountModifyDto) {
        Account account = findByIdAndUserSeq(securityUtil.getUserSeq(), accountModifyDto.getSeq());
        account.modifyAccount(accountModifyDto);
    }

    // 계정 삭제
    public void removeAccount(Long accountSeq) {
        findByIdAndUserSeq(securityUtil.getUserSeq(), accountSeq);
        accountRepository.deleteById(accountSeq);
    }

    // 계정 조회
    public Account findById(Long seq) {
        return accountRepository.findById(seq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_INVALID));
    }

    // 계정 확인
    public Account findByIdAndUserSeq(Long userSeq, Long accountSeq) {
        return accountRepository.findByUserSeqAndId(userSeq, accountSeq)
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.ACCOUNT_AUTHORITY));
    }

}
