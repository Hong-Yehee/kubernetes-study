## Chapter. 1: Docker

```
# docker image 다운로드
$ IMAGES=(
  alpine:3.11
)
$ for IMAGE in $IMAGES[@]; do
  docker image pull ${IMAGE};
done

# docker image 확인
$ docker image ls
```

```
# Dockerfile로 sample-image:0.1 image build
$ docker image build -t sample-image:0.1 .

# MultiStage build용 Dockerfile로 sample-image:0.2 image build
$ docker image build -t sample-image:0.2 -f Dockerfile-MultiStage .

# alpine image 대신 scratch image를 사용해서 MultiStage build
$ docker image build -t sample-image:0.3 -f Dockerfile-Scratch .
```

```
# docker hub에 login
$ docker login

# image tag 변경
$ docker image tag sample-image:0.1 DOCKERHUB_USER/sample-image:0.1

# docker hub에 image upload
$ docker image push DOCKERHUB_USER/sample-image:0.1

# push할 이름을 직접 지정해서 build
$ docker image build -t DOCKERHUB_USER/sample-image:0.1 .

# docer hub에서 logout
$ docker logout
```

```
# docker container 기동(localhost:12345 port를 8080/TCP port로 전송)
$ docker container run -d -p 12345:8080 sample-image:0.1

# application 동작 확인
$ curl http://localhost:12345
```