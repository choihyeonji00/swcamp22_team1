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
1.  **시작하기 전에: 필수 개념 (아주 쉬운 설명)**
2.  **프로젝트 전체 구조**
3.  **데이터 흐름 (주문에서 배달까지)**
4.  **소스 코드 전체 보기 및 해설**
    *   [1. 공용 도구 (JDBCTemplate)](#1-공용-도구-jdbctemplatejava)
    *   [2. 데이터 모델 (DTO)](#2-데이터-모델-dto---배달-가방)
    *   [3. 쿼리 저장소 (XML)](#3-쿼리-저장소-xml---레시피북)
    *   [4. 데이터 접근 (DAO)](#4-데이터-접근-dao---창고-관리자)
    *   [5. 비즈니스 로직 (Service)](#5-비즈니스-로직-service---지배인)
    *   [6. 컨트롤러 (Controller)](#6-컨트롤러-controller---카운터)
    *   [7. 화면 (View - JSP)](#7-화면-view---jsp)
    *   [8. 메인 화면 (index.jsp)](#8-메인-화면-indexjsp)

---

## 1. 💡 시작하기 전에: 필수 개념 (기술 용어 정리)

코드 흐름을 이해하기 위해 꼭 알아야 할 핵심 기술 용어들입니다.

### ① JSP (Java Server Pages) vs 서블릿 (Servlet)
*   **서블릿 (Servlet)**: 자바 언어로 웹 요청을 처리하는 **클래스(.java)**입니다. HTML을 만들기 불편해서 주로 **로직 처리**를 담당합니다.
*   **JSP**: HTML 안에 자바 코드를 섞어 쓸 수 있는 **파일(.jsp)**입니다. HTML 작성이 편해서 주로 **화면 출력**을 담당합니다.
*   *작동 원리*: 사용자가 페이지를 요청하면, 서버(Tomcat)가 JSP를 서블릿 코드로 변환해서 실행합니다.

### ② 동기(Sync) vs 비동기(Async) 처리
*   **동기 처리 (Synchronous)**: 요청을 보내면 응답이 올 때까지 하던 일을 멈추고 기다립니다. (예: 링크 클릭 시 화면이 하얘지며 새 페이지가 뜰 때까지 대기)
*   **비동기 처리 (Asynchronous)**: 요청을 보내놓고, 응답을 기다리지 않고 다른 일을 계속 합니다. (예: 유튜브 보면서 댓글 로딩)

### ③ AJAX (Asynchronous JavaScript and XML)
*   **개념**: 웹 페이지 전체를 새로고침하지 않고, **필요한 데이터만** 서버와 비동기로 교환하는 기술입니다.
*   **장점**: 화면 깜빡임이 없고 속도가 빠릅니다. 우리 프로젝트의 **등록/수정/삭제** 기능에 적용되었습니다.

### ④ Modal (모달)
*   **개념**: 기존 브라우저 창 위에 띄우는 **레이어 팝업**입니다.
*   **특징**: 일반 팝업창(window.open)과 달리 브라우저에 종속적이며, 배경을 어둡게 처리(Backdrop)하여 사용자의 조작을 제어할 수 있습니다.

### ⑤ JDBC & 트랜잭션 (Datebase 통신)
*   **JDBC**: 자바 프로그램이 데이터베이스(DB)와 통신하기 위한 표준 API입니다. (연결, 쿼리 전송, 결과 수신)
*   **트랜잭션 (Transaction)**: 여러 개의 DB 작업을 **하나의 단위**로 묶은 것입니다. "모두 성공(Commit) 아니면 모두 취소(Rollback)"를 보장하여 데이터 무결성을 지킵니다. (예: 메뉴 등록 시 테이블에 데이터가 들어갔어도 커밋하지 않으면 실제 저장되지 않음)

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

### ⑦ static (정적 요소를 위한 키워드)
*   `static` 멤버는 프로그램 시작 시 메모리에 한 번만 할당되어, 객체 생성(`new`) 없이 클래스 이름으로 바로 접근 가능합니다. 공용 도구(`JDBCTemplate`) 등에 사용됩니다.

---

## 2. 🏗️ 프로젝트 전체 구조

```text
src/main
├── java/com/uahan                 
│   ├── common/                    
│   │   └── JDBCTemplate.java      (🔌 DB 연결 도구)
│   └── menu/                      
│       ├── controller/
│       │   └── MenuController.java (🚥 요청 처리반)
│       ├── model/
│       │   ├── dto/                (🍱 데이터 가방)
│       │   │   ├── MenuDTO.java
│       │   │   └── CategoryDTO.java
│       │   ├── dao/                (🛠️ 창고 관리자)
│       │   │   └── MenuDAO.java
│       │   └── service/            (👔 지배인)
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

## 3. 🚀 데이터 흐름 (주문에서 배달까지)

**"메뉴 저장 버튼을 눌렀을 때 무슨 일이 일어나나요?" (AJAX 버전)**

1.  **[화면 (JSP)]**: 사용자가 모달 창에서 데이터를 입력하고 "등록"을 누릅니다.
2.  **[JavaScript]**: 화면이 깜빡이지 않게(AJAX) 몰래 `MenuController`로 데이터를 보냅니다.
3.  **[Controller]**: 데이터를 받아서 `Service`에게 "저장해줘" 시킵니다.
4.  **[Service & DAO]**: DB에 데이터를 저장하고, 성공하면 도장(Commit)을 찍습니다.
5.  **[Controller]**: 성공했다는 신호("success")를 JavaScript에게 보냅니다.
6.  **[JavaScript]**: 신호를 받으면 초록색 알림창("성공!")을 띄우고 목록을 새로고침 합니다.

---

## 4. 📝 소스 코드 전체 보기 및 해설

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
        Properties prop = new Properties(); // 설정값을 읽기 위한 도구
        Connection con = null; // 연결 객체 (처음엔 비어있음)
        
        try {
            // (1) 설정 파일 읽기: resources 폴더에 있는 파일을 찾아서 읽습니다.
            // 여기에 DB 주소, 아이디, 비번이 적혀있습니다.
            prop.load(JDBCTemplate.class.getClassLoader().getResourceAsStream("jdbc-config.properties"));
            
            String url = prop.getProperty("url");
            String user = prop.getProperty("user");
            String password = prop.getProperty("password");

            // (2) 드라이버 등록: "나 MySQL 쓸 거야"라고 자바에 알립니다.
            // 이게 없으면 연결을 못 합니다.
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // (3) 연결 시도: DriverManager라는 애가 드라이버를 이용해서 실제 연결을 만듭니다.
            con = DriverManager.getConnection(url, user, password);

            // (4) 자동 커밋 끄기: *매우 중요*
            // 기본적으로는 SQL 한 줄 실행할 때마다 자동 저장(Commit)되는데,
            // 우리는 여러 작업을 묶어서(트랜잭션) 처리해야 하므로 수동으로 하겠다고 끕니다.
            con.setAutoCommit(false);

        } catch (SQLException e) { 
            e.printStackTrace(); // DB 관련 에러나면 로그 찍어라
        } catch (IOException e) { 
            e.printStackTrace(); // 파일 못 읽으면 로그 찍어라
        } catch (ClassNotFoundException e) { 
            e.printStackTrace(); // 드라이버 없으면 로그 찍어라
        }
        return con; // 만든 연결(전화기)을 반환
    }

    // 2. 연결 닫기 (close)
    // 다 쓴 연결을 안 끊으면 계속 쌓여서 서버가 터집니다. (메모리 누수)
    public static void close(Connection con) {
        try {
            // null이 아니고(연결 자체가 없던게 아니고), !isClosed(아직 안 닫혔으면)
            if (con != null && !con.isClosed()) {
                con.close(); // 닫아라
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Statement는 쿼리를 실어나르는 트럭입니다. 얘도 닫아야 합니다.
    public static void close(Statement stmt) {
        try {
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // ResultSet은 쿼리 결과를 담은 상자입니다. 얘도 닫아야 합니다.
    public static void close(ResultSet rset) {
        try {
            if (rset != null && !rset.isClosed()) {
                rset.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 3. 확정 (commit)
    // 트랜잭션이 성공적으로 끝났을 때 "저장해!"라고 하는 것
    public static void commit(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.commit();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 4. 취소 (rollback)
    // 중간에 에러나서 "없던 일로 해!"라고 하는 것
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

### 2. 데이터 모델 (DTO - 배달 가방)
![Java](https://img.shields.io/badge/Java-MenuDTO.java-EA5442?style=flat&logo=java&logoColor=white)

데이터를 이쪽 파일에서 저쪽 파일로 옮길 때 쓰는 **가방**입니다. 기능은 없고 변수만 있습니다.

```java
package com.uahan.menu.model.dto;

public class MenuDTO {

    // 필드: 메뉴 하나가 가지는 정보들
    // private을 쓴 이유: 남들이 변수에 바로 접근해서 이상한 값 넣을까봐 막아둠.
    private int menuCode;
    private String menuName;
    private int menuPrice;
    private int categoryCode;
    private String categoryName;
    private String orderableStatus;

    // 1. 기본 생성자
    // new MenuDTO() 라고 했을 때 호출됨. 빈 가방을 만듭니다.
    public MenuDTO() {
    }

    // 2. 매개변수 있는 생성자
    // 가방을 만들면서 내용물도 바로 채워넣고 싶을 때 씁니다.
    public MenuDTO(int menuCode, String menuName, int menuPrice, int categoryCode, String orderableStatus) {
        this.menuCode = menuCode;           // 내 가방의 menuCode = 전달받은 menuCode
        this.menuName = menuName;
        this.menuPrice = menuPrice;
        this.categoryCode = categoryCode;
        this.orderableStatus = orderableStatus;
    }

    // 3. Getter / Setter
    // private으로 잠긴 변수를 꺼내거나(get), 값을 넣는(set) 유일한 구멍입니다.
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

    // toString: 가방 안에 뭐가 들었나 확인용 (System.out.println 찍을 때 예쁘게 나오게 함)
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

### 3. 쿼리 저장소 (XML - 레시피북)
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
          null      <!-- 코드는 자동생성(Auto Increment)이라 null -->
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

### 4. 데이터 접근 (DAO - 창고 관리자)
![Java](https://img.shields.io/badge/Java-MenuDAO.java-007396?style=flat&logo=java&logoColor=white)

DB에 직접 접속해서 SQL을 날리는 유일한 담당자입니다.

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

    // 생성자: 이 클래스가 시작되자마자 하는 일
    public MenuDAO() {
        try {
            // 아까 그 XML 파일(레시피북)을 읽어서 머릿속에 외웁니다.
            prop.loadFromXML(MenuDAO.class.getClassLoader().getResourceAsStream("mapper/menu-query.xml"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 1. 전체 메뉴 조회
    public List<MenuDTO> selectAllMenus(Connection con) {
        // 사용할 도구들 미리 선언 (우편 집배원 같은 역할)
        PreparedStatement pstmt = null; 
        ResultSet rset = null; // 결과 담을 바구니
        List<MenuDTO> menuList = null; // 최종 반환할 리스트

        // XML에서 "selectAllMenus"라는 이름의 쿼리를 꺼냅니다.
        String query = prop.getProperty("selectAllMenus");

        try {
            // (1) 쿼리 준비
            pstmt = con.prepareStatement(query);
            // (2) 실행! (executeQuery: 조회용) -> 결과가 rset에 담김
            rset = pstmt.executeQuery();

            menuList = new ArrayList<>();

            // (3) 결과 하나씩 꺼내기 (next()는 다음 줄이 있으면 true)
            while (rset.next()) {
                MenuDTO menu = new MenuDTO();
                // DB에서 읽은 값을 가방(DTO)에 옮겨 담기
                menu.setMenuCode(rset.getInt("menu_code"));
                menu.setMenuName(rset.getString("menu_name"));
                menu.setMenuPrice(rset.getInt("menu_price"));
                // ...
                
                // 가방을 리스트에 추가
                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // (4) 뒷정리 (반드시 해야 함!)
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return menuList; // 다 담은 리스트 반환
    }

    // 2. 메뉴 등록
    public int insertMenu(Connection con, MenuDTO menu) {
        PreparedStatement pstmt = null;
        int result = 0; // 몇 개가 저장됐는지 숫자 (성공하면 1)

        String query = prop.getProperty("insertMenu");

        try {
            pstmt = con.prepareStatement(query);
            
            // 물음표(?) 구멍 채우기
            // "INSERT ... VALUES (?, ?, ?, ?)" 이니까 순서대로 채워야 함
            pstmt.setString(1, menu.getMenuName());
            pstmt.setInt(2, menu.getMenuPrice());
            pstmt.setInt(3, menu.getCategoryCode());
            pstmt.setString(4, menu.getOrderableStatus());

            // 실행! (executeUpdate: 등록/수정/삭제용)
            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result; // "1개 등록됨" 반환
    }

    /* selectMenuById, updateMenu, deleteMenu 등도 위와 똑같이 생겼습니다 */
}
```

---

### 5. 비즈니스 로직 (Service - 지배인)
![Java](https://img.shields.io/badge/Java-MenuService.java-2E7D32?style=flat&logo=java&logoColor=white)

여기서 제일 중요한 건 **Connection(전화기)**을 켜고 끄는 것입니다. 즉, **트랜잭션(모 아니면 도)**을 여기서 관리합니다.

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
        menuDAO = new MenuDAO(); // 일꾼(DAO)을 미리 고용해 둡니다.
    }

    // 메뉴 전체 조회 업무
    public List<MenuDTO> selectAllMenus() {
        // (1) DB 연결 (전화기 듦)
        Connection con = JDBCTemplate.getConnection();
        
        // (2) 일꾼에게 전화기 넘겨주면서 일 시킴
        List<MenuDTO> menuList = menuDAO.selectAllMenus(con);
        
        // (3) 전화 끊기 (조회만 했으니까 커밋은 필요 없음)
        JDBCTemplate.close(con);
        
        return menuList; // 결과 반환
    }

    // 메뉴 등록 업무
    public int registMenu(MenuDTO menu) {
        // (1) DB 연결 (트랜잭션 시작!)
        Connection con = JDBCTemplate.getConnection();
        
        // (2) 일 시킴
        int result = menuDAO.insertMenu(con, menu);

        // (3) ★트랜잭션 결정★
        if (result > 0) {
            // 성공했으면 "도장 쾅! 저장해!"
            JDBCTemplate.commit(con);
        } else {
            // 실패했으면 "야 다 취소해! 없던 일로!"
            JDBCTemplate.rollback(con);
        }
        
        // (4) 전화 끊기
        JDBCTemplate.close(con);

        return result;
    }
}
```

---

### 6. 컨트롤러 (Controller - 카운터)
![Java](https://img.shields.io/badge/Java-MenuController.java-000000?style=flat&logo=java&logoColor=white)

사용자의 요청을 받아서 교통정리를 합니다.
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

    // POST 요청: 등록, 수정, 삭제할 때 (AJAX 전용!)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain;charset=UTF-8"); // "나 그냥 글자만 보낸다"

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

            // ★ 결과 보내기 ★
            // 성공하면 "success", 실패하면 "fail"이라는 글자만 띡 보냄.
            // 그러면 자바스크립트가 알아서 처리함.
            if (result > 0) {
                out.print("success");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("error"); // 에러 났을 때
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
        // "등록하기" 눌렀을 때 실행되는 함수
        document.getElementById('registForm').onsubmit = function(e) {
            e.preventDefault(); // 페이지 새로고침 막음 (중요!)

            // 폼 검증 (빈칸 있나?)
            if (!this.checkValidity()) return;

            // 서버로 몰래 데이터 전송 (AJAX)
            const formData = new FormData(this);
            fetch('${pageContext.request.contextPath}/menu/regist', {
                method: 'POST',
                body: new URLSearchParams(formData),
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            })
            .then(response => response.text())
            .then(result => {
                if (result.trim() === 'success') {
                    // 성공하면 초록색 알림 띄우고 모달 닫음
                    showToast('메뉴가 등록되었습니다.', 'success');
                    closeAllModals();
                    refreshList(); // 목록 새로고침
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
