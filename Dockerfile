# ============================================
# Stage 1: Build Stage
# ============================================
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder

WORKDIR /app

# Copy pom.xml for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ============================================
# Stage 2: Extract layers (Spring Boot optimization)
# ============================================
FROM eclipse-temurin:21-jre-alpine AS extractor

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Extract Spring Boot layers for better caching
RUN java -Djarmode=layertools -jar app.jar extract

# ============================================
# Stage 3: Runtime Stage (Distroless)
# ============================================
FROM gcr.io/distroless/java21-debian12:nonroot

WORKDIR /app

# Copy extracted layers from previous stage
COPY --from=extractor /app/dependencies/ ./
COPY --from=extractor /app/spring-boot-loader/ ./
COPY --from=extractor /app/snapshot-dependencies/ ./
COPY --from=extractor /app/application/ ./

# Health check not supported in distroless directly
# Will be handled by Kubernetes probes

EXPOSE 8080

# Distroless already runs as non-root (user 65532)
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]