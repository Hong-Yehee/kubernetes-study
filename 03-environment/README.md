## Chapter. 3: Kubernetes Environment

### 1. 로컬 쿠버네티스
- 물리머신 한 대에 구축하여 사용, 이중화 되어 있지 않음
- 개인적 테스트나 개발 O, 서비스 환경 X
- Minikube, Docker, kind

① Minikube 클러스터
```
# 미니큐브 설치
$ curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.25.1/minikube-darwin-arm64 \ && chmod +x minikube
$ sudo install minikube /usr/local/bin/minikube

# 미니큐브 실행
$ minikube start --driver=docker

# 미니큐브 클러스터 상태 확인
$ minikube status

# 미니큐브 클러스터 정지
$ minikube stop

# 미니큐브 클러스터 삭제
$ minikube delete
```

② Docker 클러스터
```
# kubectl 설치
$ arch -arm64 brew install kubectl

# 컨텍스트 전환
$ kubectl config use-context docker-desktop

# 노드 확인
$ kubectl get nodes

# 기동 중인 쿠버네티스 관련 구성 요소 확인
$ docker container ls --format 'table {{.Image}}\t{{.Command}}' | grep -v pause
```

③ kind(kubernetes in Docker) 클러스터
- 쿠버네티스 자체 개발을 위한 도구(멀티 노드 클러스터 구축)
- 도커 컨테이너를 여러 개 기동하고, 그 컨테이너를 쿠버네티스 노드로 사용
- 구성 설정은 YAML 파일로 관리할 수 있음
```
# kind 설치
$ arch -arm64 brew install kind

# kind에서 쿠버네티스 클러스터 기동 (그 전에 Docker 기동되고 있어야 함)
$ kind create cluster --config kind.yaml --name kindcluster

# 컨텍스트 전환
$ kubectl config use-context kind-kindcluster

# 노드 확인
$ kubectl get nodes

# 도커 컨테이너 확인
$ docker container ls

# kind 클러스터 삭제
$ kind delete cluster --name kindcluster

# 알파 기능을 활성화한 쿠버네티스 클러스터 구축
# kind는 내부에서 kubeadm이라는 구축 도구를 사용함
$ kind create cluster --name kind-alpha-cluster --config kind-alpha.yaml
```
<br/>

### 2. 쿠버네티스 구축 도구
- 도구를 사용하여 온프레미스/클라우드에 클러스터를 구축하여 사용
- 온프레미스에 배포하거나 세밀한 커스터마이즈가 필요한 경우에 사용
- 개발 / 스테이징 / 서비스 환경용 클러스터 O
- kubeadm, Rancher

① kubeadm(큐브어드민): 쿠버네티스에서 제공하는 공식 구축 도구
```
# 필요한 의존 패키지 설치
$ sudo apt update && sudo apt install -y -apt-transport-https curl

# 저장소 등록 및 업데이트
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
$ sudo apt update

# 쿠버네티스 관련 패키지 설치
$ sudo apt install -y kubelet=1.18.15-00 kubeadm=1.18.15-00 dubectl=1.18.15-00 docker.io

# 버전 고정
$ sudo apt-mark hold kubelet kubeadm kubectl docker-io

# 오버레이 네트워크용 커널 파라미터 변경
$ cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
# sudo sysctl --system
```

```
# kubeadm 초기화(쿠버네티스 마스터 구축)
$ sudo kubeadm init \
--kubernetes-version=1.18.15 \
--pod-network-cidr=172.31.0.0/16

# Kubernetes 클러스터에 조인(쿠버네티스 노드 위에서 실행)
$ sudo kubeadm join 172.31.2.189:6443 --token zpn5s6.jcx9h6k3a78znd3p \
--discovery-token-ca-cert-hash \ sha256:983f234b2c7641e817205f16270547ccc1da2a5360aac2abb767b2352ada464e

# 인증용 파일 복사
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

② Flannel(플라넬): 노트 사이를 연결하는 네트워크에 가상 터널을 구성하여 쿠버네티스 클러스터 내부의 파드 간 통신 구현
```
# 플라넬 배포
$ kubectl apply -f \
  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

③ Rancher(랜처): 중앙에서 랜처 서버를 기동시키고 관리자는 랜처 서버를 통해 쿠버네티스 클러스터를 구축 및 관리
```
# Rancher Server 기동, https://호스트 IP로 웹 UI 표시
$ sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/
  rancher:v2.3.5
```
<br/>

### 3. 관리형 쿠버네티스 서비스
- 퍼블릭 클라우드의 관리형 서비스로 제공하는 클러스터 사용
- 개발 / 스테이징 / 서비스 환경용 클러스터 O
- GKE, AKS, EKS

① GKE(Google Kubernetes Engine)
- 쿠버네티스 노드: GCE(Google Compute Engine)
- GCP(Google Cloud Platform)의 여러 기능과 통합
- NodePool: 쿠버네티스 클러스터 내부 노드에 레이블을 부여하여 그룹핑하는 기능
```
# Google Cloud SDK 설치
$ curl https://sdk.cloud.google.com | bash

# 설치한 gcloud 명령어를 사용할 수 있도록 셸 재기동
$ exec -l $SHELL

# gcloud CLI 인증
$ gcloud init
```

```
# GKE에서 사용 가능한 쿠버네티스 버전 확인
$ gcloud container get-server-config --zone asia-northeast3-a

# GKE 클러스터 'k8s' 생성
$ gcloud container clusters create k8s \
--cluster-version 1.18.16-gke.2100 \
--zone asia-northeast3-a \
--num-nodes 3
```

② AKS(Azure Kubernetes Service)
- Microsoft Azure에서 동작하는 관리형 쿠버네티스 서비스
- ACI(Azure Container Istances)에 bursting하는 기능 제공
- 리소스 그룹을 만든 후 AKS 클러스터 생성

③ EKS(Elastic Kubernetes Service)
- AWS의 관리형 쿠버네티스 서비스
- IAM(Identity and Access Management)을 기반으로 쿠버네티스 사용자를 연결하여 권한을 관리할 수 있는 기능
- 파드 네트워크와 AWS VPC의 서브넷이 직접 연결되어 가상 머신에서 컨테이너로 직접 통신할 수 있는 네트워크 구성 가능
- 일반적으로 EC2 인스턴스를 쿠버네티스 노드로 사용

