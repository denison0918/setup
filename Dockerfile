# 기본 이미지 설정
FROM jenkins/jenkins:lts-jdk17
# root 계정으로 변경
USER root

# Docker 공식 GPG 키 추가 및 Docker 저장소 설정
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc 
