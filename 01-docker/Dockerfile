# Dockerfile 
# Docker image는 Dockerfile을 기반으로 build된다 
# Dockerfile은 container image 작성 매뉴얼 같은 것이다 
# 아래 예제: HTTP 요청이 오면 main.go를 실행하는 container image의 생성 방법

# 기반 image 지정
FROM golang:1.14.1-alpine3.11

# container 실행 시 listen할 port 지정 
EXPOSE 8080

# build할 machine에 있는 main.go file을 container로 복사 
COPY ./main.go ./

# build 시 container 내부에서 명령어 실행
RUN go build -o ./go-app ./main.go

# 명령어 실행 계정을 nobody로 지정
USER nobody

# container가 가동할 때 실행할 명령어 정의
ENTRYPOINT ["./go-app"]