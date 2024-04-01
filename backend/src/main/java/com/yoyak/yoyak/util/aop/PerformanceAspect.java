package com.yoyak.yoyak.util.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class PerformanceAspect {

    @Around("execution(* com.yoyak.yoyak.medicine.service..*.*(..))") // 대상 메소드 선택
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();

        Object proceed = joinPoint.proceed(); // 메소드 실행

        long executionTime = System.currentTimeMillis() - start;

        System.out.println(joinPoint.getSignature() + " 실행 시간 : " + executionTime + "ms");

        return proceed;
    }
}