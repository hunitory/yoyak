package com.yoyak.yoyak.challenge.controller;

import com.yoyak.yoyak.challenge.dto.ChallengeArticleCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeCreateDto;
import com.yoyak.yoyak.challenge.service.ChallengeService;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/challenge")
@CrossOrigin(originPatterns = "*")
public class ChallengeController {

    private final ChallengeService challengeService;

    @PostMapping()
    public ResponseEntity<Void> createChallenge(@RequestBody ChallengeCreateDto challengeCreateDto){
        log.info("challengeCreateDto: {}", challengeCreateDto);
        challengeService.create(challengeCreateDto);

        return ResponseEntity.ok().build();
    }

    @PostMapping("/post/{challengeSeq}")
    public ResponseEntity<Void> postChallengeArticle(@RequestParam("image")MultipartFile image, @RequestParam("content") String content){
        return null;

    }
}
