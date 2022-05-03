# Assemble
히어로 영화 정보 모음 DB앱

<br/>

## ⚙️ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.0-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.0-blue)]()
[![rxswift](https://img.shields.io/badge/RxSwift-6.2.0-green)]()
[![snapkit](https://img.shields.io/badge/SnapKit-5.0.1-yellow)]()

<br/>

## ⚒ 아키텍쳐

### ⏺ MVVM + Clean Architecture

> **MVVM**
- View Controller의 역할을 화면 구성에만 집중
- 데이터 처리/관리는 Model, View Model에게 부여

> **Clean Architecture**
- View Model의 비즈니스 로직은 Use Case로 다시 한 번 분리
- 네트워크 작업은 Repository를 통해 View Model에게 전달

> **Coordinator**
- 화면 전환 관리에 용이

<br/>

## 🔥 도전 사항

### ⏺ AWS
- RDS를 사용한 mySQL DB 구축
- API Gateway와 Lambda를 사용한 REST API 통신
- Lambda를 사용하여 주기적으로 DB 업데이트
### ⏺ PostMan
- DB로부터 값을 얻어오기 위한 수많은 API 관리
- Mock 서버를 이용하여 테스트 데이터 생성
### ⏺ RxSwift
- 가독성 좋고 효율적인 비동기형 작업
- 변경되는 데이터를 UI에 즉각적으로 반영
