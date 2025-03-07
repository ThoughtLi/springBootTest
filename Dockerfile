# 阶段1：Maven构建
FROM maven:3.8.6-eclipse-temurin-17-alpine as builder
WORKDIR /app
COPY ./springboot-Quartz/pom.xml .
RUN mvn dependency:go-offline
COPY ./springboot-Quartz/src ./src
RUN mvn package -DskipTests
# 阶段2：生产环境镜像
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar /app/app.jar
EXPOSE 8080
USER 65534:65534  # 使用非特权用户
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

