<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>메뉴 ${empty menu ? '등록' : '수정'}</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
        </head>

        <body>

            <div class="container">
                <header>
                    <div class="header-btn" onclick="history.back()">‹ 뒤로</div>
                    <h1>메뉴 ${empty menu ? '등록' : '수정'}</h1>
                    <div style="width: 30px;"></div>
                </header>

                <div style="padding: 25px;">
                    <form action="${pageContext.request.contextPath}/menu/${empty menu ? 'regist' : 'update'}"
                        method="post">
                        <c:if test="${!empty menu}">
                            <input type="hidden" name="menuCode" value="${menu.menuCode}">
                        </c:if>

                        <div class="form-group">
                            <label class="form-label">메뉴명</label>
                            <input type="text" name="menuName" class="form-input" value="${menu.menuName}"
                                placeholder="예: 맛있는 치킨" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">가격 (원)</label>
                            <input type="number" name="menuPrice" class="form-input" value="${menu.menuPrice}"
                                placeholder="10000" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">카테고리</label>
                            <select name="categoryCode" class="form-select" required>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${category.categoryCode}" ${menu.categoryCode==category.categoryCode
                                        ? 'selected' : '' }>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">주문 가능 상태</label>
                            <select name="orderableStatus" class="form-select">
                                <option value="Y" ${menu.orderableStatus=='Y' ? 'selected' : '' }>주문 가능 (Y)</option>
                                <option value="N" ${menu.orderableStatus=='N' ? 'selected' : '' }>품절 (N)</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">${empty menu ? '등록하기' : '수정하기'}</button>
                    </form>
                </div>
            </div>

        </body>

        </html>