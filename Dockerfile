# Build stage
FROM openjdk:17-jdk-slim as build

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/metabase/metabase.git /app

WORKDIR /app

RUN ./bin/build

# Final stage
FROM openjdk:17-jdk-slim

WORKDIR /opt/metabase

# Copy the built JAR from the build stage
COPY --from=build /app/target/uberjar/metabase.jar /opt/metabase/metabase.jar

# Set Environment variables
ENV MB_DB_TYPE="postgres"
ENV MB_DB_CONNECTION_URI="jdbc:postgresql://104.154.44.54:5432/metabase_db?user=postgres&password=23042002"

# Expose the default port
EXPOSE 3000

# Set the entry point
ENTRYPOINT ["java", "-jar", "/opt/metabase/metabase.jar"]
