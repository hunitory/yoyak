package com.yoyak.yoyak.util.s3;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * S3에 파일을 저장하기 위한 presigned url을 발급하는 컨트롤러
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/aws")
public class AwsFileController {
    private final AwsFileService awsFileService;

    @GetMapping("/file/{filename}")
    public ResponseEntity<String> getFile(@PathVariable String filename){
        String presignedUrl = awsFileService.getPresignedUrl("", filename);
        return ResponseEntity.ok(presignedUrl);
    }

    @PostMapping("/file/upload")
    public ResponseEntity<Object> uploadFile(@RequestParam("url") String url, @RequestParam("file") MultipartFile file){
        log.info("url: {}", url);
        return ResponseEntity.ok().build();
    }

}
