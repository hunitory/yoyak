package com.yoyak.yoyak.util.jwt;

import com.yoyak.yoyak.util.user.CustomUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.filter.OncePerRequestFilter;

@Slf4j
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final CustomUserDetailsService customUserDetailsService;
    private final JwtUtil jwtUtil;

    @Override
    // JWT 토큰 검증 필터
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
        FilterChain filterChain) throws ServletException, IOException {
        String authorizationHeader = request.getHeader("Authorization");

        // JWT가 헤더에 있는 경우(Authorization: Bearer {{token}})
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7);

            // JWT 유효성 검증
            if (jwtUtil.validateToken(token)) {
                Long userSeq = jwtUtil.getUserSeq(token);

                // 사용자와 token 사용자가 일치하면 userDetails 생성
                UserDetails userDetails = customUserDetailsService.loadUserByUsername(
                    userSeq.toString());

                // userDetails가 생성되면
                if (userDetails != null) {
                    //userDetails, Password, Role -> 접근권한 인증 Token 생성
                    UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                        new UsernamePasswordAuthenticationToken(userDetails, null,
                            userDetails.getAuthorities());

                    // 현재 Request의 Security Context에 접근권한 설정
                    SecurityContextHolder.getContext()
                        .setAuthentication(usernamePasswordAuthenticationToken);
                }
            }
        }

        // 다음 필터로 넘기기
        filterChain.doFilter(request, response);
    }
}