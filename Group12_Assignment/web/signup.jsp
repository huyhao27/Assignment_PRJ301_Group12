<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SecondUni - SignUp</title>
        <link rel="stylesheet" href="assets/css/signup.css">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="stylesheet" href="assets/css/responsive.css">
        <link rel="stylesheet" href="assets/icon/themify-icons/themify-icons.css">
    </head>
    <body>
        <div class="container">
            <img class="logo" src="${pageContext.request.contextPath}/assets/icon/logo-white.png" alt="Logo"/>
            <div class="signup-box">
                <h2 class="box-title">Đăng ký</h2>

                <form id="signupForm" action="${pageContext.request.contextPath}/register" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="input-group">
                        <input type="text" name="name" placeholder="Tên hiển thị" required>
                    </div>
                    <div class="input-group">
                        <input type="text" name="phone" placeholder="Số điện thoại" required>
                    </div>

                    <div class="input-group">
                        <input type="text" name="email" placeholder="Nhập email" required>
                    </div>
                    <div class="input-group" style="position: relative;">
                        <input type="password" name="password" id="password" placeholder="Nhập mật khẩu" required />
                        <img id="togglePassword"
                             src="assets/icon/eye-close.png"
                             data-open="assets/icon/eye-open.png"
                             data-close="assets/icon/eye-close.png"
                             alt="Toggle Password"
                             />
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                        <input type="submit" class="submit-btn" value="Đăng ký" />
                </form>

                <div class="login-signup">
                    Bạn đã có tài khoản rồi? <a href="login.jsp">Đăng nhập</a>
                </div>
                
            </div>
        </div>
                    
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.5/jquery.validate.min.js"></script>
        <script src="assets/js/show_password.js"></script>
        <script src="assets/js/validate.js"></script>
    </body>
</html>