<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>SecondUni - Login</title>
        <link rel="stylesheet" href="assets/css/login.css">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="stylesheet" href="assets/css/responsive.css">
        <link rel="stylesheet" href="assets/icon/themify-icons.css">

    </head>
    <%
    String savedUsername = "";
    String savedPassword = "";

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("username")) {
                savedUsername = c.getValue();
            } else if (c.getName().equals("password")) {
                savedPassword = c.getValue();
            }
        }
    }
    %>

    <body>
        <div class="container">
            <img class="logo" src="${pageContext.request.contextPath}/assets/icon/logo-white.png" alt="Logo"/>

            <div class="login-box">
                <h1 class="box-title">Đăng nhập</h1>

                <form action="login" method="post">
                    <div class="input-group">
                        <input type="text" name="username" placeholder="Email" value="<%= savedUsername %>"required />
                    </div>

                    <div class="input-group" style="position: relative;">
                        <input type="password" name="password" id="password" placeholder="Mật khẩu" value="<%= savedPassword %>"required />
                        <i class="ti-eye toggle-password"
                           style="position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
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


        <script>

            document.addEventListener("DOMContentLoaded", function () {
                const toggle = document.getElementById("togglePassword");
                const password = document.getElementById("password");

                toggle.addEventListener("click", function () {
                    const type = password.getAttribute("type") === "password" ? "text" : "password";
                    password.setAttribute("type", type);

                    // Đổi màu khi hiện/ẩn thay vì đổi icon
                    this.style.color = type === "text" ? "gray" : "black";
                });
            });
            document.addEventListener("DOMContentLoaded", function () {
                const toggles = document.querySelectorAll(".toggle-password");

                toggles.forEach(function (toggle) {
                    toggle.addEventListener("click", function () {
                        const passwordInput = this.previousElementSibling;

                        if (passwordInput && passwordInput.type === "password") {
                            passwordInput.type = "text";
                            this.style.color = "gray";
                        } else {
                            passwordInput.type = "password";
                            this.style.color = "black";
                        }
                    });
                });
            });

        </script>

    </body>
</html>
