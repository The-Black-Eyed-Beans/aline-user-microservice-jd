FROM openjdk:11
ARG JAR_FILE=user-microservice/target/*.jar
COPY ${JAR_FILE} aline-demo.jar
ENTRYPOINT ["java","-jar","aline-demo.jar"]
