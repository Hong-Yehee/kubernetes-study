## Chapter. 17: CI/CD in kubernetes environment
- 실제 운영 환경에서 수동으로 kubectl 명령어를 실행하는 것은 가능한 피해야 함
- 자동으로 CI/CD를 수행하는 파이프라인 구축
- IaC(Infrastructure as Code)는 Git 저장소에서 관리하는 것이 일반적
- Git 저장소에 저장된 매니페스트 파일을 자동 배포하는 구조를 만들어야 함

### CI/CI
- 지속적인 통합(Continuous Integration)
- build -> test -> merge
<br/>
- 지속적인 배포(Continuous Delivery & Deployment)
- automatically release to repository
- automatically deploy to production

### GitOps(깃옵스)
- Git을 사용한 CI/CD 방법 중 하나
- 애플리케이션 배포와 운영에 관련된 모든 요소를 코드화하여 깃(Git)에서 관리(Ops)하는 것
- 쿠버네티스 클러스터 조작을 깃 저장소를 통해 실시하므로 수동으로 실행할 필요가 없음
- 깃 저장소: ①애플리케이션 소스 코드 저장소, ②쿠버네티스 매니페스트 관리용 저장소
- 매니페스트는 당시 클러스터에 적용된 리소스 상태와 동일하기 때문에 클러스터 상태를 코드로 관리(IaC)할 수 있음(클러스터 복원 가능)
<br/>
- 깃옵스 동작 흐름:
  1. 개발자가 소스코드 변경사항을 커밋함
  2. 자동으로 테스트, 컨테이너 이미지 생성, 컨테이너 레지스트리로 이미지 푸시 등(CI) 이루어짐
  3. 매니페스트 깃 저장소에 이미지 태그를 변경하는 PR(Pull Request) 보내짐
  4. 개발자는 변경점을 확인하고 문제가 없다면 병합함
  5. 배포 에이전트가 매니페스트를 가져와서 애플리케이션에 적용함