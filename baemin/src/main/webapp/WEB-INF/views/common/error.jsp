<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>오류 발생</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
        <style>
            .error-container {
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                height: 70vh;
                text-align: center;
                padding: 20px;
            }

            .error-icon {
                font-size: 5rem;
                margin-bottom: 20px;
            }

            .error-message {
                font-size: 1.1rem;
                color: #666;
                margin-bottom: 30px;
            }
        </style>
    </head>

    <body>

        <div class="container">
            <header>
                <div style="width: 30px;"></div>
                <h1>오류가 발생했어요</h1>
                <div style="width: 30px;"></div>
            </header>

            <div class="error-container">
                <div class="error-icon">🚧</div>
                <h2>앗! 문제가 생겼어요</h2>
                <br>
                <p class="error-message">
                    요청하신 작업을 처리하는 중 오류가 발생했습니다.<br>
                    잠시 후 다시 시도해 주세요.
                </p>

                <%-- Only show detail message for dev/debugging if strictly needed, otherwise hide for user friendliness
                    --%>
                    <% if(request.getAttribute("message") !=null) { %>
                        <p style="color: #ff5252; font-size: 0.9rem; margin-bottom: 20px;">
                            사유: <%= request.getAttribute("message") %>
                        </p>
                        <% } %>

                            <a href="${pageContext.request.contextPath}/menu/list" class="btn btn-primary"
                                style="padding: 12px 30px;">메뉴 목록으로 돌아가기</a>
            </div>
        </div>

    </body>

    </html>