package com.yoyak.yoyak.user.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {

    @Autowired
    ObjectMapper objectMapper;
    @Mock
    private UserService userService;
    @InjectMocks
    private UserController userController;
    @Autowired
    private MockMvc mockMvc;

    @Test
    void loginUser() throws Exception {
        LoginRequestDto loginRequestDto = new LoginRequestDto().builder()
            .userId("testUser")
            .password("testPassword")
            .build();

        when(userService.login(any(LoginRequestDto.class))).thenReturn("fakeToken");

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/login/origin")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.content().string("fakeToken"));
    }


    @Test
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
                .content(objectMapper.writeValueAsString(signInRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    void findId() throws Exception {
        FindIdRequestDto findIdRequestDto = new FindIdRequestDto().builder()
            .name("Test User")
            .birth(LocalDate.of(2000, 1, 1))
            .build();
        FindIdResponseDto findIdResponseDto = new FindIdResponseDto("testUser");

        when(userService.findId(any(FindIdRequestDto.class)))
            .thenReturn(findIdResponseDto);

        when(userService.findId(any(FindIdRequestDto.class)))
            .thenReturn(new FindIdResponseDto("testUser"));

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/findid")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(findIdRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.content()
                .json(objectMapper.writeValueAsString(findIdResponseDto)));
    }

    @Test
    void findPw() throws Exception {
        FindPwRequestDto findPwRequestDto = new FindPwRequestDto().builder()
            .userId("testUser")
            .name("Test User")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/findpw")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(findPwRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    void dupId() throws Exception {
        DupIdRequestDto dupIdRequestDto = new DupIdRequestDto().builder()
            .userId("testUser")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/dupid")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(dupIdRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    void dupNickname() throws Exception {
        DupNicknameRequestDto dupNicknameRequestDto = new DupNicknameRequestDto().builder()
            .nickname("TestNick")
            .build();

        mockMvc.perform(MockMvcRequestBuilders.post("/api/user/dupnickname")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(dupNicknameRequestDto)))
            .andExpect(MockMvcResultMatchers.status().isOk());
    }
}
