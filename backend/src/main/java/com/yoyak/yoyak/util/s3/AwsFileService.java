package com.yoyak.yoyak.util.s3;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.Headers;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import java.net.URL;
import java.util.Date;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.s3.S3Client;

/**
 * PresignedURL을 발급하는 로직
 */
@Service
@RequiredArgsConstructor
public class AwsFileService {
    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    private final AmazonS3 amazonS3;

    public String getPresignedUrl(String prefix, String filename){
        if(!prefix.isEmpty())
            filename = createPath(prefix, filename);

        GeneratePresignedUrlRequest generatePresignedUrlRequest = getGeneratePresignedUrlRequest(bucket, filename);
        URL url = amazonS3.generatePresignedUrl(generatePresignedUrlRequest);
        return url.toString();
    }

    /**
     * 파일 업로드 용(put) presigned url 생성
     * @param bucket 버킷이름
     * @param filename S3 업로드용 파일 이름
     * @return presigned url
     */
    private GeneratePresignedUrlRequest getGeneratePresignedUrlRequest(String bucket, String filename) {
        GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(bucket, filename)
            .withMethod(HttpMethod.PUT)
            .withExpiration(getPreSignedUrlExpiration());

        generatePresignedUrlRequest.addRequestParameter(Headers.S3_CANNED_ACL, CannedAccessControlList.PublicRead.toString());

        return generatePresignedUrlRequest;
    }

    /**
     * presigned url 유효 기간 설정
     * @return 유효기간
     */
    private Date getPreSignedUrlExpiration() {
        Date expiration = new Date();
        long expTimeMillis = expiration.getTime();
        expTimeMillis += 1000 * 60 * 2; // 2분
        expiration.setTime(expTimeMillis);
        return expiration;
    }


    // UUID 생성
    private String createFileId(){
        return UUID.randomUUID().toString();
    }

    // 저장될 파일 경로를 UUID 이어붙여서 생성
    private String createPath(String prefix, String filename) {
        String fileId = createFileId();
        return String.format("%s/%s", prefix, fileId + "-" + filename);
    }
}
