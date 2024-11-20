FROM openjdk:17-jdk-slim as build

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/metabase.git /app

WORKDIR /app

RUN ./bin/build

FROM openjdk:17-jdk-slim

COPY --from=build /app/target/uberjar/metabase.jar /opt/metabase/metabase.jar

# Set Environment variables
export MB_DB_TYPE="postgres"
export MB_DB_CONNECTION_URI="jdbc:postgresql://104.154.44.54:5432/metabase_db?user=postgres&password=23042002"


EXPOSE 3000

ENTRYPOINT ["java", "-jar", "/opt/metabase/metabase.jar"]

CMD["run"]