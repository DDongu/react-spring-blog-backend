# 1️⃣ Build Stage (Gradle 빌드)
FROM openjdk:17-jdk-slim AS builder

# 작업 디렉토리 설정
WORKDIR /app

# Gradle Wrapper 및 설정 파일 복사
COPY gradlew gradlew.bat build.gradle settings.gradle /app/
COPY gradle /app/gradle

# 실행 권한 부여
RUN chmod +x ./gradlew

# 소스 코드 복사
COPY src /app/src

# 빌드 실행 (테스트 제외)
RUN ./gradlew build --no-daemon -x test

# 2️⃣ Production Stage (최종 실행)
FROM openjdk:17-jdk-slim

# 작업 디렉토리 설정
WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=builder /app/build/libs/*.jar /app/app.jar

# 컨테이너가 열어줄 포트 지정
EXPOSE 8080

# 애플리케이션 실행
CMD ["java", "-jar", "/app/app.jar"]