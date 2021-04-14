# Build - Stage0
#FROM mcr.microsoft.com/java/jdk:11-zulu-alpine as build
FROM gradle:jdk11 AS build

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon

# Run - Stage1
FROM mcr.microsoft.com/java/jdk:11-zulu-alpine

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=build /build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]