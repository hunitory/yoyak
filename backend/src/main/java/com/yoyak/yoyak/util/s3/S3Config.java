package com.yoyak.yoyak.util.s3;


import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;


@Configuration
public class S3Config {
    @Value("${cloud.aws.region.static}")
    private String region;

    @Value("${cloud.aws.credentials.access-key}")
    private String accessKey;

    @Value("${cloud.aws.credentials.secret-key}")
    private String secretKey;



    @Bean
    @Primary
    public BasicAWSCredentials basicAWSCredentials(){
        return new BasicAWSCredentials(accessKey, secretKey);
    }


    @Bean
    public AmazonS3 amazonS3(){
        return AmazonS3ClientBuilder.standard()
            .withRegion(region)
            .withCredentials(new AWSStaticCredentialsProvider(basicAWSCredentials()))
            .build();
    }

//    @Bean
//    public S3Client s3Client(){
//        return S3Client.builder()
//            .credentialsProvider(EnvironmentVariableCredentialsProvider.create())
//            .region(Region.AP_NORTHEAST_2)
//            .build();
//    }
//
//    @Bean
//    public S3Presigner presigner(){
//        return S3Presigner.builder()
//            .credentialsProvider(EnvironmentVariableCredentialsProvider.create())
//            .region(Region.AP_NORTHEAST_2)
//            .build();
//
//    }

}
