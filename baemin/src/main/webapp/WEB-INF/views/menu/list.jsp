<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>배달의 민족 - 메뉴 관리</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

            <%-- Fallback Icon Logic (Inline for simplicity or move to backend completely) --%>
                <%-- Using JSTL Logic in logic bean is better, but here we assume icon is handled effectively or use
                    simple map --%>
        </head>

        <body>

            <div class="container">
                <header>
                    <a href="${pageContext.request.contextPath}/" class="header-btn">‹ 홈</a>
                    <h1>메뉴 관리</h1>
                    <div style="width: 30px;"></div> <!-- Spacer -->
                </header>

                <div class="menu-list">
                    <c:forEach var="menu" items="${menuList}">
                        <div class="menu-card"
                            onclick="openModal('${menu.menuCode}', '${menu.menuName}', '${menu.menuPrice}', '${menu.categoryName}', '${menu.orderableStatus}')">
                            <div class="menu-icon">🍽️</div> <!-- Placeholder icon, logic can be improved -->
                            <div class="menu-info">
                                <div class="menu-name">
                                    ${menu.menuName}
                                    <span class="menu-status ${menu.orderableStatus == 'Y' ? 'status-y' : 'status-n'}">
                                        ${menu.orderableStatus == 'Y' ? '주문가능' : '품절'}
                                    </span>
                                </div>
                                <div class="menu-price">${menu.menuPrice}원</div>
                                <div style="font-size: 0.8rem; color: #888; margin-top: 5px;">${menu.categoryName}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Floating Action Button for Registration -->
                <a href="${pageContext.request.contextPath}/menu/regist" class="fab">+</a>
            </div>

            <!-- Modal -->
            <div id="menuModal" class="modal-overlay">
                <div class="modal-content">
                    <button class="btn-close" onclick="closeModal()">×</button>
                    <h2 class="modal-title" id="modalTitle">메뉴 상세</h2>

                    <div class="modal-body">
                        <p><span class="modal-label">메뉴명</span> <span class="modal-value" id="modalName"></span></p>
                        <p><span class="modal-label">가격</span> <span class="modal-value" id="modalPrice"></span></p>
                        <p><span class="modal-label">카테고리</span> <span class="modal-value" id="modalCategory"></span>
                        </p>
                        <p><span class="modal-label">상태</span> <span class="modal-value" id="modalStatus"></span></p>
                    </div>

                    <div class="modal-actions">
                        <button class="btn btn-primary" id="btnUpdate">수정</button>
                        <button class="btn btn-danger" onclick="deleteMenu()">삭제</button>
                    </div>

                    <form id="deleteForm" action="${pageContext.request.contextPath}/menu/delete" method="post"
                        style="display:none;">
                        <input type="hidden" name="menuCode" id="deleteMenuCode">
                    </form>
                </div>
            </div>

            <script>
                const modal = document.getElementById('menuModal');
                const updateBtn = document.getElementById('btnUpdate');
                const deleteInput = document.getElementById('deleteMenuCode');

                function openModal(code, name, price, category, status) {
                    document.getElementById('modalName').innerText = name;
                    document.getElementById('modalPrice').innerText = price + '원';
                    document.getElementById('modalCategory').innerText = category; // You might want to map code to name if available
                    document.getElementById('modalStatus').innerText = status === 'Y' ? '주문가능' : '품절';

                    deleteInput.value = code;
                    updateBtn.onclick = function () {
                        location.href = '${pageContext.request.contextPath}/menu/update?menuCode=' + code;
                    };

                    modal.style.display = 'flex';
                }

                function closeModal() {
                    modal.style.display = 'none';
                }

                function deleteMenu() {
                    if (confirm("정말 이 메뉴를 삭제하시겠습니까?")) {
                        document.getElementById("deleteForm").submit();
                    }
                }

                // Close modal when clicking outside
                window.onclick = function (event) {
                    if (event.target == modal) {
                        closeModal();
                    }
                }
            </script>

        </body>

        </html>