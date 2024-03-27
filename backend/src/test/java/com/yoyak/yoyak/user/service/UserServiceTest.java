package com.yoyak.yoyak.user.service;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.user.domain.UserGender;
import com.yoyak.yoyak.user.domain.UserPlatform;
import com.yoyak.yoyak.user.domain.UserRepository;
import com.yoyak.yoyak.user.domain.UserRole;
import com.yoyak.yoyak.user.dto.DupIdRequestDto;
import com.yoyak.yoyak.user.dto.DupNicknameRequestDto;
import com.yoyak.yoyak.user.dto.FindIdRequestDto;
import com.yoyak.yoyak.user.dto.FindIdResponseDto;
import com.yoyak.yoyak.user.dto.FindPwRequestDto;
import com.yoyak.yoyak.user.dto.LoginRequestDto;
import com.yoyak.yoyak.user.dto.SignInRequestDto;
import com.yoyak.yoyak.util.dto.UserInfoDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.jwt.JwtUtil;
import com.yoyak.yoyak.util.security.SecurityUtil;
import java.time.LocalDate;
import java.util.Optional;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private JwtUtil jwtUtil;

    @InjectMocks
    private UserService userService;

    @Test
    @DisplayName("로그인 성공")
    void loginSuccess() {
        // entity
        User user = new User().builder()
            .seq(1L)
            .userId("testUser")
            .password("testPassword")
            .name("testUser")
            .nickname("testNickname")
            .gender(UserGender.M)
            .birth(LocalDate.of(2000, 1, 1))
            .build();

        // when
        when(userRepository.findByUserId("testUser")).thenReturn(Optional.of(user));
        when(jwtUtil.createAccessToken(any(UserInfoDto.class))).thenReturn("fakeToken");

        // dto
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("testUser")
            .password("testPassword")
            .build();

        // result
        String token = userService.login(loginRequestDto);

        // then
        assertNotNull(token);
        assertTrue(token.startsWith("fakeToken"));
    }

    @Test
    @DisplayName("로그인 실패 - 존재하지 않음")
    void loginNotFound() {
        // when
        when(userRepository.findByUserId("nonExistingUser")).thenReturn(Optional.empty());

        // dto
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("nonExistingUser")
            .password("testPassword")
            .build();

        // then
        assertThrows(CustomException.class, () -> userService.login(loginRequestDto));
    }

    @Test
    @DisplayName("로그인 실패 - 비밀번호 오류")
    void loginWrongLogin() {
        // entity
        User user = new User().builder()
            .seq(1L)
            .userId("testUser")
            .password("testPassword")
            .name("testUser")
            .nickname("testNickname")
            .gender(UserGender.M)
            .birth(LocalDate.of(2000, 1, 1))
            .build();

        // when
        when(userRepository.findByUserId("testUser")).thenReturn(Optional.of(user));

        // dto
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("testUser")
            .password("wrongPassword")
            .build();

        // then
        assertThrows(CustomException.class, () -> userService.login(loginRequestDto));
    }

    @Test
    @DisplayName("회원가입 성공")
    void signinSuccess() {
        // dto
        SignInRequestDto signInRequestDto = new SignInRequestDto().builder()
            .userId("testUser")
            .password("testPassword")
            .name("testUser")
            .nickname("testNickname")
            .build();

        // entity
        User savedUser = User.builder()
            .userId(signInRequestDto.getUserId())
            .password(signInRequestDto.getPassword())
            .name(signInRequestDto.getName())
            .nickname(signInRequestDto.getNickname())
            .gender(signInRequestDto.getGender())
            .birth(signInRequestDto.getBirth())
            .platform(UserPlatform.ORIGIN)
            .role(UserRole.USER)
            .build();

        // when
        when(userRepository.save(any(User.class))).thenReturn(savedUser);

        // then
        userService.signIn(signInRequestDto, UserPlatform.ORIGIN);
        assertNotNull(savedUser);
    }

    @Test
    @DisplayName("아이디 찾기 성공")
    void findIdSuccess() {
        // dto
        FindIdRequestDto findIdRequestDto = FindIdRequestDto.builder()
            .name("testName")
            .birth(LocalDate.of(2000, 1, 1))
            .build();

        // when
        when(userRepository.findByNameAndBirth("testName", LocalDate.of(2000, 1, 1)))
            .thenReturn(Optional.of("testUser"));

        // then
        FindIdResponseDto responseDto = userService.findId(findIdRequestDto);
        assertNotNull(responseDto);
        assertEquals("testUser", responseDto.getUserId());
    }

    @Test
    @DisplayName("아이디 찾기 실패")
    void findIdFailed() {
        // dto
        FindIdRequestDto findIdRequestDto = FindIdRequestDto.builder()
            .name("testName")
            .birth(LocalDate.of(2000, 1, 1))
            .build();

        // when
        when(userRepository.findByNameAndBirth("testName", LocalDate.of(2000, 1, 1)))
            .thenReturn(Optional.empty());

        // then
        assertThrows(CustomException.class, () -> userService.findId(findIdRequestDto));
    }

    @Test
    @DisplayName("비밀번호 찾기 성공")
    void findPwSuccess() {
        // dto
        FindPwRequestDto findPwRequestDto = new FindPwRequestDto().builder()
            .userId("testUser")
            .name("testUser")
            .build();

        // entity
        User user = User.builder()
            .userId("testUser")
            .password("testPassword")
            .name("testUser")
            .build();

        // when
        when(userRepository.findByIdAndName("testUser", "testUser")).thenReturn(Optional.of(user));

        // then
        userService.findPw(findPwRequestDto);
        assertEquals("yoyak123!!", user.getPassword());
    }

    @Test
    @DisplayName("비밀번호 찾기 실패")
    void findPwFailed() {
        // dto
        FindPwRequestDto findPwRequestDto = new FindPwRequestDto().builder()
            .userId("testUser")
            .name("testUser")
            .build();

        // entity
        User user = User.builder()
            .userId("testUser")
            .password("testPassword")
            .name("testUser")
            .build();

        // when
        when(userRepository.findByIdAndName("testUser", "testUser")).thenReturn(Optional.empty());

        // then
        assertThrows(CustomException.class, () -> userService.findPw(findPwRequestDto));
    }


    @Test
    @DisplayName("아이디 중복체크 성공 - 중복됨")
    void dupIdSuccess() {
        // dto
        DupIdRequestDto dupIdRequestDto = new DupIdRequestDto().builder()
            .userId("testUser")
            .build();

        // when
        when(userRepository.findByUserId("testUser")).thenReturn(Optional.of(new User()));

        // then
        assertThrows(CustomException.class, () -> userService.dupId(dupIdRequestDto));
    }

    @Test
    @DisplayName("아이디 중복체크 실패 - 중복 안됨")
    void dupIdFailed() {
        // dto
        DupIdRequestDto dupIdRequestDto = new DupIdRequestDto().builder()
            .userId("testUser2")
            .build();

        // when
        when(userRepository.findByUserId("testUser2")).thenReturn(Optional.empty());

        // then
        assertDoesNotThrow(() -> userService.dupId(dupIdRequestDto));
    }

    @Test
    @DisplayName("닉네임 중복체크 성공 - 중복됨")
    void dupNicknameSuccess() {
        // dto
        DupNicknameRequestDto dupNicknameRequestDto = new DupNicknameRequestDto().builder()
            .nickname("TestNick")
            .build();

        // when
        when(userRepository.findByNickname("TestNick")).thenReturn(Optional.of(new User()));

        // then
        assertThrows(CustomException.class, () -> userService.dupNickname(dupNicknameRequestDto));
    }

    @Test
    @DisplayName("닉네임 중복체크 실패 - 중복 안됨")
    void dupNicknameFailed() {
        // dto
        DupNicknameRequestDto dupNicknameRequestDto = new DupNicknameRequestDto().builder()
            .nickname("TestNick2")
            .build();

        // when
        when(userRepository.findByNickname("TestNick2")).thenReturn(Optional.empty());

        // then
        assertDoesNotThrow(() -> userService.dupNickname(dupNicknameRequestDto));
    }

    @Test
    @DisplayName("회원탈퇴 성공")
    void withdrawSuccess() {
        // Given
        Long userId = 1L;
        User user = new User();
        user.setSeq(userId);

        // when
        when(SecurityUtil.getUserSeq()).thenReturn(userId);
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));

        // then
        userService.withdraw(userId);
        verify(userRepository).delete(user);
    }

}