## Chapter. 4: kubectl

### 1. GKE 클러스터 생성
  ```
  # GKE 클러스터 'k8s' 생성
  $ gcloud container clusters create k8s \

  # GKE 클러스터 'k8s'에 접속하는 인증 정보 가져오기
  $ gke-gcloud-auth-plugin --version

  # 사용자에게 모든 리소스의 접속 권한 부여
  $ kubectl create clusterrolebinding user-cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=SOMEUSER@gmail.com

  # GKE 클러스터 'k8s' 삭제
  $ gcloud container clusters delete k8s --zone asia-northeast3
  ```   
<br/>

### 2. 쿠버네티스 기초
- 쿠버네티스 마스터: API 엔드포인트 제공, 컨테이너 스케줄링, 컨테이너 스케일링 등
- 쿠버네티스 노드: 도커 호스트에 해당, 실제로 컨테이너를 기동시키는 노드
- 쿠버네티스 클러스터를 관리하려면: CLI 도구인 kubectl과 메니페스트 파일(YAML, JSON 형식)을 사용하여 쿠버네티스 마스터에 '리소스' 등록
- kubectl은: 메니페스트 파일 정보를 바탕으로 쿠버네티스 마스터가 가진 API에 요청을 보내서 쿠버네티스 관리

### 3. 쿠버네티스 리소스
- 워크로드 API 카테고리: 클러스터 위에서 컨테이너를 기동하기 위해 사용되는 리소스
- 서비스 API 카테고리: 컨테이너 서비스 디스커버리와 클러스터 외부에서도 접속이 가능한 엔드포인트 등을 제공하는 리소스
- 컨피그 & 스토리지 API 카테고리: 설정과 기밀 데이터를 컨테이너에 담거나 영구 볼륨을 제공하는 리소스
- 클러스터 API 카테고리: 클러스터 자체 동작을 정의하는 리소스
- 메타데이터 API 카테고리: 클러스터 내부의 다른 리소스 동작을 제어하기 위한 리소스

### 4. 네임스페이스로 가상 클러스터 분리
- NameSpace: 가상적인 쿠버네티스 클러스터 분리 기능
- 하나의 쿠버네티스 클러스터를 여러 팀에서 사용하거나 서비스/스테이징/개발 환경으로 구분하는 경우 사용 가능
- 네임스페이스가 아닌 클러스터 별로 나누면 좋음
- kube-system, kube-public, kube-node-lease, default

### 5. CLI(Command Line Interface) 도구, kubectl
- 쿠버네티스에서 클러스터 조작은 모두 쿠버네티스 마스터의 API를 통해 이루어짐
```
# '컨텍스트' 전환

# 컨텍스트 정의
$ kubectl config set-context prd-admin \
--cluster=prd-cluster \
--user=admin-user \
--namespace=default

# 컨텍스트 목록 표시
$ kubectl config get-contexts

# 컨텍스트 전환
$ kubectl config use-context prd-admin

# 더 간단하게 컨텍스트 전환하는 법
$ kubectx docker-desktop

# 네임 스페이스 이름 바꾸기
$ kubens default
```

```
# '리소스' 생성/삭제/갱신

# 리소스 생성 (create 아닌 apply 사용)
$ kubectl apply -f sample-pod.yaml

# 파드 목록 표시
$ kubectl get pods

# 파드 삭제
$ kubectl delete -f sample-pod.yaml

# 특정 리소스만 삭제
$ kubectl delete pod sample-pod

# Deployment 리소스의 모든 파드 재기동
$ kubectl rollout restart deployment sample-deployment
```