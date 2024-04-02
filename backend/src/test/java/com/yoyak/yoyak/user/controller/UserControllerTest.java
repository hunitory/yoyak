package com.yoyak.yoyak.user.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.yoyak.yoyak.user.domain.UserGender;
import com.yoyak.yoyak.user.dto.DupIdRequestDto;
import com.yoyak.yoyak.user.dto.DupNicknameRequestDto;
import com.yoyak.yoyak.user.dto.FindIdRequestDto;
import com.yoyak.yoyak.user.dto.FindIdResponseDto;
import com.yoyak.yoyak.user.dto.FindPwRequestDto;
import com.yoyak.yoyak.user.dto.LoginRequestDto;
import com.yoyak.yoyak.user.dto.SignInRequestDto;
import com.yoyak.yoyak.user.service.UserService;
import java.time.LocalDate;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;
    private ObjectMapper objectMapper = new ObjectMapper();
    private String token;

    @Mock
    private UserService userService;

    @Test
    @DisplayName("회원가입 성공")
    void signinUser() throws Exception {
        SignInRequestDto signInRequestDto = new SignInRequestDto().builder()
            .userId("testUser")
            .password("testPassword")
            .name("Test User")
            .nickname("TestNick")
            .gender(UserGender.M)
            .birth(LocalDate.of(2000, 1, 1))
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/signin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.registerModule(new JavaTimeModule())
                    .writeValueAsString(signInRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    @DisplayName("로그인 성공")
    void loginUserSuccess() throws Exception {
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("testUser")
            .password("testPassword")
            .build();

        when(userService.login(any(LoginRequestDto.class))).thenReturn("fakeToken");

        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.post("/api/user/login/origin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

        token = result.getResponse().getContentAsString();
        System.out.println("token : " + token);
    }

    @Test
    @DisplayName("로그인 실패")
    void loginUserFailed() throws Exception {
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("testUser2")
            .password("testPassword")
            .build();

        when(userService.login(any(LoginRequestDto.class))).thenReturn("fakenToken");

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/login/origin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequestDto)))
            .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }

    @Test
    @DisplayName("아이디 찾기 성공")
    void findIdSuccess() throws Exception {
        FindIdRequestDto findIdRequestDto = new FindIdRequestDto().builder()
            .name("Test User")
            .birth(LocalDate.of(2000, 1, 1))
            .build();
        FindIdResponseDto findIdResponseDto = new FindIdResponseDto("testUser");

        when(userService.findId(any(FindIdRequestDto.class)))
            .thenReturn(findIdResponseDto);

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/findid")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.registerModule(new JavaTimeModule())
                    .writeValueAsString(findIdRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.content()
                .json(objectMapper.writeValueAsString(findIdResponseDto)));
    }

    @Test
    @DisplayName("아이디 찾기 실패")
    void findIdFailed() throws Exception {
        FindIdRequestDto findIdRequestDto = new FindIdRequestDto().builder()
            .name("Test User2")
            .birth(LocalDate.of(2000, 1, 1))
            .build();
        FindIdResponseDto findIdResponseDto = new FindIdResponseDto("testUser");

        when(userService.findId(any(FindIdRequestDto.class)))
            .thenReturn(findIdResponseDto);

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/findid")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.registerModule(new JavaTimeModule())
                    .writeValueAsString(findIdRequestDto)))
            .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }

    @Test
    @DisplayName("비밀번호 찾기 성공")
    void findPwSuccess() throws Exception {
        FindPwRequestDto findPwRequestDto = new FindPwRequestDto().builder()
            .userId("testUser")
            .name("Test User")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/findpw")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.registerModule(new JavaTimeModule())
                    .writeValueAsString(findPwRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    @DisplayName("비밀번호 찾기 실패")
    void findPwFailed() throws Exception {
        FindPwRequestDto findPwRequestDto = new FindPwRequestDto().builder()
            .userId("testUser2")
            .name("Test User")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/findpw")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(findPwRequestDto)))
            .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }

    @Test
    @DisplayName("아이디 중복 성공")
    void dupIdSuccess() throws Exception {
        DupIdRequestDto dupIdRequestDto = new DupIdRequestDto().builder()
            .userId("testUser2")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/dupid")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(dupIdRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    @DisplayName("아이디 중복 실패")
    void dupIdFailed() throws Exception {
        DupIdRequestDto dupIdRequestDto = new DupIdRequestDto().builder()
            .userId("testUser")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/dupid")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(dupIdRequestDto)))
            .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }

    @Test
    @DisplayName("닉네임 중복 성공")
    void dupNicknameSuccess() throws Exception {
        DupNicknameRequestDto dupNicknameRequestDto = new DupNicknameRequestDto().builder()
            .nickname("TestNick2")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/dupnickname")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(dupNicknameRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    @DisplayName("닉네임 중복 실패")
    void dupNicknameFailed() throws Exception {
        DupNicknameRequestDto dupNicknameRequestDto = new DupNicknameRequestDto().builder()
            .nickname("TestNick")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/dupnickname")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(dupNicknameRequestDto)))
            .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }

    @Test
    @DisplayName("로그인 성공 후 회원탈퇴 성공")
    void withdrawUser() throws Exception {
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("testUser")
            .password("testPassword")
            .build();

        when(userService.login(any(LoginRequestDto.class))).thenReturn("fakeToken");

        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.post("/api/user/login/origin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

        token = result.getResponse().getContentAsString();
        System.out.println("token : " + token);

        mockMvc.perform(MockMvcRequestBuilders.delete("/api/user/withdraw")
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + token))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

}
