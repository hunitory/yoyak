package com.yoyak.yoyak.challenge.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import com.yoyak.yoyak.challenge.dto.ChallengeCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeResponseDto;
import com.yoyak.yoyak.challenge.dto.CheerRequestDto;
import com.yoyak.yoyak.challenge.service.ChallengeArticleService;
import com.yoyak.yoyak.challenge.service.ChallengeService;
import com.yoyak.yoyak.challenge.service.CheerService;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.security.SecurityUtil;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
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

    private final CheerService cheerService;

    @PostMapping()
    public ResponseEntity<Void> createChallenge(
        @RequestBody ChallengeCreateDto challengeCreateDto) {
        Long userSeq = SecurityUtil.getUserSeq();
        challengeCreateDto.setUserSeq(userSeq);
        log.info("challengeCreateDto: {}", challengeCreateDto);

        challengeService.create(challengeCreateDto);

        return ResponseEntity.ok().build();
    }

    @GetMapping()
    public ResponseEntity<ChallengeResponseDto> getEnrolledChallenge(){
        Long userSeq = SecurityUtil.getUserSeq();
        log.info("userSeq: {}", userSeq);

        return ResponseEntity.ok(challengeService.getEnrolledChallenge(userSeq));


    }

    @PostMapping("/article")
    public ResponseEntity<Object> postChallengeArticle(@RequestPart("image") MultipartFile image,
        @RequestPart("challengeArticleCreateDto") String challengeArticleCreateDto) {
        log.info("image: {}", image.getOriginalFilename());
        log.info("createDto: {}", challengeArticleCreateDto);
        try {
            ObjectMapper mapper = new ObjectMapper();
            ChallengeArticleCreateDto dto = mapper.readValue(challengeArticleCreateDto,
                ChallengeArticleCreateDto.class);

            Long userSeq = SecurityUtil.getUserSeq();
            dto.setUserSeq(userSeq);

            log.info("dto: {}", dto);

            challengeArticleService.create(dto, image);

            return ResponseEntity.ok().build();
<<<<<<< HEAD
        } catch (JsonProcessingException e) {
            log.error("JsonProcessingException: {}", e.getMessage());
            return ResponseEntity.badRequest().build();
        } catch(CustomException e){
            log.error("CustomException: {}", e.getMessage());
            StatusResponseDto statusResponseDto = StatusResponseDto.builder()
                .code(e.getStatus().getCode())
                .message(e.getStatus().getMessage())
                .build();
            return ResponseEntity.badRequest().body(statusResponseDto);
=======
        } catch(Exception e){
            log.error("error: {}", e);
            return ResponseEntity.badRequest().build();

>>>>>>> feature-BE/recognition
        }

    }

    @GetMapping("/article")
    public ResponseEntity<List<ChallengeArticleResponseDto>> getChallengeArticles() {
        return ResponseEntity.ok(challengeArticleService.getArticles());
    }

    @GetMapping("/article/my")
    public ResponseEntity<List<ChallengeArticleResponseDto>> getMyChallengeArticles() {
        return ResponseEntity.ok(challengeArticleService.getMyChallengeArticles());
    }

    @PutMapping("/article/cheer-up")
    public ResponseEntity<Object> cheerUp(@RequestBody CheerRequestDto cheerRequestDto) {
        try {
            Long userSeq = SecurityUtil.getUserSeq();
            cheerRequestDto.setUserSeq(userSeq);
            log.info("cheerRequestDto: {}", cheerRequestDto);
            cheerService.addCheer(cheerRequestDto);
            return ResponseEntity.ok().build();
        } catch (CustomException e) {
            StatusResponseDto statusResponseDto = StatusResponseDto.builder()
                .code(e.getStatus().getCode())
                .message(e.getStatus().getMessage())
                .build();
            return ResponseEntity.badRequest().body(statusResponseDto);

        }
    }

    // 하루에 한번 날짜가 바뀌면 실행
    @Scheduled(cron = "0 0 0 * * ?")
    public void checkChallengeDeadline(){

        challengeService.checkChallengeDeadline();
    }


}
