package com.yoyak.yoyak.challenge.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import com.yoyak.yoyak.challenge.dto.ChallengeCreateDto;
import com.yoyak.yoyak.challenge.dto.CheerRequestDto;
import com.yoyak.yoyak.challenge.service.ChallengeArticleService;
import com.yoyak.yoyak.challenge.service.ChallengeService;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/challenge")
@CrossOrigin(originPatterns = "*")
public class ChallengeController {

    private final ChallengeService challengeService;

    private final ChallengeArticleService challengeArticleService;



    @PostMapping()
    public ResponseEntity<Void> createChallenge(@RequestBody ChallengeCreateDto challengeCreateDto){
        log.info("challengeCreateDto: {}", challengeCreateDto);
        challengeService.create(challengeCreateDto);

        return ResponseEntity.ok().build();
    }

    @PostMapping("/article")
    public ResponseEntity<Void> postChallengeArticle(@RequestPart("image")MultipartFile image, @RequestPart("challengeArticleCreateDto") String challengeArticleCreateDto) {
        log.info("image: {}", image.getOriginalFilename());
        log.info("createDto: {}", challengeArticleCreateDto);
        try {
            ObjectMapper mapper = new ObjectMapper();
            ChallengeArticleCreateDto dto = mapper.readValue(challengeArticleCreateDto, ChallengeArticleCreateDto.class);

            log.info("dto: {}", dto);


            challengeArticleService.create(dto, image);


            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/article")
    public ResponseEntity<List<ChallengeArticleResponseDto>> getChallengeArticles(@RequestParam("userSeq") Long userSeq){
        return ResponseEntity.ok(challengeArticleService.getArticles(userSeq));
    }

    @GetMapping("/{userSeq}")
    public ResponseEntity<List<ChallengeArticleResponseDto>> getMyChallengeArticles(@PathVariable Long userSeq){
        return ResponseEntity.ok(challengeArticleService.getMyChallengeArticles(userSeq));
    }

    @PutMapping("/article/cheer-up")
    public ResponseEntity<Void> cheerUp(@RequestBody CheerRequestDto cheerRequestDto){
        challengeArticleService.cheerUp(cheerRequestDto);
        return ResponseEntity.ok().build();
    }


}
