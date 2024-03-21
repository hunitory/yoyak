package com.yoyak.yoyak.util.security;

import com.yoyak.yoyak.util.user.CustomUserDetails;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class SecurityUtil {

    // token에서 seq 불러오기
    public static Long getUserSeq() {
        final Authentication authentication = SecurityContextHolder.getContext()
            .getAuthentication();

        if (authentication == null || authentication.getName() == null) {
            throw new RuntimeException("No authentication information.");
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long seq = userDetails.getUserInfoDto().getUserSeq();
        return seq;
    }
}