## 모기 알리미 (Mosquito Alarm)

###  서울시 모기 예보 데이터를 기반으로 실시간 모기 지수를 확인하고, 원하는 시간에 알림을 받아볼 수 있는 Flutter 기반 모바일 애플리케이션입니다.
### 프로젝트 기간 2025년 11월 08일 ~ 2025년 11월 18일

### 프로젝트 개요
여름철마다 우리를 괴롭히는 모기들이 오늘 얼마나 기승을 부릴지 미리 알 수 있다면 어떨까요? "오늘은 모기가 얼마나 나타날까?"라는 단순한 호기심에서 시작하여, 외출 전이나 잠들기 전 미리 대비할 수 있도록 도와주는 서비스를 구상하게 되었습니다.
서비스 소개
모기 알리미는 서울시에서 제공하는 공공 데이터를 활용하여 현재 모기 활동 지수를 직관적으로 보여주는 앱입니다. 특히, 사용자가 매일 확인하는 것을 잊지 않도록 직접 설정한 시간에 맞춰 푸시 알림(FCM)을 발송하여, 까먹지 않고 오늘의 모기 예보를 확인할 수 있도록 돕습니다.

### 대표 기능
1. 실시간 모기 지수 조회
   - 서울시 공공 데이터를 연동하여 오늘의 모기 발생 예보를 실시간으로 보여줍니다.
      - 3가지 환경별 지수 제공:
      - 주거지: 집 주변 모기 활동 지수
      - 공원: 산책이나 운동 시 참고할 지수
      - 수변지: 강가나 하천 근처 지수
         - 수치에 따라 **안전(초록) / 주의(노랑) / 위험(빨강)**으로 색상과 이미지가 변경되어 한눈에 위험도를 파악할 수 있습니다.
2. 사용자 맞춤형 알림 설정
   - 사용자가 원하는 시간을 자유롭게 설정할 수 있는 Time Picker 기능을 제공합니다.
   - 설정된 시간 정보는 Cloud Firestore에 저장됩니다.
   - 알림이 필요 없을 경우 언제든지 설정을 해제할 수 있습니다.
3. 스마트 푸시 알림 (FCM & Scheduler)
   - Firebase Functions와 스케줄러를 활용한 서버리스 아키텍처를 구현했습니다.
   - 매 1분마다 서버가 설정된 사용자 목록을 확인하고, 해당 시간에 예약된 사용자에게 정확히 FCM(Firebase Cloud Messaging) 푸시 알림을 전송합니다.
   <hr>


- 🛠️ 기술 스택 (Tech Stack)
   - 📱 Frontend (App)
      - Flutter: 크로스 플랫폼 앱 개발 프레임워크
      - Dart: 주 개발 언어
   - 🔥 Backend & Serverless
      - Google Firebase
      - Cloud Firestore: 사용자 알림 스케줄 데이터 저장 (NoSQL DB)
      - Cloud Messaging (FCM): 모바일 기기로 푸시 알림 전송
      - Cloud Functions: 백엔드 로직 및 스케줄러 구현 (TypeScript)
   - 📊 Data Source
      - 서울 열린데이터 광장 API: [서울시 모기예보제 정보](https://data.seoul.go.kr/dataList/OA-13285/S/1/datasetView.do)

### 📂 프로젝트 구조
#### ├── main.dart           # 앱 진입점 및 Firebase 초기화
#### ├── Intro_Page.dart     # 인트로 스플래시 화면
#### ├── main_Page.dart      # 모기 지수 표시 메인 화면
#### ├── user_Page.dart      # 알림 시간 설정 및 관리 화면
#### ├── MosAPI.dart         # 공공 데이터 API 호출 로직
#### ├── MosData.dart        # 데이터 모델 클래스
#### └── firebase_options.dart # Firebase 설정 파일

### 다운로드 링크 (다운로드 가능)
[서울시 모기예보제 애플리케이션 다운로드](https://drive.google.com/file/d/1fZuTdKZzFOowxu4vEKus1R_sqTARWzyz/view?usp=drive_link)

