# 🛵 배달의 민족 사장님 광장 - 팀원을 위한 코드 가이드

<div align="center">
  <img src="https://img.shields.io/badge/Project-Baemin_Menu_System-2AC1BC?style=for-the-badge&logo=baemin&logoColor=white">
  <br/>
  <h3>"자바? 서블릿? 이게 다 뭔가요?"</h3>
  <p>이 문서는 코딩이 낯선 팀원들이 프로젝트의 <b>모든 코드</b>를 한 줄도 빠짐없이 이해할 수 있도록 작성된 <b>친절한 해설서</b>입니다.<br>
  Github 메인화면(README)에서 바로 읽으시면 됩니다.</p>
</div>

---

## 📚 목차
1.  **시작하기 전에: 필수 개념 (기술 용어 정리)**
    *   [1-1. 핵심 기술 용어](#1-💡-시작하기-전에-필수-개념-기술-용어-정리)
    *   [1-2. 초보자를 위한 용어 사전](#1-2-📖-초보자를-위한-용어-사전)
2.  **✨ 주요 기능 소개**
3.  **프로젝트 전체 구조**
4.  **데이터 흐름 (주문에서 배달까지)**
5.  **소스 코드 전체 보기 및 해설**
    *   [1. 공용 도구 (JDBCTemplate)](#1-공용-도구-jdbctemplatejava)
    *   [2. 데이터 모델 (DTO)](#2-데이터-모델-dto)
    *   [3. 쿼리 저장소 (XML)](#3-쿼리-저장소-xml-mapper)
    *   [4. 데이터 접근 (DAO)](#4-데이터-접근-dao)
    *   [5. 비즈니스 로직 (Service)](#5-비즈니스-로직-service)
    *   [6. 컨트롤러 (Controller)](#6-컨트롤러-controller)
    *   [7. 화면 (View - JSP)](#7-화면-view---jsp)
    *   [8. 메인 화면 (index.jsp)](#8-메인-화면-indexjsp)

---

## 1. 💡 시작하기 전에: 필수 개념 (기술 용어 정리)

코드 흐름을 이해하기 위해 꼭 알아야 할 핵심 기술 용어들입니다.

### ① JSP (Java Server Pages) vs 서블릿 (Servlet)
*   **서블릿 (Servlet)**: 자바 언어로 웹 요청을 처리하는 **클래스(.java)**입니다. HTML을 만들기 불편해서 주로 **로직 처리**(계산, 데이터 가공 등)를 담당합니다.
*   **JSP**: HTML 안에 자바 코드를 섞어 쓸 수 있는 **파일(.jsp)**입니다. HTML 작성이 편해서 주로 **화면 출력**(사용자가 보는 페이지)을 담당합니다.
*   *작동 원리*: 사용자가 페이지를 요청하면, 서버(Tomcat)가 JSP를 서블릿 코드로 변환해서 실행합니다.

> **🔍 쉬운 비유:**  
> 서블릿 = 주방의 요리사 (재료를 다듬고 요리함)  
> JSP = 접시와 데코레이션 (요리를 예쁘게 담아 손님에게 내보냄)

### ② 동기(Sync) vs 비동기(Async) 처리
*   **동기 처리 (Synchronous)**: 요청을 보내면 응답이 올 때까지 하던 일을 멈추고 기다립니다.
    *   예: 링크 클릭 시 화면이 하얘지며 새 페이지가 뜰 때까지 대기
*   **비동기 처리 (Asynchronous)**: 요청을 보내놓고, 응답을 기다리지 않고 다른 일을 계속 합니다.
    *   예: 유튜브 보면서 댓글 로딩

> **🔍 쉬운 비유:**  
> **동기** = 은행 창구에서 번호표 뽑고 자기 차례까지 가만히 서서 기다림  
> **비동기** = 음식점에서 주문하고 진동벨 받아서 다른 일 하다가 음식 나오면 받으러 가기

### ③ AJAX (Asynchronous JavaScript and XML)
*   **개념**: 웹 페이지 전체를 새로고침하지 않고, **필요한 데이터만** 서버와 비동기로 교환하는 기술입니다.
*   **장점**: 화면 깜빡임이 없고 속도가 빠릅니다. 우리 프로젝트의 **등록/수정/삭제** 기능에 적용되었습니다.

### ④ Modal (모달)
*   **개념**: 기존 브라우저 창 위에 띄우는 **레이어 팝업**입니다.
*   **특징**: 일반 팝업창(window.open)과 달리 브라우저에 종속적이며, 배경을 어둡게 처리(Backdrop)하여 사용자의 조작을 제어할 수 있습니다.

### ⑤ JDBC & 트랜잭션 (Database 통신)
*   **JDBC**: 자바 프로그램이 데이터베이스(DB)와 통신하기 위한 표준 API입니다.
    *   역할: DB 연결, SQL 쿼리 전송, 결과 수신
*   **트랜잭션 (Transaction)**: 여러 개의 DB 작업을 **하나의 단위**로 묶은 것입니다.
    *   원칙: "모두 성공(Commit) 아니면 모두 취소(Rollback)"
    *   목적: 데이터 무결성 보장 (반쪽짜리 작업이 DB에 남지 않도록)
    *   예: 메뉴 등록 시 테이블에 데이터가 임시로 들어갔어도 Commit하지 않으면 실제 저장되지 않음

> **🔍 쉬운 비유:**  
> **JDBC** = 한국어-영어 통역사 (자바와 DB가 서로 대화할 수 있게 해줌)  
> **트랜잭션** = 택배 배송의 "일괄 처리"  
> - 주문한 물건 3개 중 2개만 도착하면 의미 없음 → 3개 모두 도착하거나, 모두 취소  
> - 메뉴 이름, 가격, 카테고리 중 일부만 저장되면 의미 없음 → 모두 저장 or 모두 취소

> **💡 Commit과 Rollback이란?**  
> **Commit**: "이 작업들 확정! 실제로 저장해!"라는 명령 (도장 쾅!)  
> **Rollback**: "잘못됐어, 방금 한 작업 전부 취소!"라는 명령 (Ctrl+Z와 비슷)

### ⑥ MVC 패턴 (Model - View - Controller)
우리가 코드를 나누는 기준입니다.
*   **Model (데이터 & 로직)**
    *   **DTO (Data Transfer Object)**: 데이터를 담아 나르는 객체 (Getter/Setter만 존재)
    *   **DAO (Data Access Object)**: DB에 실제로 접근하여 SQL을 실행하는 객체
    *   **Service**: 트랜잭션을 관리하고 비즈니스 로직(규칙)을 수행하는 객체
*   **View (화면)**
    *   **JSP**: 사용자에게 보여질 화면(HTML)을 생성
*   **Controller (조정자)**
    *   **Servlet**: 클라이언트의 요청(Request)을 받아 Service에 일을 시키고, 결과에 따라 적절한 View로 보냄

> **🔍 쉬운 비유:**  
> **Model** = 식당의 주방 (재료 보관, 조리 준비)  
> **View** = 손님이 앉는 홀 (음식이 예쁘게 나옴)  
> **Controller** = 종업원 (주문 받아서 주방에 전달, 음식 나오면 손님한테 가져다 줌)

### ⑦ static (정적 요소를 위한 키워드)
*   `static` 멤버는 프로그램 시작 시 메모리에 한 번만 할당되어, 객체 생성(`new`) 없이 클래스 이름으로 바로 접근 가능합니다. 공용 도구(`JDBCTemplate`) 등에 사용됩니다.

> **🔍 쉬운 비유:**  
> **static** = 학교의 공용 술수대  
> - 모든 학생이 공유, 학생 개개인이 따로 가지고 다니지 않음  
> - "교실.static방법()"으로 바로 사용 가능 (학생 객체 생성 불필요)

---

## 1-2. 📖 초보자를 위한 용어 사전

> **"클래스, 객체, 변수, 함수... 이게 다 뭐야?😭"**  
> 걱정 마세요! 하나하나 씹어 드립니다.

### 🔸 프로그래밍 기초 개념

**변수 (Variable)**
- 데이터를 담는 "상자"입니다. 상자에 이름을 붙여서 나중에 꺼내 쓸 수 있습니다.
- 예: `int age = 25;` → "age라는 상자에 25라는 숫자를 넣었어요"

**함수/메서드 (Function/Method)**
- 특정 작업을 수행하는 "명령어 모음"입니다. 여러 코드를 묶어서 이름을 붙여놓으면, 그 이름만 불러도 전체가 실행됩니다.
- 예: `getMenuName()` → "메뉴 이름을 가져와!"

**클래스 (Class)**
- 객체를 만들기 위한 "설계도"입니다. 붕어빵 틀을 생각하면 됩니다.
- 예: `class Car { ... }` → "자동차 틀"

**객체 (Object)**
- 클래스(설계도)를 바탕으로 만든 "실제 상품"입니다. 틀에 반죽을 부어 만든 실제 붕어빵이죠.
- 예: `Car myCar = new Car();` → "자동차 틀로 실제 자동차를 하나 만들었어요"

**필드 (Field) / 속성 (Property)**
- 객체가 가지고 있는 "특성"이나 "데이터"입니다.
- 예: 자동차의 색깔, 속도, 노면 여부 → `myCar.color = "빨강"`, `myCar.speed = 80`

**파라미터 (Parameter) / 인자 (Argument)**
- 함수를 호출할 때 함께 전달하는 "재료"입니다.
- 예: `saveMenu(menuName, price)` → "메뉴 이름과 가격을 주면서 저장해달라고 요청"

**반환값 (Return Value)**
- 함수가 일을 끝냈을 때 돌려주는 "결과물"입니다.
- 예: `int result = add(3, 5);` → "덧셈 함수가 8을 돌려줘서 result에 넣었어요"

### 🔸 웹 기초 개념

**HTML (HyperText Markup Language)**
- 웹 페이지의 "골격"을 만드는 언어입니다. 제목, 버튼, 입력창 등의 위치를 정합니다.
- 예: `<button>클릭</button>` → "버튼 하나 만들기"

**CSS (Cascading Style Sheets)**
- HTML의 "외모"를 꾸미는 언어입니다. 색깔, 크기, 배치 등을 지정합니다.
- 예: `color: red;` → "글자 색을 빨강으로"

**JavaScript**
- 웹 페이지의 "동작"을 만드는 프로그래밍 언어입니다. 버튼 클릭 시 할 일을 정합니다.
- 예: 클릭하면 모달창 열기, 폼 제출 등

**서버 (Server)**
- 데이터를 보관하고 요청에 따라 응답을 보내주는 컴퓨터입니다.
- 비유: 식당의 주방 (주문 받아서 음식 만들어 내보냄)

**클라이언트 (Client)**
- 서버에 요청을 보내고 결과를 받는 컴퓨터(보통 우리 컴퓨터, 스마트폰)입니다.
- 비유: 식당의 손님 (주문하고 음식 받음)

**요청 (Request)**
- 클라이언트가 서버에게 "이거 해주세요!"라고 보내는 메시지입니다.
- 예: "메뉴 목록 보여주세요", "이 메뉴 저장해주세요"

**응답 (Response)**
- 서버가 클라이언트에게 "여기 결과예요!"라고 보내는 데이터입니다.
- 예: HTML 화면, JSON 데이터, "성공/실패" 메시지

### 🔸 데이터베이스 기초 개념

**데이터베이스 (Database, DB)**
- 데이터를 체계적으로 보관하는 "전자 창고"입니다.
- 비유: 도서관의 서가 (책을 분류해서 보관)

**테이블 (Table)**
- 데이터베이스 안의 "표"입니다. 엑셀의 시트를 생각하면 됩니다.
- 예: `tbl_menu` 테이블 = 메뉴 데이터만 모아놓은 표

**컬럼 (Column)**
- 테이블의 "세로 항목"입니다. 엑셀의 A열, B열과 같습니다.
- 예: `menu_name` 컬럼 = 메뉴 이름을 저장하는 칸

**행 (Row) / 레코드 (Record)**
- 테이블의 "가로 데이터 한 줄"입니다. 하나의 항목을 의미합니다.
- 예: "차가운 민트초코칩 / 7,000원 / 3번 카테고리" = 한 행

**SQL (Structured Query Language)**
- 데이터베이스에 "명령"을 내리는 언어입니다.
- 예: `SELECT * FROM tbl_menu` → "메뉴 테이블에서 모든 데이터 가져와"

**쿼리 (Query)**
- DB에 보내는 질문/명령입니다. SQL로 작성합니다.
- 예: "주문 가능한 메뉴만 보여줘!"

### 🔸 기타 중요 개념

**배열 (Array) / 리스트 (List)**
- 여러 개의 데이터를 순서대로 담는 "상자"입니다.
- 예: `["pizza", "chicken", "burger"]` = 메뉴 이름 세 개를 목록으로 저장

**반복문 (Loop)**
- 같은 작업을 여러 번 반복하는 구문입니다.
- 예: `while`, `for` → "목록의 모든 항목에 대해 이 작업을 반복해!"

**조건문 (Conditional Statement)**
- 조건에 따라 다른 동작을 하도록 하는 구문입니다.
- 예: `if (age >= 18)` → "만약 18살 이상이면..."

**null**
- "비어있음" 또는 "값이 없음"을 나타내는 특수한 값입니다.
- 예: 새 가방을 만들면 안에 아무것도 없어요 (null)

---

## 2. ✨ 주요 기능 소개

이 프로젝트는 **배달의 민족 사장님 광장**의 메뉴 관리 시스템을 모티브로 하여, 웹 기반의 **메뉴 관리(CRUD)**를 구현했습니다.

> **💡 CRUD란?**  
> Create(생성), Read(조회), Update(수정), Delete(삭제)의 약자입니다.  
> 쉽게 말해 "데이터를 추가하고, 보고, 고치고, 지우는" 기본적인 4가지 작업을 의미합니다.  
> 예: 연락처 앱에서 친구 추가(C), 친구 목록 보기(R), 전화번호 수정(U), 친구 삭제(D)

### ① 📋 메뉴 목록 조회
*   등록된 모든 메뉴를 카드 형태로 한눈에 확인할 수 있습니다.
*   메뉴의 이름, 가격, 카테고리, 판매 상태(주문 가능/불가)가 표시됩니다.
*   **카드 클릭 시 상세 정보**를 모달창으로 확인할 수 있습니다.

### ② ➕ 메뉴 등록 (Modal 팝업)
*   우측 하단의 **`+` 버튼**을 누르면 메뉴 등록 팝업(Modal)이 뜹니다.
*   화면 이동 없이 간편하게 메뉴 이름, 가격, 카테고리를 입력하여 저장할 수 있습니다.

> **💡 Modal(모달)이란?**  
> 현재 화면 위에 덮어 씌우는 팝업창입니다.  
> 새 페이지로 이동하지 않고, 현재 위치에서 작업을 완료할 수 있어 편리합니다.  
> 예: 인스타그램에서 사진을 클릭하면 뜨는 큰 화면 (페이지 이동 없이 사진만 크게 보임)

### ③ ⚡ 실시간 반응 (AJAX 비동기 통신)
*   **새로고침 없음**: 메뉴를 등록하거나 수정해도 페이지가 깜빡이지 않습니다.
*   **즉시 반영**: 저장 버튼을 누르는 즉시 목록이 자동으로 갱신됩니다.
*   **알림 메시지**: 성공 시 초록색 알림(Toast)이 떠서 처리 결과를 명확히 알려줍니다.

> **💡 AJAX란?**  
> 페이지 전체를 새로고침하지 않고, 필요한 부분만 서버와 데이터를 주고받는 기술입니다.  
> 예: 유튜브에서 '좋아요' 버튼을 누르면 페이지는 그대로인데 하트만 빨갛게 변하는 것

### ④ 🖱️ 개선된 사용자 경험 (UX)
*   **ESC 키**로 모달창을 빠르게 닫을 수 있습니다.
*   **텍스트 드래그 시 모달이 닫히지 않도록 개선**: 입력창에서 텍스트를 선택(드래그)할 때 실수로 마우스가 모달 밖으로 나가도 모달이 꺼지지 않습니다.
*   폼 입력 중 **Enter 키**로 바로 제출할 수 있습니다.

### ⑤ 📱 반응형 디자인
*   PC 화면뿐만 아니라 모바일 환경에서도 보기 편하도록 화면 크기에 맞춰 레이아웃이 자동 조정됩니다.

---

## 3. 🏗️ 프로젝트 전체 구조

```text
src/main
├── java/com/uahan                 
│   ├── common/                    
│   │   └── JDBCTemplate.java      (🔌 DB 연결 도구)
│   └── menu/                      
│       ├── controller/
│       │   └── MenuController.java (🚥 요청 처리반)
│       ├── model/
│       │   ├── dto/                (🍱 데이터 객체)
│       │   │   ├── MenuDTO.java
│       │   │   └── CategoryDTO.java
│       │   ├── dao/                (🛠️ DB 접근 객체)
│       │   │   └── MenuDAO.java
│       │   └── service/            (👔 비즈니스 로직)
│       │       └── MenuService.java
├── resources/                     
│   └── mapper/
│       └── menu-query.xml         (📜 SQL 모음집)
└── webapp/
    ├── index.jsp                  (🏠 메인 대문)
    └── WEB-INF/views/             (🖼️ 보안 화면 파일들)
        ├── menu/
        │   └── list.jsp           (📋 메뉴 목록 + 등록/수정 모달)
        └── common/
            └── error.jsp
```

> **달라진 점!**  
> 예전에는 `regist.jsp` 페이지가 따로 있었는데, 지금은 `list.jsp` 안의 **모달(팝업창)**로 들어갔습니다.  
> 화면 이동 없이 훨씬 빠르고 세련되게 동작합니다! 😎

---

## 4. 🚀 데이터 흐름 (주문에서 배달까지)

**"메뉴 저장 버튼을 눌렀을 때 무슨 일이 일어나나요?" (AJAX 버전)**

1.  **[화면 (JSP)]**: 사용자가 모달 창에서 데이터를 입력하고 "등록"을 누릅니다.
2.  **[JavaScript]**: 화면이 깜빡이지 않게(AJAX) 몰래 `MenuController`로 데이터를 보냅니다.
3.  **[Controller]**: 데이터를 받아서 `Service`에게 "저장해줘" 시킵니다.
4.  **[Service & DAO]**: DB에 데이터를 저장하고, 성공하면 도장(Commit)을 찍습니다.
5.  **[Controller]**: 성공했다는 신호("success")를 JavaScript에게 보냅니다.
6.  **[JavaScript]**: 신호를 받으면 초록색 알림창("성공!")을 띄우고 목록을 새로고침 합니다.

---

## 5. 📝 소스 코드 전체 보기 및 해설

여기서부터는 **파일의 모든 내용**을 보여드리고, **한 줄 한 줄** 설명합니다. 스크롤 압박이 있어도 천천히 읽어보세요.

---

### 1. 공용 도구 (JDBCTemplate.java)
![Java](https://img.shields.io/badge/Java-JDBCTemplate.java-ED8B00?style=flat&logo=semver&logoColor=white)

매번 DB 연결 코드를 짜는 건 귀찮고 실수하기 쉽습니다. 그래서 **"연결(getConnection)", "닫기(close)", "확정(commit)", "취소(rollback)"** 기능을 미리 만들어두고 갖다 쓰는 파일입니다.

```java
package com.uahan.common;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class JDBCTemplate {

    // 1. DB 연결을 가져오는 메서드
    // static이라서 'new JDBCTemplate()' 없이 바로 쓸 수 있습니다.
    public static Connection getConnection() {
        Properties prop = new Properties(); // 설정값을 읽기 위한 객체
        Connection con = null; // 연결 객체
        
        try {
            // (1) 설정 파일 로드: resources 폴더의 jdbc-config.properties 파일을 읽습니다.
            // DB 연결 관련 속성(URL, User, Password)을 로드합니다.
            prop.load(JDBCTemplate.class.getClassLoader().getResourceAsStream("jdbc-config.properties"));
            
            String url = prop.getProperty("url");
            String user = prop.getProperty("user");
            String password = prop.getProperty("password");

            // (2) 드라이버 로드: MySQL JDBC 드라이버 클래스를 메모리에 로드합니다.
            // JDBC 4.0 이상에서는 자동 로딩되지만, 명시적으로 로드하는 것이 좋습니다.
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // (3) 연결 수립: DriverManager를 통해 데이터베이스와 연결된 Connection 객체를 생성합니다.
            con = DriverManager.getConnection(url, user, password);

            // (4) AutoCommit 비활성화: 트랜잭션을 수동으로 관리하기 위해 자동 커밋을 끕니다.
            // 여러 DML 작업을 하나의 트랜잭션으로 묶기 위함입니다.
            con.setAutoCommit(false);

        } catch (SQLException e) { 
            e.printStackTrace(); // DB 관련 에러나면 로그 찍어라
        } catch (IOException e) { 
            e.printStackTrace(); // 파일 못 읽으면 로그 찍어라
        } catch (ClassNotFoundException e) { 
            e.printStackTrace(); // 드라이버 없으면 로그 찍어라
        }
        return con; // 생성된 Connection 객체 반환
    }

    // 2. 연결 종료 (close)
    // 사용한 Connection 객체를 반환하여 리소스 누수(Memory Leak)를 방지합니다.
    public static void close(Connection con) {
        try {
            // Connection이 null이 아니고 닫혀있지 않은 경우에만 close 호출
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Statement 객체 종료: SQL 실행을 담당한 객체를 닫습니다.
    public static void close(Statement stmt) {
        try {
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // ResultSet 객체 종료: 쿼리 실행 결과를 담은 객체를 닫습니다.
    public static void close(ResultSet rset) {
        try {
            if (rset != null && !rset.isClosed()) {
                rset.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 3. 트랜잭션 확정 (commit)
    // 모든 작업이 성공적으로 수행되었을 때 변경 사항을 영구 저장합니다.
    public static void commit(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.commit();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 4. 트랜잭션 취소 (rollback)
    // 작업 중 오류가 발생했을 때 변경 사항을 취소하고 이전 상태로 되돌립니다.
    public static void rollback(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.rollback();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
```

---

### 2. 데이터 모델 (DTO - Data Transfer Object)
![Java](https://img.shields.io/badge/Java-MenuDTO.java-EA5442?style=flat&logo=java&logoColor=white)

데이터를 계층(Layer) 간에 전달할 때 사용하는 **객체**입니다. 로직 없이 순수하게 데이터 필드만 가집니다.

```java
package com.uahan.menu.model.dto;

public class MenuDTO {

    // 필드: 메뉴 정보를 담는 변수들
    // 접근 제어자 private을 사용하여 캡슐화(Encapsulation)를 적용했습니다.
    private int menuCode;
    private String menuName;
    private int menuPrice;
    private int categoryCode;
    private String categoryName;
    private String orderableStatus;

    // 1. 기본 생성자
    // Java Beans 규약에 따라 인자 없는 기본 생성자가 필요합니다.
    public MenuDTO() {
    }

    // 2. 매개변수 있는 생성자
    // 객체 생성과 동시에 필드 값을 초기화합니다.
    public MenuDTO(int menuCode, String menuName, int menuPrice, int categoryCode, String orderableStatus) {
        this.menuCode = menuCode;
        this.menuName = menuName;
        this.menuPrice = menuPrice;
        this.categoryCode = categoryCode;
        this.orderableStatus = orderableStatus;
    }

    // 3. Getter / Setter
    // private 필드에 접근하고 값을 수정하기 위한 메서드입니다.
    public int getMenuCode() {
        return menuCode;
    }

    public void setMenuCode(int menuCode) {
        this.menuCode = menuCode;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public int getMenuPrice() {
        return menuPrice;
    }

    public void setMenuPrice(int menuPrice) {
        this.menuPrice = menuPrice;
    }

    public int getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(int categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getOrderableStatus() {
        return orderableStatus;
    }

    public void setOrderableStatus(String orderableStatus) {
        this.orderableStatus = orderableStatus;
    }

    // toString: 객체의 현재 상태(필드 값)를 문자열로 반환하여 디버깅 등을 돕습니다.
    @Override
    public String toString() {
        return "MenuDTO{" +
                "menuCode=" + menuCode +
                ", menuName='" + menuName + '\'' +
                ", menuPrice=" + menuPrice +
                ", categoryCode=" + categoryCode +
                ", orderableStatus='" + orderableStatus + '\'' +
                '}';
    }
}
```

---

### 3. 쿼리 저장소 (XML Mapper)
![XML](https://img.shields.io/badge/XML-menu--query.xml-orange?style=flat&logo=xml&logoColor=white)

자바 코드 안에 SQL(`SELECT * FROM...`)을 섞어 쓰면 지저분하니까, SQL만 따로 모아둔 파일입니다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
    <comment>Menu CRUD Queries</comment>
    
    <!-- 전체 메뉴 조회 SQL -->
    <!-- key="이름": 자바에서 이 이름으로 쿼리를 찾습니다. -->
    <entry key="selectAllMenus">
        SELECT 
               a.menu_code
             , a.menu_name
             , a.menu_price
             , a.category_code
             , b.category_name
             , a.orderable_status 
          FROM tbl_menu a
          JOIN tbl_category b ON a.category_code = b.category_code
         ORDER BY a.menu_code
    </entry>
    
    <!-- 메뉴 하나 상세 조회 SQL -->
    <entry key="selectMenuById">
        SELECT 
               a.menu_code
             , a.menu_name
             , a.menu_price
             , a.category_code
             , b.category_name
             , a.orderable_status
          FROM tbl_menu a
          JOIN tbl_category b ON a.category_code = b.category_code
         WHERE a.menu_code = ?
    </entry>
    
    <!-- 메뉴 등록 SQL -->
    <!-- 물음표(?)는 나중에 자바에서 값을 채워넣을 자리입니다. -->
    <entry key="insertMenu">
        INSERT 
          INTO tbl_menu 
        (
          menu_code
        , menu_name
        , menu_price
        , category_code
        , orderable_status
        ) 
        VALUES 
        (
          null      <!-- AUTO_INCREMENT 속성이므로 null을 입력하여 자동 생성 -->
        , ?
        , ?
        , ?
        , ?
        )
    </entry>
    
    <!-- 메뉴 수정 SQL -->
    <entry key="updateMenu">
        UPDATE tbl_menu
           SET menu_name = ?
             , menu_price = ?
             , category_code = ?
             , orderable_status = ?
         WHERE menu_code = ?
    </entry>
    
    <!-- 메뉴 삭제 SQL -->
    <entry key="deleteMenu">
        DELETE 
          FROM tbl_menu
         WHERE menu_code = ?
    </entry>

    <!-- 카테고리 목록 조회 SQL (코드 1은 한식, 2는 중식... 보여줄 때 필요) -->
    <entry key="selectAllCategories">
        SELECT
               category_code
             , category_name
             , ref_category_code
          FROM tbl_category
         ORDER BY category_code
    </entry>
</properties>
```

---

### 4. 데이터 접근 (DAO - Data Access Object)
![Java](https://img.shields.io/badge/Java-MenuDAO.java-007396?style=flat&logo=java&logoColor=white)

DB에 직접 접속하여 데이터를 생성, 조회, 수정, 삭제(CRUD)하는 역할을 수행하는 객체입니다.

```java
package com.uahan.menu.model.dao;

import com.uahan.common.JDBCTemplate;
import com.uahan.menu.model.dto.MenuDTO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class MenuDAO {

    private Properties prop = new Properties();

    // 생성자: 클래스 초기화 시 실행
    public MenuDAO() {
        try {
            // XML 파일(SQL 매퍼)을 로드하여 Properties 객체에 저장합니다.
            prop.loadFromXML(MenuDAO.class.getClassLoader().getResourceAsStream("mapper/menu-query.xml"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 1. 전체 메뉴 조회
    public List<MenuDTO> selectAllMenus(Connection con) {
        PreparedStatement pstmt = null; 
        ResultSet rset = null; 
        List<MenuDTO> menuList = null;

        // XML에서 키값을 이용해 실행할 SQL 문을 가져옵니다.
        String query = prop.getProperty("selectAllMenus");

        try {
            // (1) 쿼리 객체 준비
            pstmt = con.prepareStatement(query);
            // (2) 쿼리 실행 (SELECT는 executeQuery 사용) -> 결과 집합(ResultSet) 반환
            rset = pstmt.executeQuery();

            menuList = new ArrayList<>();

            // (3) 결과 집합 순회 (cursor 이동)
            while (rset.next()) {
                MenuDTO menu = new MenuDTO();
                // 컬럼 값을 DTO 객체에 매핑
                menu.setMenuCode(rset.getInt("menu_code"));
                menu.setMenuName(rset.getString("menu_name"));
                menu.setMenuPrice(rset.getInt("menu_price"));
                // ...
                
                // 리스트에 DTO 객체 추가
                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // (4) 리소스 반환 (JDBCTemplate 사용)
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return menuList;
    }

    // 2. 메뉴 등록
    public int insertMenu(Connection con, MenuDTO menu) {
        PreparedStatement pstmt = null;
        int result = 0; // SQL 실행 결과(영향받은 행의 수)

        String query = prop.getProperty("insertMenu");

        try {
            pstmt = con.prepareStatement(query);
            
            // 파라미터 바인딩 (Parameter Binding)
            // SQL의 '?' 위치 홀더에 값을 설정합니다.
            pstmt.setString(1, menu.getMenuName());
            pstmt.setInt(2, menu.getMenuPrice());
            pstmt.setInt(3, menu.getCategoryCode());
            pstmt.setString(4, menu.getOrderableStatus());

            // 쿼리 실행 (INSERT/UPDATE/DELETE는 executeUpdate 사용)
            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result; // 처리된 행의 수 반환
    }

    /* selectMenuById, updateMenu, deleteMenu 등도 위와 똑같이 생겼습니다 */
}
```

---

### 5. 비즈니스 로직 (Service)
![Java](https://img.shields.io/badge/Java-MenuService.java-2E7D32?style=flat&logo=java&logoColor=white)

비즈니스 로직을 수행하고 트랜잭션(Transaction)을 제어하는 계층입니다. `Connection` 객체를 관리합니다.

```java
package com.uahan.menu.model.service;

import com.uahan.common.JDBCTemplate;
import com.uahan.menu.model.dao.MenuDAO;
import com.uahan.menu.model.dto.MenuDTO;
import java.sql.Connection;
import java.util.List;

public class MenuService {

    private final MenuDAO menuDAO;

    public MenuService() {
        menuDAO = new MenuDAO(); // DAO 인스턴스 초기화
    }

    // 메뉴 전체 조회 서비스
    public List<MenuDTO> selectAllMenus() {
        // (1) Connection 생성 (트랜잭션 시작점은 아니나 DB연결 필요)
        Connection con = JDBCTemplate.getConnection();
        
        // (2) DAO 메서드 호출 (Connection 전달)
        List<MenuDTO> menuList = menuDAO.selectAllMenus(con);
        
        // (3) Connection 종료 (조회 작업이므로 Commit 불필요)
        JDBCTemplate.close(con);
        
        return menuList;
    }

    // 메뉴 등록 서비스
    public int registMenu(MenuDTO menu) {
        // (1) Connection 생성 (트랜잭션 시작)
        Connection con = JDBCTemplate.getConnection();
        
        // (2) DAO 메서드 호출
        int result = menuDAO.insertMenu(con, menu);

        // (3) 트랜잭션 처리 (Commit / Rollback)
        if (result > 0) {
            // 성공 시 변경 사항 확정
            JDBCTemplate.commit(con);
        } else {
            // 실패 시 변경 사항 취소
            JDBCTemplate.rollback(con);
        }
        
        // (4) Connection 반환
        JDBCTemplate.close(con);

        return result;
    }
}
```

---

### 6. 컨트롤러 (Controller - Servlet)
![Java](https://img.shields.io/badge/Java-MenuController.java-000000?style=flat&logo=java&logoColor=white)

클라이언트(브라우저)의 요청을 받아 적절한 서비스 로직을 호출하고, 그 결과를 뷰(View)로 전달하는 역할을 합니다.
이번 업데이트로 **AJAX(비동기 통신)**을 지원하도록 업그레이드 되었습니다!

```java
package com.uahan.menu.controller;

import com.uahan.menu.model.dto.MenuDTO;
import com.uahan.menu.model.service.MenuService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/menu/*")
public class MenuController extends HttpServlet {

    private MenuService menuService;

    @Override
    public void init() throws ServletException {
        menuService = new MenuService();
    }

    // GET 요청: 주로 화면을 보여줄 때
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || "/list".equals(pathInfo)) {
            // 메뉴 목록 데이터 준비
            List<MenuDTO> menuList = menuService.selectAllMenus();
            
            // 모달 창에 카테고리(한식, 중식...) 보여주려면 이것도 필요함
            List<CategoryDTO> categoryList = menuService.selectAllCategories();

            req.setAttribute("menuList", menuList);
            req.setAttribute("categoryList", categoryList);

            // AJAX 요청이면 내용물만 주고, 아니면 전체 페이지(list.jsp)를 줌
            String ajaxHeader = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader)) {
                req.getRequestDispatcher("/WEB-INF/views/menu/list_content.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/WEB-INF/views/menu/list.jsp").forward(req, resp);
            }
        } else {
            // 딴 데로 들어오면 다 목록으로 보내버림
            resp.sendRedirect(req.getContextPath() + "/menu/list");
        }
    }

    // POST 요청: 데이터 생성(Create), 수정(Update), 삭제(Delete) 처리 (AJAX)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain;charset=UTF-8"); // 응답 형식을 Plain Text로 설정

        PrintWriter out = resp.getWriter();
        int result = 0;

        try {
            if ("/regist".equals(pathInfo)) {
                // 메뉴 등록 로직...
                result = menuService.registMenu(menu);

            } else if ("/update".equals(pathInfo)) {
                // 메뉴 수정 로직...
                result = menuService.modifyMenu(menu);

            } else if ("/delete".equals(pathInfo)) {
                // 메뉴 삭제 로직...
                result = menuService.deleteMenu(code);
            }

            // 결과 응답
            // 클라이언트(JavaScript)에게 'success' 또는 'fail' 문자열을 응답합니다.
            if (result > 0) {
                out.print("success");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("error"); // 예외 발생 시 에러 메시지 응답
        }
    }
}
```

---

### 7. 화면 (View - JSP)
![JSP](https://img.shields.io/badge/JSP-list.jsp-007396?style=flat&logo=java&logoColor=white)

화면에 **모달(Modal)**들이 숨어있다가 버튼을 누르면 나타납니다.

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>배달의 민족 - 메뉴 관리</title>
</head>
<body>

    <div class="container">
        <!-- 목록 보여주는 곳 -->
        <div class="menu-list" id="menuListContainer">
            <jsp:include page="list_content.jsp" />
        </div>

        <!-- (+) 버튼 -->
        <button onclick="openRegistModal()" class="fab">+</button>
    </div>

    <!-- 1. 등록 모달 (평소엔 숨겨져 있음) -->
    <div id="registModal" class="modal-overlay">
        <div class="modal-content">
            <h2>메뉴 등록</h2>
            <form id="registForm">
                <input type="text" name="menuName" placeholder="메뉴명">
                <input type="number" name="menuPrice" placeholder="가격">
                <!-- ... -->
                <button type="submit">등록하기</button>
            </form>
        </div>
    </div>

    <!-- 2. 알림 토스트 메시지 (초록색 뿅!) -->
    <div id="toast" class="toast">메시지</div>

    <script>
        // 폼 제출(Submit) 이벤트 핸들러
        document.getElementById('registForm').onsubmit = function(e) {
            e.preventDefault(); // 기본 폼 제출 동작(새로고침) 방지

            // 폼 유효성 검사 (Required 속성 등)
            if (!this.checkValidity()) return;

            // AJAX 요청 전송 (Fetch API 사용)
            const formData = new FormData(this);
            fetch('${pageContext.request.contextPath}/menu/regist', {
                method: 'POST',
                body: new URLSearchParams(formData),
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
            .then(response => response.text())
            .then(result => {
                if (result.trim() === 'success') {
                    // 응답 성공 시 UI 업데이트 (Toast 알림, 모달 닫기, 목록 갱신)
                    showToast('메뉴가 등록되었습니다.', 'success');
                    closeAllModals();
                    refreshList(); // 비동기 목록 갱신 호출
                }
            });
        };
    </script>

</body>
</html>
```

---

### 8. 메인 화면 (index.jsp)
![JSP](https://img.shields.io/badge/JSP-index.jsp-007396?style=flat&logo=java&logoColor=white)

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>배달의 민족 - 사장님 광장</title>
</head>
<body>
    <div class="container">
        <!-- '메뉴 관리 시작하기' 버튼 -->
        <a href="menu/list" class="btn-start">메뉴 관리 시작하기</a>
    </div>
</body>
</html>
```

---

<div align="center">
  <h3>🏁 가이드 끝!</h3>
  <p>이제 이 코드들이 어떻게 돌아가는지 눈에 보이시나요?<br>
  어려운 게 있으면 언제든 다시 처음부터 읽어보세요. 화이팅입니다!</p>
</div>
