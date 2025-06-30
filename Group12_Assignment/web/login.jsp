<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String savedUsername = "";
    String savedPassword = "";

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("username".equals(c.getName())) {
                savedUsername = c.getValue();
            } else if ("password".equals(c.getName())) {
                savedPassword = c.getValue();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>SecondUni - Login</title>
        <link rel="stylesheet" href="assets/css/login.css">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="stylesheet" href="assets/css/responsive.css">
    </head>

    <body>
        <div class="container">
            <img class="logo" src="${pageContext.request.contextPath}/assets/icon/logo-white.png" alt="Logo"/>

            <div class="login-box">
                <h1 class="box-title">Đăng nhập</h1>

                <form action="login" method="post">
                    <div class="input-group">
                        <input type="text" name="username" placeholder="Email" value="<%= savedUsername %>" required />
                    </div>

                    <div class="input-group" style="position: relative;">
                        <input type="password" name="password" id="password" placeholder="Mật khẩu" value="<%= savedPassword %>" required />
                        <img id="togglePassword"
                             src="assets/icon/eye-close.png"
                             data-open="assets/icon/eye-open.png"
                             data-close="assets/icon/eye-close.png"
                             alt="Toggle Password"
                             />
                    </div>

                    <div class="remember-container">
                        <div class="remember-left">
                            <input type="checkbox" id="remember" name="remember" <%= (!savedUsername.isEmpty()) ? "checked" : "" %> />
                            <label for="remember">Ghi nhớ tôi</label>
                        </div>

                        <c:if test="${not empty error}">
                            <p class="error-text">${error}</p>
                        </c:if>
                    </div>

                    <input type="submit" value="Đăng nhập" class="submit-btn"/>
                </form>

                <div class="login-signup">
                    Bạn chưa có tài khoản? <a href="signup.jsp">Đăng ký</a>
                </div>
            </div>
        </div>

        <!-- Script hiện/ẩn mật khẩu -->
        <script src="assets/js/show_password.js"></script>


    </body>
</html>
