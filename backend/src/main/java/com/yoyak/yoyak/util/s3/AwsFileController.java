package com.yoyak.yoyak.util.s3;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * S3에 파일을 저장하기 위한 presigned url을 발급하는 컨트롤러
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/aws")
public class AwsFileController {

    private final AwsFileService awsFileService;


}
