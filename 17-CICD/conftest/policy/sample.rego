# Conftest
# 매니페스트 파일을 유닛 테스트하는 OSS
package main

deny[msg] {
  input.kind == "Deployment"
  not (input.spec.selector.matchLabels.app == input.spec.template.metadata.labels.app)
  msg = sprintf("Pod Template와 Selector에는 같은 app 레이블을 부여해주세요: %s", [input.metadata.name])
}