package com.yoyak.yoyak.user.dto;

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
public class SignInRequestDto {

    private String userId;
    private String password;
    private String name;
    private String nickname;
    private UserGender gender;
    private LocalDate birth;
}
