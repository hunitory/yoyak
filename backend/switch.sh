#!/bin/bash
echo "> 현재 구동중인 Port 확인"
CURRENT_PROFILE=$(curl -s https://j10b102.p.ssafy.io/api2/test/profile)

if [ $CURRENT_PROFILE == prod1 ]
then
  CURRENT_PORT=9091
  IDLE_PORT=9092
elif [ $CURRENT_PROFILE == prod2 ]
then
  CURRENT_PORT=9092
  IDLE_PORT=9091
else
  echo "> 일치하는 Profile이 없습니다. Profile:$CURRENT_PROFILE"
  echo "> 9091을 할당합니다."
  IDLE_PORT=9091
fi

echo "> 현재 구동중인 Port: $CURRENT_PORT"
echo "> 전환할 Port : $IDLE_PORT"
echo "> Port 전환"
echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc

echo "> ${CURRENT_PROFILE} 컨테이너 삭제"
sudo docker stop $CURRENT_PROFILE
sudo docker rm $CURRENT_PROFILE

echo "> Nginx Reload"

sudo service nginx reload