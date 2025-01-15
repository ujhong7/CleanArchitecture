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

### **프로젝트 개요**

- 인원: 1명
- 기간: 2025.01. ~ 2025.01.

### **한 줄 소개**

- MVVM 패턴과 클린 아키텍처를 적용하여, 사용자 목록을 관리하는 기능을 구현한 예제입니다.   
GitHub API를 통해 사용자 정보를 검색하고, 즐겨찾기 기능을 Core Data와 연동하여 관리합니다.   

### **앱 미리보기**

…

### **기술스택**

- **언어**: Swift
- **라이브러리**: Alamofire, CoreData, RxSwift, Kingfisher, Snapkit
- **아키텍처**: MVVM, Clean Architecture
- **기타**: UIKit, URLSession, NSManagedObjectContext

### **아키텍처 설계**

- **MVVM 패턴**:      
  비즈니스 로직을 ViewModel에 캡슐화하고, UI는 View와 ViewModel 간의 바인딩을 통해 데이터 변경을 반영합니다.    
- **Clean Architecture**:     
  각 레이어가 명확하게 분리되어 있으며, 의존성 역전 원칙을 준수하여 코드의 유지보수성과 확장성을 높였습니다.    
    - **Presentation Layer (View & ViewModel):**   
        - ViewModel은 UI와 상호작용하며, 뷰(View)에서 필요한 데이터를 가공하고 비즈니스 로직을 처리한 후, UI에 바인딩할 준비를 합니다.
        - RxSwift를 활용하여 ViewModel과 View 간 데이터 바인딩을 구현해 상태 변화를 반응형으로 처리하고 UI 업데이트를 간소화했습니다.
        - Observable과 Subject를 통해 비동기 작업과 데이터 흐름을 제어하며, 네트워크 통신 및 데이터 로드 작업을 효율적으로 처리해 사용자 경험을 향상시켰습니다.
          
    - **Domain Layer (Use Case & Entity & RepositoryProtocol):**    
        애플리케이션의 핵심 비즈니스 로직을 담당하며, 데이터 소스를 추상화하고 처리하는 역할을 합니다.    
        - Use case: 특정 작업에 대한 비즈니스 로직을 처리합니다. 사용자 목록을 네트워크에서 가져오거나, 즐겨찾기 사용자 목록을 조회하고 추가/삭제하는 작업을 담당합니다.
        - Entity: 데이터 구조를 정의합니다. UserListItem은 사용자 ID, 이름, 프로필 이미지 등을 포함하며, 데이터 전달의 일관성을 유지합니다.
        - RepositoryProtocol: UserNetwork와 UserCoreData를 추상화하여 데이터 소스의 구체적인 구현과 비즈니스 로직을 분리합니다.
          
    - **Data Layer (Network & Core Data & Repository):**    
        실제 데이터 소스를 관리하는 레이어입니다.   
        - UserNetwork: GitHub API와의 네트워크 통신을 담당합니다.
        - UserCoreData: Core Data를 이용해 사용자 정보를 로컬에 저장 및 관리합니다.
        - UserRepository: 두 데이터 소스를 통합 관리하며, 데이터를 일관성 있게 처리하고 도메인 레이어에 필요한 형태로 제공합니다.

### **구현내용**

- **사용자 목록 검색**:  
    GitHub API를 사용하여 사용자를 검색하는 기능을 구현했습니다. 사용자가 입력한 검색어에 따라 API에서 결과를 받아오고, 해당 데이터를 ViewModel을 통해 UI에 바인딩하여 화면에 표시됩니다. 비동기 방식으로 네트워크 요청을 처리하며, Alamofire를 사용해 HTTP 요청을 수행합니다.
    
- **즐겨찾기 기능**:  
    사용자 정보를 Core Data에 저장하고 관리하는 기능을 구현했습니다. 사용자가 마음에 드는 사용자를 즐겨찾기하여 로컬 데이터베이스에 저장할 수 있으며, 저장된 사용자 목록을 화면에 표시할 수 있습니다. Core Data의 `NSManagedObjectContext`를 사용하여 데이터를 관리하고, 데이터 삽입, 삭제, 조회를 처리합니다.
    
