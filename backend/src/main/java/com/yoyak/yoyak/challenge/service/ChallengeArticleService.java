package com.yoyak.yoyak.challenge.service;

import com.yoyak.yoyak.challenge.domain.Challenge;
import com.yoyak.yoyak.challenge.domain.ChallengeArticle;
import com.yoyak.yoyak.challenge.domain.ChallengeArticleRepository;
import com.yoyak.yoyak.challenge.domain.Cheer;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
import com.yoyak.yoyak.challenge.dto.CheerRequestDto;
import com.yoyak.yoyak.user.domain.User;
import com.yoyak.yoyak.util.s3.AwsFileService;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@Slf4j
@RequiredArgsConstructor
public class ChallengeArticleService {
    private final ChallengeArticleRepository challengeArticleRepository;

    private final AwsFileService awsFileService;
    public void create(ChallengeArticleCreateDto dto, MultipartFile image) {
        log.info("dto: {}", dto);
        log.info("image: {}", image.getOriginalFilename());
        try{
            String url = awsFileService.saveFile(image);
            Challenge challenge = Challenge.builder()
                .seq(dto.getChallengeSeq())
                .build();
            User user = User.builder()
                .seq(dto.getUserSeq())
                .build();
            ChallengeArticle article = ChallengeArticle.builder()
                .content(dto.getContent())
                .user(user)
                .challenge(challenge)
                .imgUrl(url)
                .build();

            challengeArticleRepository.save(article);

        log.info("url: {}", url);
        }catch (Exception e){
            e.printStackTrace();
        }

    }

    public List<ChallengeArticleResponseDto> getArticles(Long userSeq) {
         return challengeArticleRepository.findArticlesExceptUserSeq(userSeq);
    }

    public List<ChallengeArticleResponseDto> getMyChallengeArticles(Long userSeq){
        return challengeArticleRepository.findMyArticles(userSeq);
    }

    public void cheerUp(CheerRequestDto cheerRequestDto){

    }

}
