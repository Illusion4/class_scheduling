    FROM gradle:7-jdk11 AS build

    WORKDIR /app
    
    COPY system.properties build.gradle settings.gradle pre-commit.gradle liquibase.gradle gradlew .
    COPY src /app/src
    COPY config /app/config

    RUN gradle war
    
    FROM tomcat:9.0.93-jdk11 AS tomcat

    RUN apt-get update && apt-get install -y postgresql-client
    
    COPY --from=build /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

    COPY scripts/ /scripts/
    RUN chmod +x /scripts/*.sh

    EXPOSE 8080
    
    CMD ["catalina.sh", "run"]
    