package com.yoyak.yoyak;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class YoyakApplication {

    public static void main(String[] args) {
        SpringApplication.run(YoyakApplication.class, args);
    }

//    public static final String APPLICATION_LOCATIONS = "spring.config.location="
//        + "classpath:application.yml";
//
//    public static void main(String[] args) {
//        new SpringApplicationBuilder(YoyakApplication.class)
//            .properties(APPLICATION_LOCATIONS)
//            .run(args);
//    }

}
