# CleanArchitecture

# 클린 아키텍처란?

클린 아키텍처는 **비즈니스 로직(도메인)**, **데이터 접근(데이터)**, **UI와 사용자 상호작용(프리젠테이션)** 을 각기 다른 레이어로 분리하여,   
각 영역이 서로 독립적으로 변경될 수 있도록 돕는 구조입니다.   
이를 통해 **테스트 용이성**, **유지보수성**, **확장성**을 보장합니다.

---

<img width="300" alt="image" src="https://github.com/user-attachments/assets/2624d13a-6635-4fcc-bfdb-2aeff2225243" />


## 1. Domain: 프로젝트의 핵심

- **Entity**:  
  비즈니스 로직에서 사용되는 **불변 데이터 구조**를 정의.  
  예: `User`, `Product` 등.

- **UseCases**:  
  특정 **작업 단위**를 처리하며, 입력값을 받아 결과를 반환.  
  예: `LoginUseCase`, `FetchUserProfileUseCase`.

- **RepositoryProtocol**:  
  데이터 소스에 접근하는 **추상 인터페이스**로, 구체적인 구현체(API, DB)를 숨기고 도메인 계층에서 사용할 수 있도록 제공.

---

## 2. Data: 데이터 계층

- 로컬 데이터베이스 또는 원격 서버(API)와 통신하며, 데이터를 가공하여 도메인 계층에 전달.
- 데이터 소스와 도메인 계층 사이의 **중재자 역할**을 수행.

---

## 3. Presentation: UI 및 사용자 상호작용

- **ViewModel**:  
  UI 상태를 관리하고, 유스케이스를 호출하여 데이터를 가져오며, 데이터와 UI 간의 바인딩을 담당.

- **View**:  
  UI 요소와 사용자 입력을 처리하며, ViewModel에서 전달받은 데이터를 표시.

---

<img width="200" alt="image" src="https://github.com/user-attachments/assets/090f0d61-5269-4dc3-aa22-61f57710a093" />
<img width="600" alt="image" src="https://github.com/user-attachments/assets/a134fa91-00e6-4d40-80f1-83530da95e11" />

---

## 데이터 흐름 구조

```plaintext
ViewController
     ↓ (이벤트 전달)
ViewModel
     ↓ (로직 실행)
Use Case
     ↓ (데이터 요청)
Repository
     ↓
Data Source (API/DB)
     ↑
Repository
     ↑ (결과 반환)
Use Case
     ↑
ViewModel
     ↑ (바인딩)
ViewController (화면 업데이트)
```

--- 

## 예제




<img width="700" alt="image" src="https://github.com/user-attachments/assets/8ff58980-70bc-43fc-b793-8de4a38e62ac" />

<img width="700" alt="image" src="https://github.com/user-attachments/assets/cc951c2b-9ee1-45ca-ad2c-21d28fa074e8" />

<img width="715" alt="image" src="https://github.com/user-attachments/assets/e648fd58-9208-4e75-a662-7b7836277fce" />

<img width="687" alt="image" src="https://github.com/user-attachments/assets/482a7276-35a5-43ac-b993-8262eb773eb3" />

<img width="685" alt="image" src="https://github.com/user-attachments/assets/c0385529-b5f4-4294-bd10-c748280b642a" />













  
