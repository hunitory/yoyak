FROM openjdk:17
ARG IDLE_PROFILE
ARG JAR_FILE=build/libs/*.jar
ENV ENV_IDLE_PROFILE=$IDLE_PROFILE
ADD /build/libs/*.jar app.jar
COPY ${JAR_FILE} app.jar
RUN echo $ENV_IDLE_PROFILE
ENTRYPOINT ["java", "-Dspring.profiles.active=${ENV_IDLE_PROFILE}", "-jar","/app.jar"]