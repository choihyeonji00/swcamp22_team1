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
    *   [1-1. 핵심 기술 용어](#1-💡-시작하기-전에-필수-개념-기술-분석)
    *   [1-2. 초보자를 위한 용어 사전](#1-2-📖-초보자를-위한-기술-용어-사전)
2.  **✨ 주요 기능 소개**
3.  **프로젝트 전체 구조**
4.  **데이터 흐름 (주문에서 배달까지)**
5.  **소스 코드 전체 보기 및 해설**
    *   [5-1. 데이터 모델 (DTO)](#5-1-데이터-모델-dto - Data-Transfer-Object)
    *   [5-2. 데이터 접근 (DAO)](#5-2-데이터-접근-dao - Data-Access-Object)
    *   [5-3. 비즈니스 로직 (Service)](#5-3-비즈니스-로직-service)
    *   [5-4. 컨트롤러 (Controller)](#5-4-컨트롤러-controller---servlet)
    *   [5-5. 화면 (View - JavaScript AJAX)](#5-5-화면-view---javascript-fetch-api)
    *   [5-6. 화면 및 템플릿 엔진 (JSP, JSTL, EL)](#5-6-화면-및-템플릿-엔진-jsp-jstl-el)
    *   [5-7. 화면 소스 코드 상세 분석 (View Analysis)](#5-7-화면-소스-코드-상세-분석-view-analysis)
    *   [5-8. 심화 개념: 쿼리 스트링과 상태 관리 (State Management)](#5-8-🧠-심화-개념-쿼리-스트링과-상태-관리-state-management)
6.  **마무리 가이드**

---

## 1. 💡 시작하기 전에: 필수 개념 (기술 분석)

코드가 작동하는 원리를 이해하기 위해 필요한 전용 기술 용어들입니다. 모든 개념은 실제 전산 용어로만 설명합니다.

### ① 클래스(Class)와 인스턴스(Instance)
*   **클래스(Class)**: 데이터와 기능을 하나의 단위로 묶어놓은 **설계도(파일)**입니다. 자바에서는 `.java` 파일 하나가 하나의 클래스 정의체가 됩니다.
*   **인스턴스(Instance)**: 클래스라는 설계도를 바탕으로 **컴퓨터 메모리(RAM) 상에 실제로 생성된 실체**입니다. 
*   **선언과 생성**: `MenuService service;`는 변수 선언이며, `service = new MenuService();`는 인스턴스를 메모리에 할당(생성)하는 과정입니다. 이때 생성된 실체를 **객체(Object)**라고도 부릅니다.

### ② AJAX (Asynchronous JavaScript and XML)
*   **정의**: 브라우저가 현재 페이지를 유지한 상태에서, 백그라운드 프로세스를 통해 서버와 데이터를 주고받는 **비동기 통신 기술**입니다.
*   **작동 방식**: JavaScript의 `fetch()` API를 사용하여 서버에 HTTP 요청을 보냅니다. 페이지 전체가 다시 로드되지 않기 때문에 화면 전환이나 깜빡임 없이 데이터만 갱신할 수 있습니다.

### ③ MVC 패턴 (Model - View - Controller)
우리가 코드를 분리하는 전산 아키텍처 규칙입니다.
*   **Model**: 데이터 저장소(DB)와 통신하거나 데이터를 가공하는 로직입니다. (DTO, DAO, Service)
*   **View**: 사용자에게 보여지는 데이터 인터페이스(HTML/JSP)입니다.
*   **Controller**: HTTP 요청을 수신하여 어떤 로직(Service)을 실행할지 결정하고, 그 결과를 어디로 보낼지 제어하는 조정자입니다. (Servlet)

### ④ 트랜잭션 (Transaction)
*   데이터베이스 내에서 하나의 논리적 작업 단위로 취급되는 일련의 연산들입니다.
*   **Commit**: 모든 연산이 성공하여 데이터베이스에 영구적으로 결과를 반영하는 것입니다.
*   **Rollback**: 연산 도중 오류가 발생하여 작업 중인 내용을 모두 취소하고 이전 상태로 복구하는 것입니다.

---

## 1-2. 📖 초보자를 위한 기술 용어 사전

| 용어 | 기술적 설명 |
| :--- | :--- |
| **필드 (Field)** | 클래스 내부에 선언된 변수로, 객체의 상태 데이터를 저장합니다. |
| **메서드 (Method)** | 클래스 내부에서 정의된 함수로, 객체가 수행할 동작을 코드로 구현한 것입니다. |
| **파라미터 (Parameter)** | 메서드 실행 시 외부로부터 전달받는 입력 데이터 변수입니다. |
| **HTTP POST** | 서버의 리소스를 생성하거나 수정하기 위해 데이터를 HTTP Body에 담아 전달하는 방식입니다. |
| **Servlet** | 자바를 사용하여 동적인 웹 콘텐츠를 처리하는 서버 측 기술입니다. |

---

## 2. ✨ 주요 기능 소개

*   **메뉴 목록 및 상세 조회**: 모든 메뉴를 카드 형태로 조회하며, 클릭 시 모달로 상세 정보를 확인합니다.
*   **서버 측 고도화 검색**: 메뉴 이름을 DB의 `LIKE` 연산자를 사용하여 실시간으로 검색합니다.
*   **카테고리 및 상태 필터링**: 카테고리별 분류 및 '품절 제외' 필터를 통해 원하는 메뉴만 빠르게 골라볼 수 있습니다.
*   **하이브리드 다중 정렬**: 이름순(가나다)과 가격순(고가/저가) 정렬을 독립적으로 조합하여 9가지 정렬 결과를 제공합니다.
*   **비동기 메뉴 관리 (CRUD)**: 페이지 이동 없이 메뉴를 등록, 수정, 삭제하며 현재의 필터 상태가 유지됩니다.
*   **실시간 개수 업데이트**: 필터 결과에 따른 메뉴 총 개수를 레이아웃 상단에 즉시 표시합니다.

---

## 3. 🏗️ 프로젝트 전체 구조

```text
src/main
├── java/com/uahan                 
│   ├── common/ JDBCTemplate.java      (🔌 DB 연결 관리)
│   └── menu/                      
│       ├── controller/ MenuController.java (🚥 요청 매핑)
│       ├── model/
│       │   ├── dto/ MenuDTO.java      (🍱 데이터 가방)
│       │   ├── dao/ MenuDAO.java      (🛠️ SQL 실행)
│       │   └── service/ MenuService.java (👔 트랜잭션 관리)
└── webapp/
    ├── index.jsp                      (🏠 메인 대문)
    └── WEB-INF/views/menu/list.jsp    (📋 통합 관리 화면)
```

---

## 4. 🚀 데이터 흐름 (Data Flow)

1.  **Client (Browser)**: JavaScript `fetch()`가 서버로 데이터 전송.
2.  **Controller (Servlet)**: 요청을 해석하고 데이터를 DTO에 담아 Service로 전달.
3.  **Service**: DB 연결을 생성하고 DAO를 호출하며, 결과에 따라 Commit/Rollback 수행.
4.  **DAO**: XML 매퍼에 정의된 SQL을 실행하여 DB와 통신.
5.  **Response**: Controller가 처리 결과를 "success" 등의 텍스트로 응답.
6.  **View (JavaScript)**: 응답 결과를 확인하고 화면의 특정 영역만 `innerHTML`로 갱신.

---

## 5. 소스 코드 분석

### 5-1. 데이터 모델 (DTO - Data Transfer Object)

```java
public class MenuDTO {
    private int menuCode;        // 메뉴 고유 번호
    private String menuName;     // 메뉴 이름
    private int menuPrice;       // 메뉴 가격
    private int categoryCode;    // 카테고리 번호
    private String orderableStatus; // 판매 여부 ('Y'/'N')

    public MenuDTO() {} // 기본 생성자: 변수 선언 시 메모리 공간 확보

    // Getter/Setter: 캡슐화된 필드에 접근하는 인터페이스
    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }
}
```

### 5-2. 데이터 접근 (DAO - Data Access Object)

```java
public class MenuDAO {
    // [고도화된 검색/필터/정렬 메서드]
    public List<MenuDTO> selectMenusWithFilter(Connection con, String searchQuery, 
                                               Integer categoryCode, boolean excludeSoldOut, 
                                               String nameSort, String priceSort) {
        // ... 생략 ...
        String query = prop.getProperty("selectMenusWithFilter");
        pstmt = con.prepareStatement(query);
        
        // 1. 검색어 바인딩 (LIKE %...%)
        pstmt.setString(1, searchQuery); 
        pstmt.setString(2, searchQuery);
        
        // 2. 카테고리 필터 (NULL 체크 처리)
        if (categoryCode == null) {
            pstmt.setNull(3, java.sql.Types.INTEGER);
            pstmt.setNull(4, java.sql.Types.INTEGER);
        } else {
            pstmt.setInt(3, categoryCode);
            pstmt.setInt(4, categoryCode);
        }

        // 3. 품절 제외 여부 및 4. 정렬(nameSort, priceSort) 파라미터 바인딩
        pstmt.setString(5, String.valueOf(excludeSoldOut));
        pstmt.setString(6, nameSort);
        pstmt.setString(7, nameSort);
        pstmt.setString(8, priceSort);
        pstmt.setString(9, priceSort);
        
        // ... 실행 후 List 담기 ...
    }
}
```

> **💡 기술 포인트: 동적 쿼리 바인딩**  
> 하나의 쿼리(`selectMenusWithFilter`)에서 `? IS NULL OR COLUMN = ?` 패턴을 사용하여, 사용자가 선택하지 않은 필터는 무시하고 선택한 필터만 정확히 적용하는 고급 JDBC 기법을 사용합니다.

### 5-3. 비즈니스 로직 (Service)

```java
public class MenuService {
    public int registMenu(MenuDTO menu) {
        Connection con = JDBCTemplate.getConnection(); // 커넥션 획득
        int result = menuDAO.insertMenu(con, menu); // DAO 호출

        // 트랜잭션 제어 (성공 시 커밋, 실패 시 롤백)
        if (result > 0) JDBCTemplate.commit(con);
        else JDBCTemplate.rollback(con);
        
        JDBCTemplate.close(con); // 자원 반납
        return result;
    }

    // [고도화] 필터링된 메뉴 검색 서비스
    public List<MenuDTO> searchMenus(String searchQuery, Integer categoryCode, 
                                     boolean excludeSoldOut, String nameSort, String priceSort) {
        Connection con = JDBCTemplate.getConnection();
        List<MenuDTO> menuList = menuDAO.selectMenusWithFilter(con, searchQuery, categoryCode, 
                                                              excludeSoldOut, nameSort, priceSort);
        JDBCTemplate.close(con);
        return menuList;
    }
}
```

### 5-4. 컨트롤러 (Controller - Servlet)
![Java](https://img.shields.io/badge/Java-MenuController.java-000000?style=flat&logo=java&logoColor=white)

| 코드 라인 / 변수 | 상세 기술 해설 |
| :--- | :--- |
| `String searchQuery` | 브라우저에서 보낸 검색어(`?searchQuery=...`)를 추출합니다. |
| `boolean excludeSoldOut` | 품절 제외 체크박스 상태를 불리언(`true/false`)으로 파싱합니다. |
| `nameSort / priceSort` | 9가지 정렬 조합을 위해 두 개의 정렬 파라미터를 각각 처리합니다. |
| `req.getHeader("X-Requested-With")` | 요청이 AJAX인지 일반 브라우저 주소창 입력인지 구분하는 중요한 단서입니다. |
| `req.getRequestDispatcher` | AJAX인 경우 전체 페이지가 아닌 `list_content.jsp`(목록 조각)만 전송합니다. |

### 5-5. 화면 (View - JavaScript Fetch API)

**서버로 데이터 전송하기 (`sendAjax` 함수)**
1.  **URLSearchParams**: 브라우저 폼 데이터를 `key=value` 형태의 쿼리 스트링으로 직렬화합니다.
2.  **fetch api**: 비동기 네트워크 요청을 수행합니다. `POST` 메서드를 사용하여 데이터를 Body에 담습니다.
3.  **header 설정**: `X-Requested-With`를 통해 서버에게 요청의 종류(AJAX)를 명시합니다.
4.  **Promise 처리**: `.then()` 체이닝을 통해 서버 응답이 도착한 시점에 목록 갱신(`refreshList`)을 수행합니다.

### 5-6. 화면 및 템플릿 엔진 (JSP, JSTL, EL)
![JSP](https://img.shields.io/badge/JSP-JSTL_&_EL-007396?style=flat&logo=java&logoColor=white)

브라우저에 보여줄 최종 화면(HTML)을 만들기 위해 자바 데이터를 HTML에 자연스럽게 섞어 쓰는 기술들을 사용합니다.

#### ① JSP (Java Server Pages)
*   **정의**: HTML 코드 안에 자바 코드를 넣어 동적인 웹 페이지를 만드는 기술입니다.
*   **역할**: 서버에서 실행되어 데이터를 채운 뒤, 최종적으로는 순수 HTML만 브라우저로 보냅니다.

#### ② EL (Expression Language) - `${...}`
*   **정의**: 자바 데이터를 화면에 출력할 때 쓰는 아주 간단한 표현식입니다.
*   **예시**: `${menu.menuName}`
    *   `<%= request.getAttribute("menu").getMenuName() %>`라고 길게 써야 할 코드를 한 줄로 줄여줍니다.
    *   **`${pageContext.request.contextPath}`**: 프로젝트의 기본 주소(루트 경로)를 가져올 때 씁니다.

#### ③ JSTL (JSP Standard Tag Library) - `<c:...>`
*   **정의**: JSP에서 반복문이나 조건문 같은 로직을 HTML 태그처럼 편하게 쓰기 위한 라이브러리입니다.
| 파일/코드 위치 | 기술 설명 |
| :--- | :--- |
| `<%@ taglib ... %>` | JSTL 기능을 이 파일에서 쓰겠다고 선언하는 입구입니다. |
| `<c:forEach ...>` | 서버가 보내준 목록(`${menuList}`)을 반복해서 화면에 출력합니다. |
| `${menu.menuName}` | EL(Expression Language)을 사용하여 자바 객체의 데이터를 출력합니다. |
| `<jsp:include ... />` | 다른 JSP 파일의 내용을 현재 위치에 끼워 넣습니다. (코드 재사용) |
| `${pageContext...}` | 프로젝트의 서버 경로(Context Path)를 자동으로 찾아줍니다. |

### 5-7. 화면 소스 코드 상세 분석 (View Analysis)

가장 핵심적인 두 JSP 파일의 코드를 기술적으로 분석합니다.

#### ① 메뉴 카드 목록 (`list_content.jsp`)
이 파일은 AJAX 요청 시 목록 영역만 갈아끼우기 위한 **HTML 조각**입니다.

```jsp
<%-- 서버에서 보낸 menuList 보따리를 하나씩 꺼내어 카드를 만듭니다 --%>
<c:forEach var="menu" items="${menuList}">
    <%-- 카드 클릭 시 자바스크립트 openModal 함수를 호출하며 데이터를 전달합니다 --%>
    <div class="menu-card" onclick="openModal('${menu.menuCode}', '${menu.menuName}', '${menu.menuPrice}', '${menu.categoryName}', '${menu.categoryCode}', '${menu.orderableStatus}')">
        <div class="menu-info">
            <div class="menu-name">
                ${menu.menuName} <%-- EL을 사용하여 메뉴 이름 출력 --%>
                <%-- 상태값에 따라 css 클래스와 텍스트를 다르게 표시 (삼항 연산자) --%>
                <span class="menu-status ${menu.orderableStatus == 'Y' ? 'status-y' : 'status-n'}">
                    ${menu.orderableStatus == 'Y' ? '주문가능' : '품절'}
                </span>
            </div>
            <div class="menu-price">${menu.menuPrice}원</div>
        </div>
    </div>
</c:forEach>
```

#### ② 메인 관리 화면 (`list.jsp`)
전체 페이지 레이아웃과 **필터/정렬 컨트롤**, 모달 구조가 포함된 핵심 파일입니다.

```jsp
<%-- 1. 고도화된 필터 및 검색창 영역 --%>
<div class="filter-search-controls">
    <div class="menu-count-display">
        총 <span id="menuCount">${menuList.size()}</span>개 메뉴 <!-- 실시간 개수 표시 -->
    </div>
    <div class="search-filter-row">
        <select id="categoryFilter" onchange="performSearch()">...</select>
        <div class="search-box">
            <input type="text" id="searchInput" onkeypress="...">
            <button onclick="performSearch()">검색</button> <!-- 서버측 LIKE 검색 호출 -->
        </div>
    </div>
    <!-- 품절 제외 커스텀 체크박스 -->
    <div class="exclude-soldout-container">
        <label class="exclude-soldout-wrapper">
            <input type="checkbox" id="excludeSoldOut" onchange="performSearch()"> 품절 제외
        </label>
    </div>
    <div class="sort-controls">
        <button id="sortName" onclick="toggleSort('name')">이름순</button>
        <button id="sortPrice" onclick="toggleSort('price')">가격순</button>
    </div>
</div>

<%-- 2. 목록이 들어갈 빈 상자 (AJAX로 이 안의 내용만 바뀝니다) --%>
<div class="menu-list" id="menuListContainer">
    <jsp:include page="list_content.jsp" />
</div>

<%-- 3. 등록/수정 모달 구조 (생략) --%>
<div id="registModal" class="modal-overlay">...</div>
<div id="updateModal" class="modal-overlay">...</div>
```

> **💡 기술 포인트: 상태 유지형 AJAX (`performSearch`)**  
> 검색 조건이 바뀔 때마다 `URLSearchParams`를 사용하여 모든 필터 상태(검색어, 카테고리, 품절여부, 정렬)를 주소창에 업데이트하고 동시에 서버로 보내, 화면 새로고침 없이도 현재 상태를 완벽히 유지합니다.
#### ③ 메인 입구 페이지 (`index.jsp`)
서비스의 첫 대문 역할을 하는 페이지입니다.

```jsp
<%-- 프로젝트의 스타일시트(CSS)를 연결합니다 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

<div class="landing-container">
    <div class="logo">배달의 민족<br>사장님 광장</div>
    <p class="subtitle">우리 가게 메뉴를 쉽고 간편하게 관리하세요</p>

    <%-- 버튼 클릭 시 '/menu/list' 주소로 이동하는 링크입니다 --%>
    <a href="menu/list" class="btn-start">메뉴 관리 시작하기</a>
</div>

---

## 5-8. 🧠 심화 개념: 쿼리 스트링과 상태 관리 (State Management)

우리 프로젝트에서 가장 중요한 "사용자 경험"을 만드는 기술입니다.

1.  **쿼리 스트링 (Query String)**: `?searchQuery=치킨&categoryCode=1` 처럼 URL 뒤에 붙는 데이터입니다. 서버는 이를 보고 어떤 데이터를 뽑아줄지 결정합니다.
2.  **History API (`pushState`)**: 페이지 이동 없이 브라우저의 주소창 URL만 살짝 바꾸는 기술입니다. 이를 통해 사용자가 '새로고침'을 해도 방금 보던 검색 결과가 그대로 유지됩니다.
3.  **다중 조건 정렬 로직**: 이름순과 가격순을 각각 `asc`(오름차순), `desc`(내림차순), `""`(해제)의 3가지 상태로 관리하여 조합합니다.

#### ④ 오류 안내 페이지 (`error.jsp`)
예상치 못한 문제가 생겼을 때 사용자에게 보여주는 안내 화면입니다.

```jsp
<%-- 서버에서 넘겨준 에러 메시지가 있다면 화면에 출력합니다 --%>
<% if(request.getAttribute("message") != null) { %>
    <p style="color: #ff5252;">
        사유: <%= request.getAttribute("message") %> <!-- JSP 스크립틀릿 문법 -->
    </p>
<% } %>

<%-- 다시 안전한 목록 페이지로 돌아가는 버튼입니다 --%>
<a href="${pageContext.request.contextPath}/menu/list" class="btn btn-primary">
    메뉴 목록으로 돌아가기
</a>
```

---

## 6. 마무리 가이드

이 프로젝트의 핵심은 **"상태를 유지하며 데이터만 교체하는 세련된 통신(AJAX)"**과 **"역할 분담을 확실히 하는 구조(MVC)"**입니다.

*   **DTO**: 데이터가 담긴 상자
*   **DAO**: 상자를 들고 DB로 가는 일꾼
*   **Service**: 일꾼을 관리하고 일이 완벽한지 확인(Transaction)하는 감독관
*   **Controller**: 외부 손님(Browser)을 맞이하는 안내 데스크

> **💡 팀원분들께**  
> "인스턴스를 생성한다"는 것은 설계도(클래스)를 보고 실제 물건(객체)을 만들어 메모리에 올린다는 뜻입니다. 우리가 짠 코드가 비로소 생명력을 얻는 순간입니다.  
> 🚀 궁금한 점은 언제든 질문해 주세요! 화이팅입니다! 💖
