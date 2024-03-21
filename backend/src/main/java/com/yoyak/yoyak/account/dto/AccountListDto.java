package com.yoyak.yoyak.account.dto;

import com.yoyak.yoyak.user.domain.UserGender;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountListDto {

    private Long seq;
    private String nickname;
    private UserGender gender;
    private LocalDate birth;
    private int profileImg;
}
