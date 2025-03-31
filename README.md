# Jenkins 접속

아래 명령어들 중 하나를 선택해 초기 비밀번호 확인

- /var/jenkins_home 경로는 마운트된 볼륨이므로 호스트 서버에서도 확인 가능

# 서버에서 확인

- $ sudo cat /var/jenkins_home/secrets/initialAdminPassword

# docker-compose 설치

- $ sudo curl -SL "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
- $ sudo chmod +x /usr/local/bin/docker-compose
- $ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
- $ docker-compose --version


