# Download dependencies not in registries

FROM alpine:latest AS download
WORKDIR /opt/veracode/
RUN apk --upgrade --no-cache add curl
RUN curl -L -o /tmp/gradle-bin.zip https://services.gradle.org/distributions/gradle-8.7-bin.zip
RUN mkdir -p /opt/veracode/gradle && \
    unzip -d /opt/veracode/gradle /tmp/gradle-bin.zip

FROM ubuntu:latest

# Install requirements
# - Deps in Ubuntu registries
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    maven

# - Deps downloaded and installed independently
COPY --from=download /opt/veracode /opt/veracode

RUN mkdir -p /opt/gradle && \
    ln -s /opt/veracode/gradle/gradle-8.7 /opt/gradle/latest
ENV PATH="${PATH}:/opt/gradle/latest/bin"

# Run as limited user
RUN adduser luser --gecos "Local User" --disabled-password
USER luser
WORKDIR /home/luser
