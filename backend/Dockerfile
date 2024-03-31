FROM openjdk:17
ARG IDLE_PROFILE
ENV ENV_IDLE_PROFILE=$IDLE_PROFILE
COPY build/libs/yoyak-0.0.1-SNAPSHOT.jar /app/app.jar
RUN echo $ENV_IDLE_PROFILE
ENTRYPOINT ["java", "-Dspring.profiles.active=${ENV_IDLE_PROFILE}", "-jar", "/app/app.jar"]