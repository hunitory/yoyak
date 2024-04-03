package com.yoyak.yoyak.challenge.service;

import com.yoyak.yoyak.challenge.domain.Challenge;
import com.yoyak.yoyak.challenge.domain.ChallengeArticle;
import com.yoyak.yoyak.challenge.domain.ChallengeArticleRepository;
import com.yoyak.yoyak.challenge.domain.ChallengeRepository;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import com.yoyak.yoyak.util.s3.AwsFileService;
import com.yoyak.yoyak.util.security.SecurityUtil;

import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@Slf4j
@RequiredArgsConstructor
public class ChallengeArticleService {

    private final ChallengeArticleRepository challengeArticleRepository;

    private final AwsFileService awsFileService;

    private final ChallengeRepository challengeRepository;

    public void create(ChallengeArticleCreateDto dto, MultipartFile image) {
        log.info("dto: {}", dto);
        log.info("image: {}", image.getOriginalFilename());

        LocalDate createdDate = LocalDate.now();


        String url = awsFileService.saveFile(image);
        Challenge challenge = challengeRepository.findById(dto.getChallengeSeq())
            .orElseThrow(() -> new CustomException(CustomExceptionStatus.NO_CHALLENGE));

//        if(challengeArticleRepository.existsBySameCreateDateAndSameUser(createdDate, dto.getUserSeq()) ){
//            throw new CustomException(CustomExceptionStatus.ALREADY_POST);
//        }


        ChallengeArticle article = ChallengeArticle.builder()
            .content(dto.getContent())
            .userSeq(dto.getUserSeq())
            .imgUrl(url)
            .challenge(challenge)
            .createdDate(createdDate)
            .build();

        article = challengeArticleRepository.save(article);
        challenge.addArticle(article);
        log.info("url: {}", url);


    }

    public List<ChallengeArticleResponseDto> getArticlesExceptUserSeq() {
        Long userSeq = SecurityUtil.getUserSeq();
        log.info("userSeq: {}", userSeq);

        return challengeArticleRepository.findAllArticlesExceptUserSeq(userSeq);
    }

    public List<ChallengeArticleResponseDto> getAllArticles(){
        return challengeArticleRepository.findAllArticles();
    }

    public List<ChallengeArticleResponseDto> getMyChallengeArticles() {
        Long userSeq = SecurityUtil.getUserSeq();
        log.info("userSeq: {}", userSeq);
        return challengeArticleRepository.findMyArticles(userSeq);
    }

    @Transactional
    public int deleteByChallengeSeq(Long challengeSeq) {
        return challengeArticleRepository.deleteByChallengeSeq(challengeSeq);
    }


}