- **네트워크 처리**:  
    Alamofire를 이용하여 GitHub API와 통신하는 네트워크 처리 부분을 구현했습니다. `NetworkManager`를 통해 서버로부터 데이터를 비동기적으로 받아오고, 성공적으로 데이터를 받으면 이를 모델 객체로 변환하여 UI에 전달합니다. 실패 시 에러를 반환하여 UI에서 적절히 처리할 수 있도록 했습니다.
    
- **에러 처리**:  
    네트워크 요청, Core Data 작업 등에서 발생할 수 있는 다양한 오류를 처리하는 로직을 추가했습니다. 예를 들어, 네트워크 요청 시 서버 오류나 데이터가 없을 경우, Core Data에서 데이터를 읽을 수 없을 때 등의 에러를 정의하고, 이를 사용자가 이해할 수 있는 형태로 UI에 반영하도록 했습니다.
    
- **비동기 처리**:  
    네트워크 요청과 데이터 저장/조회 등 비동기 작업을 적절히 처리하기 위해 `async/await`을 활용하여 코드의 가독성을 높였습니다. Alamofire와 Core Data 작업은 비동기로 처리되어 UI가 블로킹되지 않도록 하였습니다.
    
- **의존성 역전 원칙:**  
    각 레이어는 프로토콜을 통해 상호작용하도록 설계하여 결합도를 낮추고 테스트 가능성을 높였습니다.      
    예를 들어, `UserRepository`는 `UserNetwork`와 `UserCoreData`의 구체적인 구현을 알지 못하며, 프로토콜을 통해 호출합니다.      
    이를 통해 레이어 간 의존성을 최소화하고, 변경 시 다른 레이어에 영향을 주지 않도록 설계했습니다.       

- **테스트 코드:**  
    네트워크 및 데이터베이스 의존성 없이 ViewModel의 로직을 검증하는 테스트 코드를 작성했습니다.   
  - **사용자 목록 변환 테스트**: 검색 쿼리에 따라 API에서 반환된 `UserListItem` 데이터를 ViewModel에서 `UserListCellData`로 변환하는 과정을 검증했습니다.   
  - **즐겨찾기 데이터 검증**: Core Data의 즐겨찾기 데이터를 UI에 올바르게 반영하는지 확인했습니다.    


---










--- 

## 예제  
<img src="https://i.imgur.com/fdmxUii.gif" alt="Description of GIF" width="250"/>

### 하트버튼 눌러서 코어데이터 저장하기  
- `UserListViewController` : 이벤트 전달    
![image](https://github.com/user-attachments/assets/df5b57a6-0ab8-44df-8d50-a5824eb47038)     
![image](https://github.com/user-attachments/assets/c44fd059-1b06-4f09-8f39-50426a191a72)    

- `UserListViewModel` : 로직 실행  
![image](https://github.com/user-attachments/assets/40d7fab7-1f29-4073-b797-22c8f5cb7fed)    
![image](https://github.com/user-attachments/assets/b936ce1a-5925-42f8-b205-20742881316f)   
![image](https://github.com/user-attachments/assets/622a1eff-f305-43d6-a462-95fec8e10828)   
![image](https://github.com/user-attachments/assets/0809518f-93f5-418a-9544-8c3304bd536d)    

- `UserListUsecase` : 데이터 요청   
![image](https://github.com/user-attachments/assets/74af047a-c992-42fa-9155-450abca225e2)   

- `UserRepository` : 결과반환   
![image](https://github.com/user-attachments/assets/651e064b-872a-47a0-b52e-71bf807c4e04)   
  
- `UserCoreData`
![image](https://github.com/user-attachments/assets/05de6fca-f081-414c-b55f-cd023897f61b)    

- `UserListViewModel` : 바인딩  
![image](https://github.com/user-attachments/assets/c816fdab-44c4-49e4-bc82-4525f9101cd0)   
![image](https://github.com/user-attachments/assets/b471439f-3d02-499f-b373-046191e6e5fe)   









  
