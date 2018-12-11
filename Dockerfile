FROM maven:3.5.2-jdk-8-alpine

LABEL maintainer “info@daocloud.io"

COPY settings.xml /root/.m2/