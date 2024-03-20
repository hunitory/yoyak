package com.yoyak.yoyak.challenge.service;

import com.yoyak.yoyak.challenge.domain.Challenge;
import com.yoyak.yoyak.challenge.domain.ChallengeArticle;
import com.yoyak.yoyak.challenge.domain.ChallengeArticleRepsoitory;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleCreateDto;
import com.yoyak.yoyak.challenge.dto.ChallengeArticleResponseDto;
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
    private final ChallengeArticleRepsoitory challengeArticleRepsoitory;

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

            challengeArticleRepsoitory.save(article);

        log.info("url: {}", url);
        }catch (Exception e){
            e.printStackTrace();
        }

    }

    public List<ChallengeArticleResponseDto> getArticles() {
         return challengeArticleRepsoitory.findAll()
             .stream()
             .map(article-> {
                     User user = article.getChallenge().getUser();

                 ChallengeArticleResponseDto dto = ChallengeArticleResponseDto.builder()
                     .seq(article.getSeq())
                     .userNickname(user.getNickname())
                    .userSeq(user.getSeq())
                     .challengeSeq(article.getChallenge().getSeq())
                     .content(article.getContent())
                     .imgUrl(article.getImgUrl())
                     .cheer(article.getCheer())
                     .build();

                 return dto;
             }
             )
             .collect(Collectors.toList());
    }

    public List<ChallengeArticleResponseDto> getMyChallengeArticles(Long userSeq){
        return challengeArticleRepsoitory.findByUserSeq(userSeq)
            .stream()
            .map(article-> {
                    User user = article.getChallenge().getUser();

                ChallengeArticleResponseDto dto = ChallengeArticleResponseDto.builder()
                    .seq(article.getSeq())
                    .userNickname(user.getNickname())
                    .userSeq(user.getSeq())
                    .challengeSeq(article.getChallenge().getSeq())
                    .content(article.getContent())
                    .imgUrl(article.getImgUrl())
                    .cheer(article.getCheer())
                    .build();

                return dto;
            }
            )
            .collect(Collectors.toList());
    }

}
