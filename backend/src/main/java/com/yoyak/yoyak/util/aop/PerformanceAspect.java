package com.yoyak.yoyak.util.aop;

import java.util.Arrays;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
@Slf4j
public class PerformanceAspect {

    @Around("execution(* com.yoyak.yoyak.medicine.service..*.*(..))") // 대상 메소드 선택
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();

        String methodName = joinPoint.getSignature().getName();
        Object[] args = joinPoint.getArgs(); // 메소드 호출 시 사용된 파라미터를 얻습니다.

        // 파라미터를 문자열로 변환합니다.
        String parameters = Arrays.toString(args);
        
        Object proceed = joinPoint.proceed(); // 메소드 실행

        long executionTime = System.currentTimeMillis() - start;

        if ("findMedicineByKeyword".equals(methodName)) {
            log.info("기존 sql 조회 :" + parameters.replace("[", "").replace("]", "") + " "
                + executionTime + "ms");
        } else if ("findMedicineByFullText".equals(methodName)) {
            log.info(
                "elastic 조회  :" + parameters.replaceAll("[^가-힣]+", "") + " " + executionTime
                    + "ms");
        }

        return proceed;
    }
}