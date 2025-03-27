FROM jenkins/jenkins:lts-jdk17
# root 계정으로 변경
USER root

# Docker 공식 GPG 키 추가 및 Docker 저장소 설정
RUN apt-get update && \
    apt-get upgrade -y &&\
    apt-get instll -y openssh-client
