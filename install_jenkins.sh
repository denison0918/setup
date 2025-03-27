#!/bin/bash

IMAGE_NAME="server/jenkins"
CONTAINER_NAME="server-jenkins"

IMAGE_ID=$(sudo docker images -q $IMAGE_NAME)
CONTAINER_ID=$(sudo docker ps -aqf "name=$CONTAINER_NAME")

echo ">>> CURRENT DOCKER INFORMATION:"
echo "$IMAGE_NAME IMAGE_ID: $IMAGE_ID"
echo -e "$CONTAINER_NAME CONTAINER_ID: $CONTAINER_ID\n"


# Stop & Remove Existing Container
echo ">>> $CONTAINER_NAME 컨테이너 실행 여부 검사 시작..."
if [ ! -z "$CONTAINER_ID" ]; then
    # docker stop $(docker ps -aq --filter "name=$CONTAINER_NAME")
    # docker rm $(docker ps -ap --filter "name=$CONTAINER_NAME")
    echo -e ">>> 실행중인 $CONTAINER_NAME 컨테이너 중지 및 삭제 시작...\n"

    echo ">>> 실행중인 $CONTAINER_NAME 컨테이너 중지 시작..."
    sudo docker stop $CONTAINER_ID || {
        echo ">>> $CONTAINER_NAME 컨테이너 중지 실패."
        exit 1
    }
    echo -e ">>> 실행중인 $CONTAINER_NAME 컨테이너 중지 완료.\n"

    echo ">>> 중지상태인 $CONTAINER_NAME 컨테이너 삭제 시작..."
    sudo docker rm $CONTAINER_ID || {
        echo ">>> $CONTAINER_NAME 컨테이너 삭제 실패."
        exit 1
    }
    echo -e ">>> 중지상태인 $CONTAINER_NAME 컨테이너 삭제 완료.\n"

    echo ">>> 실행중인 $CONTAINER_NAME 컨테이너 중지 및 삭제 완료."
fi
echo -e ">>> $CONTAINER_NAME 컨테이너 실행 여부 검사 완료.\n"


# Remove Existing Docker Image
echo ">>> $IMAGE_NAME 이미지 존재 여부 검사 시작..."
if [ ! -z "$IMAGE_ID" ]; then
    # docker rmi -f $(docker image -q $IMAGE_NAME)
    echo ">>> 기존 $IMAGE_NAME 이미지 삭제 시작..."
    sudo docker rmi $IMAGE_ID || {
        echo ">>> 기존 $IMAGE_NAME 이미지 삭제 실패."
        exit 1
    }
    echo ">>> 기존 $IMAGE_NAME 이미지 삭제 완료."
fi
echo -e ">>> $IMAGE_NAME 이미지 존재 여부 검사 완료.\n"


# Build Docker Image

# 현재 사용자의 UID와 Docker 그룹의 GID 추출
GROUP_GID=$(getent group docker | cut -d: -f3)
USER_UID=$(id -u $USER)

# Docker 이미지를 빌드하면서 사용자 UID와 그룹 GID를 인자로 전달
echo ">>> $IMAGE_NAME 이미지 빌드 시작..."
sudo docker build -t $IMAGE_NAME . \
  --build-arg USER_UID=$USER_UID \
  --build-arg GROUP_GID=$GROUP_GID || {
    echo ">>> $IMAGE_NAME 이미지 빌드 실패."
    exit 1
}
echo -e ">>> $IMAGE_NAME 이미지 빌드 완료.\n"


# Run Docker Container (USER jenkins)
echo ">>> $CONTAINER_NAME 컨테이너 실행 시작..."
sudo chown -R 1000:1000 /var/jenkins_home
sudo docker run -d \
    -p 8180:8080 -p 50000:50000 \
    -v /var/jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name $CONTAINER_NAME $IMAGE_NAME || {
        echo ">>> $CONTAINER_NAME 컨테이너 실행 실패."
        exit 1
    }
echo ">>> $CONTAINER_NAME 컨테이너 실행 완료."


## Run Docker Container (USER root)
#echo ">>> $CONTAINER_NAME 컨테이너 실행 시작..."
#sudo docker run -d -u root \
#    -p 8081:8080 -p 50000:50000 \
#    -v /var/jenkins_home:/var/jenkins_home \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    --name $CONTAINER_NAME $IMAGE_NAME || {
#        echo ">>> $CONTAINER_NAME 컨테이너 실행 실패."
#        exit 1
#    }
#echo ">>> $CONTAINER_NAME 컨테이너 실행 완료."
