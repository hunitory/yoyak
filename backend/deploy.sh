#!/bin/bash
echo "> 현재 구동중인 profile 확인"
CURRENT_PROFILE=$(curl -s http://localhost/api2/test/profile)
echo "> $CURRENT_PROFILE"

if [ $CURRENT_PROFILE == prod1 ]
then
  IDLE_PROFILE=prod2
  IDLE_PORT=9092
elif [ $CURRENT_PROFILE == prod2 ]
then
  IDLE_PROFILE=prod1
  IDLE_PORT=9091
else
  echo "> 일치하는 Profile이 없습니다. Profile: $CURRENT_PROFILE"
  echo "> prod1을 할당합니다. IDLE_PROFILE: prod1"
  IDLE_PROFILE=prod1
  IDLE_PORT=9091
fi

IMAGE_NAME=app_server
TAG_ID=$(docker images | sort -r -k2 -h | grep "${IMAGE_NAME}" | awk 'BEGIN{tag = 1} NR==1{tag += $2} END{print tag}')

echo "> 도커 build 실행 : docker build --build-arg IDLE_PROFILE=${IDLE_PROFILE} -t ${IMAGE_NAME}:${TAG_ID} ."
docker build --build-arg IDLE_PROFILE=${IDLE_PROFILE} -t ${IMAGE_NAME}:${TAG_ID} .

echo "> $IDLE_PROFILE 배포"
echo "> 도커 run 실행 :  sudo docker run --name $IDLE_PROFILE -d --rm -p $IDLE_PORT:${IDLE_PORT} ${IMAGE_NAME}:${TAG_ID}"
docker run --name $IDLE_PROFILE -d --rm -p $IDLE_PORT:${IDLE_PORT} ${IMAGE_NAME}:${TAG_ID}

echo "> $IDLE_PROFILE 10초 후 Health check 시작"
echo "> curl -s http://localhost:$IDLE_PORT/actuator/health "
sleep 10

for retry_count in {1..10}
do
  response=$(curl -s http://localhost:$IDLE_PORT/actuator/health)
  up_count=$(echo $response | grep 'UP' | wc -l)

  if [ $up_count -ge 1 ]
  then
    echo "> Health check 성공"
    break
  else
    echo "> Health check의 응답을 알 수 없거나 혹은 status가 UP이 아닙니다."
    echo "> Health check: ${response}"
  fi

  if [ $retry_count -eq 10 ]
  then
    echo "> Health check 실패. "
    echo "> Nginx에 연결하지 않고 배포를 종료합니다."
    exit 1
  fi

  echo "> Health check 연결 실패. 재시도..."
  sleep 10
done

echo "> 스위칭을 시도합니다..."
sleep 5

/home/ubuntu/jenkins-data/workspace/nginx/backend/switch.sh